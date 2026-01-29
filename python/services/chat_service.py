import json
import os
from typing import List, Dict, Any, Generator
import dashscope
from dashscope.api_entities.dashscope_response import Role
import numpy as np
from http import HTTPStatus
from dotenv import load_dotenv

load_dotenv()

dashscope.api_key = os.getenv("DASHSCOPE_API_KEY")

VECTOR_STORE_PATH = "../data/vector_store.json"

class VectorStore:
    def __init__(self):
        self.data = {}
        self.embeddings = []
        self.ids = []
        self.load_data()

    def load_data(self):
        if os.path.exists(VECTOR_STORE_PATH):
            with open(VECTOR_STORE_PATH, 'r', encoding='utf-8') as f:
                self.data = json.load(f)
                for pid, item in self.data.items():
                    if 'embedding' in item and item['embedding']:
                        self.embeddings.append(item['embedding'])
                        self.ids.append(pid)
        self.embeddings = np.array(self.embeddings)

    def search(self, query_embedding: List[float], top_k: int = 3) -> List[Dict]:
        if len(self.embeddings) == 0:
            return []
        
        # Calculate cosine similarity
        query_vec = np.array(query_embedding)
        norm_query = np.linalg.norm(query_vec)
        norm_embeddings = np.linalg.norm(self.embeddings, axis=1)
        
        cosine_similarities = np.dot(self.embeddings, query_vec) / (norm_embeddings * norm_query)
        
        # Get top k indices
        top_indices = np.argsort(cosine_similarities)[-top_k:][::-1]
        
        results = []
        for idx in top_indices:
            pid = self.ids[idx]
            item = self.data[pid]
            results.append({
                "id": pid,
                "score": float(cosine_similarities[idx]),
                "content": item.get('content', ''),
                "metadata": item.get('metadata', {})
            })
        return results

vector_store = VectorStore()

def get_embedding(text: str) -> List[float]:
    resp = dashscope.TextEmbedding.call(
        model=dashscope.TextEmbedding.Models.text_embedding_v1,
        input=text
    )
    if resp.status_code == HTTPStatus.OK:
        return resp.output['embeddings'][0]['embedding']
    else:
        print(f"Embedding failed: {resp}")
        return []

SYSTEM_PROMPT = """你是一个智能客服助手，专门为用户推荐和解答关于智能城市、物流、制造等领域的软件解决方案。
你的名字是“智能客服”。
利用以下提供的产品信息来回答用户的问题。如果用户询问的产品不在信息中，请诚实告知。
当用户表达出明确的预约、咨询意向，或者对某个具体产品表现出浓厚兴趣时，请务必使用 `showReservationCard` 工具来展示预约卡片。
"""

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "showReservationCard",
            "description": "当用户想要预约、咨询特定商品，或对某个商品感兴趣想要进一步联系时，展示预约卡片",
            "parameters": {
                "type": "object",
                "properties": {
                    "productName": {
                        "type": "string",
                        "description": "用户感兴趣的商品名称"
                    },
                    "productId": {
                        "type": "string",
                        "description": "用户感兴趣的商品ID"
                    }
                },
                "required": ["productName", "productId"]
            }
        }
    }
]

def stream_chat(message: str, history: List[Dict]) -> Generator[str, None, None]:
    # 1. RAG Retrieval
    query_embedding = get_embedding(message)
    relevant_docs = vector_store.search(query_embedding)
    
    context = "\n\n".join([f"产品ID: {doc['id']}\n内容: {doc['content']}" for doc in relevant_docs])
    
    messages = [{'role': 'system', 'content': SYSTEM_PROMPT + f"\n\n参考产品信息:\n{context}"}]
    
    # Convert history
    for msg in history:
        messages.append({'role': msg['role'], 'content': msg['content']})
    
    messages.append({'role': 'user', 'content': message})

    # 2. Call Model
    responses = dashscope.Generation.call(
        model='qwen-turbo', # Or use qwen-max, glm-4 from config if mapped. qwen-turbo is safer standard.
        messages=messages,
        result_format='message',
        stream=True,
        tools=TOOLS,
        enable_search=True # Optional
    )

    # Track previous content length for delta calculation
    previous_content = ""
    reservation_card_shown = False

    for response in responses:
        if response.status_code == HTTPStatus.OK:
            output = response.output
            if output and output.choices:
                choice = output.choices[0]
                # DashScope returns accumulated content by default
                full_content = choice.message.content or ""
                
                # Calculate delta
                delta = full_content[len(previous_content):]
                previous_content = full_content
                
                # Check for tool calls (only process once)
                tool_calls = choice.message.get('tool_calls')
                if tool_calls and not reservation_card_shown:
                    for tool_call in tool_calls:
                        if tool_call['function']['name'] == 'showReservationCard':
                            reservation_card_shown = True
                            args = json.loads(tool_call['function']['arguments'])
                            # Generate the magic JSON block for frontend
                            magic_json = {
                                "__action__": "SHOW_RESERVATION_CARD",
                                "productName": args.get("productName"),
                                "productId": args.get("productId")
                            }
                            # Yield proper markdown JSON block
                            yield f"\n```json\n{json.dumps(magic_json, ensure_ascii=False)}\n```\n"
                            
                            # Optionally yield a text confirming action
                            yield "\n\n为您准备了预约卡片，请点击填写。\n"
                
                if delta:
                    yield delta
        else:
            yield f"Error: {response.message}"

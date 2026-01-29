from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from typing import List, Dict, Any
from services.chat_service import stream_chat
import json

router = APIRouter(prefix="/api/chat", tags=["chat"])

class ChatRequest(BaseModel):
    message: str
    history: List[Dict[str, str]] = []

@router.post("/stream")
async def chat_stream(request: ChatRequest):
    def event_generator():
        for chunk in stream_chat(request.message, request.history):
            if chunk:
                # SSE format: data: <content>\n\n
                # We need to handle newlines in the content usually by escaping or just sending raw.
                # However, common SSE clients read 'data: ' and the rest of the line.
                # If content has newlines, it should be strictly formatted.
                # But looking at ChatWindow.vue: 
                # buffer += decoder.decode(value, { stream: true })
                # let lines = buffer.split('\n')
                # for (const line of lines) { if (line.startsWith('data:')) ... }
                # So it expects single line data per chunk usually.
                # For multiline content, we usually replace \n with \\n json encoded or send multiple data lines.
                # BUT, simpler approach: yield JSON encoded string.
                # Vue code: let content = trimmedLine.substring(5)
                # It just appends content.
                # So we should replace \n with nothing? no.
                # If chunk contains newlines, we should split it.
                
                lines = chunk.split('\n')
                for line in lines:
                    yield f"data: {line}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")

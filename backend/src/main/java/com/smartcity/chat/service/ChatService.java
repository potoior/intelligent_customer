package com.smartcity.chat.service;

import com.smartcity.chat.function.ShowReservationCard;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import java.util.ArrayList;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChatService {

    private final ChatModel chatModel;
    private final VectorStore vectorStore;

    private static final String SYSTEM_PROMPT = """
            你是一个专业的城市智慧服务助手。你的目标是帮助用户了解产品信息，并在用户感兴趣时引导预约。
            
            【核心准则】：
            如果参考知识库信息显示为“暂无相关资料”，请务必直接回复：“抱歉，在知识库中没有查找到相关内容。”，严禁胡乱猜测或使用模型自带的通用知识回答产品问题。
            
            参考知识库信息：
            {context}
            
            如果用户询问商品信息，请依据知识库回答。
            如果你推荐了某个商品，请遵循以下【排版律令】进行 Markdown 输出：
            
            1. **标题空格**: `###` 符号与文字之间【必须】保留一个空格。正确：`### 🏷️ 商品名`。错误：`###🏷️`。
            2. **强制换行**: 标题 `###` 必须独立占一行。严禁标题后直接跟随正文。
            3. **强制链接**: 严禁只写“点击浏览详情”字样，必须使用 Markdown 链接格式：`[点击浏览详情](具体URL地址)`。URL 必须完整。
            4. **列表规范**: 每个 `-` 列表项必须换行，且 `-` 后必须有空格。
            5. **凭证包裹**: 账号和密码必须用反引号包裹，如：`admin`。
            
            建议输出模板（严禁自行合并行）：
            
            好的，为您找到以下产品：
            
            ### 🏷️ {商品名称}
            
            **所属行业**：{行业} | **产品类型**：{类型}
            
            **✨ 功能亮点**：
            - {亮点A}
            - {亮点B}
            
            **🔗 访问信息**：
            - **体验链接**: [点击浏览详情]({具体URL})
            - **登录账号**: `{账号}`
            - **登录密码**: `{密码}`
            
            ---
            
            {推荐理由}
            
            如果用户想要预约，我会为您弹出预约卡片。
            
            【重要指令 - 请务必严格执行】
            只有在决定要弹出卡片时，才在回复最末尾输出 JSON，且必须使用 ```json 包裹：
            
            ```json
            {"__action__": "SHOW_RESERVATION_CARD", "productName": "{商品名称}", "productId": "{商品ID}"}
            ```
            """;

    // 关键逻辑：流式对话处理。在此处执行 RAG（检索增强生成）
    public Flux<ChatResponse> streamChat(String userMessage, List<Map<String, String>> history) {
        // --- 1. 向量检索 (Retrieve) ---
        // 根据用户当前输入的问题，去向量库（SimpleVectorStore）中搜索最相似的内容
        // withTopK(3) 表示取匹配度最高的前 3 条记录
        // withSimilarityThreshold(0.2) 表示相似度必须大于 0.2 才返回，过滤掉无关紧要的干扰项
        List<Document> similarDocuments = vectorStore.similaritySearch(
                SearchRequest.query(userMessage)
                        .withTopK(3)
        //                .withSimilarityThreshold(0.2)
        );
        
        // 将检索到的“知识片段”拼接成一整段上下文文本
        String context = similarDocuments.stream()
                .map(Document::getContent)
                .collect(Collectors.joining("\n\n"));

        // --- 2. 构造提示词 (Augment) ---
        // 将获取到的背景知识填充进 SYSTEM_PROMPT 的 {context} 占位符中
        String finalSystemText = SYSTEM_PROMPT.replace("{context}", context.isEmpty() ? "暂无相关资料" : context);

        List<Message> messages = new ArrayList<>();
        messages.add(new SystemMessage(finalSystemText));

        if (history != null) {
            for (Map<String, String> h : history) {
                String role = h.get("role");
                String content = h.get("content");
                if (content == null || content.isEmpty()) continue;
                
                if ("user".equals(role)) {
                    messages.add(new UserMessage(content));
                } else if ("assistant".equals(role)) {
                    messages.add(new AssistantMessage(content));
                }
            }
        }

        // Add latest message
        messages.add(new UserMessage(userMessage));

        Prompt prompt = new Prompt(messages);
       
       // 3. Call AI Stream
       // chatModel.stream(Prompt) 返回 Flux<ChatResponse>
       try {
            return chatModel.stream(prompt);
       } catch (Exception e) {
           log.error("Error initiating chat stream", e);
           return Flux.error(e);
       }
    }
}

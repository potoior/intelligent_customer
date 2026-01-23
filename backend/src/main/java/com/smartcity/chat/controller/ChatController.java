package com.smartcity.chat.controller;

import com.smartcity.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*") 
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    /**
     * 流式对话接口。
     * 使用 POST 请求以支持发送复杂的对话历史和较长的用户意图。
     * 返回类型为 Flux<ServerSentEvent<String>>，每一条消息都是一个符合 SSE 规范的数据包。
     * 这种方式比返回 Flux<String> 更稳健，能更好地处理多行文本。
     */
    @PostMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<String>> streamMessage(@RequestBody Map<String, Object> payload) {
        // 从请求体中提取当前用户的提问
        String userMessage = (String) payload.get("message");
        // 提取前端传来的历史记录，用于保持对话上下文
        List<Map<String, String>> history = (List<Map<String, String>>) payload.get("history");
        
        // 调用 Service 层进入 RAG 检索 + LLM 生成流程
        return chatService.streamChat(userMessage, history)
                .map(response -> {
                    // 如果响应为空，则返回空包
                    if (response == null || response.getResults() == null || response.getResults().isEmpty()) {
                        return ServerSentEvent.<String>builder().data("").build();
                    }
                    
                    // 获取生成结果的第一个候选答案
                    Generation generation = response.getResults().get(0);
                    if (generation == null || generation.getOutput() == null) {
                        return ServerSentEvent.<String>builder().data("").build();
                    }
                    
                    // 提取文本内容并包装成 ServerSentEvent
                    String content = generation.getOutput().getContent();
                    return ServerSentEvent.<String>builder()
                            .data(content != null ? content : "")
                            .build();
                });
    }
}

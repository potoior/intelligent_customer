package com.smartcity.chat.function;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Description;
import org.springframework.stereotype.Component;

import java.util.function.Function;

@Component
@Description("当用户想要预约、咨询特定商品，或对某个商品感兴趣想要进一步联系时，与用户确认后调用此工具来展示预约卡片")
@Slf4j
public class ShowReservationCard implements Function<ShowReservationCard.Request, ShowReservationCard.Response> {

    @Data
    public static class Request {
        @JsonPropertyDescription("用户感兴趣的商品名称，必须是从上下文中获取的准确名称")
        @JsonProperty(required = true)
        public String productName;

        @JsonPropertyDescription("用户感兴趣的商品ID，必须是从上下文中获取的准确ID")
        @JsonProperty(required = true)
        public String productId;
    }

    @Data
    public static class Response {
        public String status;
        public String message;
        public Object payload;

        public Response(String status, String message, Object payload) {
            this.status = status;
            this.message = message;
            this.payload = payload;
        }
    }

    @Override
    public Response apply(Request request) {
        log.info("AI Triggered Reservation Card for: {} ({})", request.productName, request.productId);
        // 这里返回给 AI 的信息，AI 会根据这个生成给用户的最终回复
        // 但更重要的是，我们的 Controller 会捕获这个 Function Call 的执行，
        // 或者我们在 SSE/WebSocket 消息中下发特殊的 Event 标记。
        // 在 Spring AI 中，Function Call 的结果通常是返给了 AI，AI 再解释给用户。
        // 为了让前端弹出卡片，我们可以在 Response 里带上特殊标记，或者 AI 文本回复中带上特殊标记。
        // 这里我们设计：AI 收到 Response 后，会告诉用户 "请查看...", 前端监听 function execution。
        
        return new Response("SUCCESS", "Reservation card data prepared", request);
    }
}

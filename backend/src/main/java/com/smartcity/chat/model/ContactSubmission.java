package com.smartcity.chat.model;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 预约/联系提交表
 */
@Data
public class ContactSubmission implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;

    private String userName; // 联系人姓名
    private String phonenumber; // 手机号
    private String userId; // 用户ID
    
    private String projectName; // 意向项目名
    private String mdseId; // 意向商品ID (Use String for safe parsing)
    
    private String projectDescription; // 需求描述
    
    private String entryType; // 入口类型
    private String handleStatus; // 处理状态
    
    private String company; // 公司名 (New)
    private LocalDateTime submittedTime;
    private LocalDateTime processedTime; // 处理时间 (New)
}

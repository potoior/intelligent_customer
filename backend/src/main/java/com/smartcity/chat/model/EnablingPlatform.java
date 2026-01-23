package com.smartcity.chat.model;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 商品/平台赋能表
 */
@Data
public class EnablingPlatform implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;

    private String mdseId; // 商品编号
    private String mdseName; // 商品名称
    private String mdseType; // 商品类型
    private String mdseTagType; // 标签类型
    private String industryType; // 行业类型
    
    private Double mdsePrice; // 价格
    
    // SQL: mdse_pecificLogo
    private String mdsePecificLogo;
    
    // RAG 核心字段
    private String mdseIntro; // 商品描述
    
    private String mdseLink; // 商品链接
    
    // 元数据
    private LocalDateTime addTime;
    private LocalDateTime updateTime;
    private String mdseAccount;
    private String mdsePassword;
}

package com.smartcity.chat.model;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 客户用户表
 */
@Data
public class CusUser implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;

    private String userId; // 业务ID
    private String userName; // 用户名
    private String phone; // 手机号
    private String password;
    
    private LocalDateTime createdTime;
}

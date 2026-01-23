package com.smartcity.chat.controller;

import com.smartcity.chat.mapper.ContactSubmissionMapper;
import com.smartcity.chat.mapper.CusUserMapper;
import com.smartcity.chat.model.ContactSubmission;
import com.smartcity.chat.model.CusUser;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/contact")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class ContactSubmissionController {

    private final ContactSubmissionMapper submissionMapper;
    private final CusUserMapper userMapper;

    /**
     * 接收并保存用户从预约卡片提交的信息。
     */
    @PostMapping("/submit")
    public Map<String, Object> submitContact(@RequestHeader(value = "Authorization", required = false) String token,
                                             @RequestBody ContactSubmission submission) {
        // 1. 模拟身份认证 (在实际项目中，应从 Session 或 Token 中提取用户 ID)
        String currentUserId = "125f46a597c74bbbbb3faf38f8e34722"; 
        
        // 2. 根据用户 ID 补全数据库所需的实名信息（从 cus_user 表查询）
        CusUser user = userMapper.selectByUserId(currentUserId);
        
        if (user != null) {
            submission.setUserId(user.getUserId());
            submission.setUserName(user.getUserName());
            if (submission.getPhonenumber() == null) {
                // 如果前端没传手机号，则回退使用用户注册的手机号
                submission.setPhonenumber(user.getPhone());
            }
        }

        // 3. 设置默认值，确保满足数据库的 NOT NULL 约束
        submission.setSubmittedTime(LocalDateTime.now());
        submission.setProcessedTime(LocalDateTime.now()); // 初始化处理时间
        submission.setHandleStatus("0");                  // 0 = 待处理
        
        if (submission.getEntryType() == null) {
             submission.setEntryType("ENABLEMENT_CONSULTING"); // 默认业务类型：赋能咨询
        }
        
        if (submission.getCompany() == null) {
            submission.setCompany("智能客服系统用户"); // 默认归属公司
        }

        if (submission.getProjectDescription() == null || submission.getProjectDescription().isEmpty()) {
            submission.setProjectDescription("用户未提供详细描述");
        }

        // 4. 执行持久化到 MySQL 数据库 (之前这里因为 mdse_id 类型问题曾报错 500)
        submissionMapper.insert(submission);

        return Map.of("success", true, "message", "预约提交成功");
    }
}

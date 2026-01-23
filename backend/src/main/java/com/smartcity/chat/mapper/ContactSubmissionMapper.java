package com.smartcity.chat.mapper;

import com.smartcity.chat.model.ContactSubmission;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

@Mapper
public interface ContactSubmissionMapper {

    @Insert("INSERT INTO contact_submissions " +
            "(user_name, phonenumber, user_id, project_name, mdse_id, project_description, handle_status, entry_type, submitted_time, company, processed_time) " +
            "VALUES " +
            "(#{userName}, #{phonenumber}, #{userId}, #{projectName}, #{mdseId}, #{projectDescription}, #{handleStatus}, #{entryType}, #{submittedTime}, #{company}, #{processedTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ContactSubmission submission);
}

package com.smartcity.chat.mapper;

import com.smartcity.chat.model.EnablingPlatform;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;

import java.util.List;

@Mapper
public interface EnablingPlatformMapper {

    @Select("SELECT * FROM enabling_platform WHERE mdse_status = #{status}")
    @Results({
        @Result(property = "mdseId", column = "mdse_id"),
        @Result(property = "mdseName", column = "mdse_name"),
        @Result(property = "mdseType", column = "mdse_type"),
        @Result(property = "mdseTagType", column = "mdse_tag_type"),
        @Result(property = "industryType", column = "industry_type"),
        @Result(property = "mdsePecificLogo", column = "mdse_pecificLogo"),
        @Result(property = "mdsePrice", column = "mdse_price"),
        @Result(property = "mdseIntro", column = "mdse_intro"),
        @Result(property = "mdseLink", column = "mdse_link"),
        @Result(property = "addTime", column = "add_time"),
        @Result(property = "updateTime", column = "update_time")
    })
    List<EnablingPlatform> selectByStatus(int status);
}

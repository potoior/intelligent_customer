package com.smartcity.chat.mapper;

import com.smartcity.chat.model.CusUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;

@Mapper
public interface CusUserMapper {

    @Select("SELECT * FROM cus_user WHERE user_id = #{userId}")
    @Results({
        @Result(property = "userId", column = "user_id"),
        @Result(property = "userName", column = "user_name"),
        @Result(property = "createdTime", column = "created_time")
    })
    CusUser selectByUserId(String userId);
}

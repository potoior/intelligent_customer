package com.smartcity.chat;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SmartCityChatApplication {

    public static void main(String[] args) {
        SpringApplication.run(SmartCityChatApplication.class, args);
        System.out.println("启动成功");
    }

}

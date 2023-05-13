package com.hse.backend.controllers;

import com.hse.backend.dto.CommonResponseSuccess;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
@ResponseBody
public class PingController {
    @GetMapping("/ping")
    public CommonResponseSuccess ping() {
        return new CommonResponseSuccess();
    }

    @GetMapping("/ping_authorized")
    public CommonResponseSuccess pingAuthorized() {
        return new CommonResponseSuccess();
    }
}

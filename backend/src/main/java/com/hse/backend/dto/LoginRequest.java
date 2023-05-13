package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class LoginRequest {
    @JsonProperty
    public String username;
    @JsonProperty
    public String password;
}

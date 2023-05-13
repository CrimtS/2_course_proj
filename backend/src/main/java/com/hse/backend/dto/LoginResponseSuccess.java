package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Date;

public class LoginResponseSuccess {
    @JsonProperty
    private boolean success = true;
    @JsonProperty
    public String accessToken;
    @JsonProperty
    public String refreshToken;
    @JsonProperty
    public Date refreshTokenExpirationTime;
}

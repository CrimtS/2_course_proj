package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RefreshRequest {
    @JsonProperty
    public String refreshToken;
}

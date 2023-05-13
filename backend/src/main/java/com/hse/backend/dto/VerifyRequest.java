package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class VerifyRequest {
    @JsonProperty
    public String accessToken;
}

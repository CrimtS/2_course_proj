package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class RefreshResponseSuccess {
    @JsonProperty
    private boolean success = true;
    @JsonProperty
    public String accessToken;
}

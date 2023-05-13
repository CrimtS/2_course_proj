package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CommenceResponse {
    @JsonProperty
    public int status;
    @JsonProperty
    public String error;
    @JsonProperty
    public String message;
    @JsonProperty
    public String path;
}

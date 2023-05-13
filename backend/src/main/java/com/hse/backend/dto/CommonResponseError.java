package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CommonResponseError {
    public CommonResponseError(String message){
        this.message = message;
    }

    @JsonProperty
    private boolean success = false;
    @JsonProperty
    public String message;
}

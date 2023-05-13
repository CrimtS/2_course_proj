package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CommonResponseSuccess {
    @JsonProperty
    private boolean success = true;
}

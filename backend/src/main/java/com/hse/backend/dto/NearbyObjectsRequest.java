package com.hse.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class NearbyObjectsRequest {
    @JsonProperty
    public List<String> filter = null;
    @JsonProperty
    public double latitude = 0.0;
    @JsonProperty
    public double longitude = 0.0;
}

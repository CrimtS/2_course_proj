package com.hse.backend.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "geo_objects")
@Data
@NoArgsConstructor
public class GeoObject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty("id")
    @Column
    private int objectId;

    @JsonProperty
    @Column
    private double latitude = 0.0;

    @JsonProperty
    @Column
    private double longitude = 0.0;

    @JsonProperty("name_ru")
    @Column
    private String nameRu;

    @JsonProperty("name_en")
    @Column
    private String nameEn;

    @JsonProperty
    @Column
    private String category;

    @JsonProperty("wiki_ru")
    @Column
    private String wikiRu;

    @JsonProperty("wiki_en")
    @Column
    private String wikiEn;

    @JsonProperty
    @Column
    private String address;

    @JsonProperty("image_url")
    @Column
    private String imageUrl;
}

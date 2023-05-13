package com.hse.backend.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name = "user_stats")
@Data
@NoArgsConstructor
public class UserStats {
    public UserStats(int userId){
        this.userId = userId;
    }

    public void exploreGeoObject(GeoObject geoObject){
        if(allExploredObjects.contains(geoObject.getObjectId())){
            return;
        }
        allExploredObjects.add(geoObject.getObjectId());
        incrementByCategory(geoObject.getCategory());
    }

    private void incrementByCategory(String category){
        totalExplored++;
        switch (category){
            case("Red square object"):      redSquareObjects++;     break;
            case("government building"):    governmentBuildings++;  break;
            case("mall"):                   malls++;                break;
            case("monument"):               monuments++;            break;
            case("museum"):                 museums++;              break;
            case("religious building"):     religiousBuildings++;   break;
            case("restaurant"):             restaurants++;          break;
            case("skyscraper"):             skyscrapers++;          break;
            case("stadium"):                stadiums++;             break;
            case("theatre"):                theatres++;             break;
            default:
                totalExplored--;
                break;
        }
    }

    @Id
    @Column
    @JsonIgnore
    private int userId;

    @JsonProperty("total")
    @Column
    private int totalExplored = 0;

    @JsonProperty("Red square object")
    @Column
    private int redSquareObjects = 0;

    @JsonProperty("government building")
    @Column
    private int governmentBuildings = 0;

    @JsonProperty("mall")
    @Column
    private int malls = 0;

    @JsonProperty("monument")
    @Column
    private int monuments = 0;

    @JsonProperty("museum")
    @Column
    private int museums = 0;

    @JsonProperty("religious building")
    @Column
    private int religiousBuildings = 0;

    @JsonProperty("restaurant")
    @Column
    private int restaurants = 0;

    @JsonProperty("skyscraper")
    @Column
    private int skyscrapers = 0;

    @JsonProperty("stadium")
    @Column
    private int stadiums = 0;

    @JsonProperty("theatre")
    @Column
    private int theatres = 0;

    @JsonIgnore
    @Column
    @ElementCollection
    private List<Integer> allExploredObjects;
}

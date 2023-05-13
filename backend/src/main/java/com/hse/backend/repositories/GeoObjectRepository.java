package com.hse.backend.repositories;

import com.hse.backend.models.GeoObject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GeoObjectRepository extends JpaRepository<GeoObject, Integer> {
    GeoObject getGeoObjectByObjectId(int objectId);
    List<GeoObject> getGeoObjectsByNameRuContainsIgnoreCase(String substr);
    List<GeoObject> getGeoObjectsByNameEnContainsIgnoreCase(String substr);
    List<GeoObject> getGeoObjectByLatitudeBetweenAndLongitudeBetween(
            double latitudeLeft,
            double latitudeRight,
            double longitudeLeft,
            double longitudeRight
    );
}

package com.hse.backend.services;

import com.hse.backend.models.GeoObject;
import com.hse.backend.repositories.GeoObjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class GeoObjectsService {
    @Autowired
    GeoObjectRepository geoObjectRepository;

    // Pre-calculated values of the angular shift,
    // which correspond to 1 kilometer on the coordinates of Moscow
    private static final double LATITUDE_KILOMETER = 0.009;
    private static final double LONGITUDE_KILOMETER = 0.016;

    private static final double DEFAULT_RADIUS_KM = 0.2;

    public List<GeoObject> getNearbyObjects(double latitude, double longitude, List<String> filter) {
        return getNearbyObjects(latitude, longitude, DEFAULT_RADIUS_KM, filter);
    }

    public List<GeoObject> getNearbyObjects(double latitude, double longitude, double radius, List<String> filter) {
        double LONGITUDE_RANGE = radius * LONGITUDE_KILOMETER;
        double LATITUDE_RANGE = radius * LATITUDE_KILOMETER;

        List<GeoObject> notFiltred = geoObjectRepository.getGeoObjectByLatitudeBetweenAndLongitudeBetween(
                latitude - LATITUDE_RANGE,
                latitude + LATITUDE_RANGE,
                longitude - LONGITUDE_RANGE,
                longitude + LONGITUDE_RANGE
        );

        if(filter == null){
            return notFiltred;
        }

        List<GeoObject> filtred = new ArrayList<>();
        for(var object : notFiltred){
            if(filter.contains(object.getCategory())){
                filtred.add(object);
            }
        }

        return filtred;
    }

    public GeoObject getObjectForNotification(double latitude, double longitude, List<String> filter) {
        return getObjectForNotification(latitude, longitude, DEFAULT_RADIUS_KM, filter);
    }

    public GeoObject getObjectForNotification(double latitude, double longitude, double radius, List<String> filter) {
        var objects = getNearbyObjects(latitude, longitude, radius, filter);

        if (objects.isEmpty()) {
            return null;
        }

        objects.sort(new Comparator<>() {
            @Override
            public int compare(GeoObject o1, GeoObject o2) {
                return (int) ((Math.pow(o1.getLatitude() - latitude, 2) + Math.pow(o1.getLongitude() - longitude, 2)) -
                        (Math.pow(o2.getLatitude() - latitude, 2) + Math.pow(o2.getLongitude() - longitude, 2)));
            }
        });

        return objects.get(0);
    }
}

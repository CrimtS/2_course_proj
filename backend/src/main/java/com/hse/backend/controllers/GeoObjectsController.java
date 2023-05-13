package com.hse.backend.controllers;

import com.hse.backend.dto.NearbyObjectsRequest;
import com.hse.backend.dto.SearchRequest;
import com.hse.backend.models.GeoObject;
import com.hse.backend.repositories.GeoObjectRepository;
import com.hse.backend.services.GeoObjectsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/geo_objects")
@ResponseBody
public class GeoObjectsController {
    @Autowired
    private GeoObjectRepository geoObjectRepository;

    @Autowired
    private GeoObjectsService geoObjectsService;

    @PostMapping("/get_nearby_objects")
    public List<GeoObject> getNearbyObjects(
            @RequestBody NearbyObjectsRequest request
    ) {
        return geoObjectsService.getNearbyObjects(request.latitude, request.longitude, request.filter);
    }

    @PostMapping("/nearby_object_notification")
    public GeoObject nearbyObjectNotification(
            @RequestBody NearbyObjectsRequest request
    ) {
        return geoObjectsService.getObjectForNotification(request.latitude, request.longitude, request.filter);
    }

    @PostMapping("/search")
    public List<GeoObject> search(
            @RequestBody SearchRequest request
    ) {
        List<GeoObject> result = new ArrayList<>();
        result.addAll(geoObjectRepository.getGeoObjectsByNameRuContainsIgnoreCase(request.key));
        result.addAll(geoObjectRepository.getGeoObjectsByNameEnContainsIgnoreCase(request.key));
        return result;
    }

    @GetMapping("geo_object_retrieve/{objectId}")
    public GeoObject getObject(
            @PathVariable("objectId") int objectId
    ){
        return geoObjectRepository.getGeoObjectByObjectId(objectId);
    }
}

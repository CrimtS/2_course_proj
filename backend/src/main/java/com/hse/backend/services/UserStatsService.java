package com.hse.backend.services;

import com.hse.backend.models.GeoObject;
import com.hse.backend.models.UserStats;
import com.hse.backend.repositories.GeoObjectRepository;
import com.hse.backend.repositories.UserStatsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserStatsService {
    @Autowired
    private GeoObjectRepository geoObjectRepository;

    @Autowired
    private UserStatsRepository userStatsRepository;

    @Autowired
    private UserService userService;

    public void exploreObject(int objectId) throws IllegalArgumentException {
        UserStats stats = getUserStats();

        GeoObject geoObject = geoObjectRepository.getGeoObjectByObjectId(objectId);

        if (geoObject == null) {
            throw new IllegalArgumentException("Invalid object id");
        }

        if (stats.getAllExploredObjects().contains(geoObject.getObjectId())) {
            throw new IllegalArgumentException("Object already explored");
        }

        stats.exploreGeoObject(geoObject);
        userStatsRepository.save(stats);
    }

    public UserStats getUserStats() {
        return userStatsRepository.getUserStatsByUserId(userService.getCurrentUserId());
    }

    public List<GeoObject> getAllExplorations() {
        UserStats stats = getUserStats();

        List<GeoObject> result = new ArrayList<>();
        for (var objectId : stats.getAllExploredObjects()) {
            result.add(geoObjectRepository.getGeoObjectByObjectId(objectId));
        }

        return result;
    }

    public GeoObject getLastExploration() {
        var allExploredObjects = getUserStats().getAllExploredObjects();
        if (allExploredObjects.isEmpty()) {
            return null;
        }

        return geoObjectRepository.getGeoObjectByObjectId(allExploredObjects.get(allExploredObjects.size() - 1));
    }
}

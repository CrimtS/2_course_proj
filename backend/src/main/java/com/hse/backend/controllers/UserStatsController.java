package com.hse.backend.controllers;

import com.hse.backend.dto.CommonResponseError;
import com.hse.backend.dto.CommonResponseSuccess;
import com.hse.backend.dto.ExploreObjectRequest;
import com.hse.backend.models.GeoObject;
import com.hse.backend.models.UserStats;
import com.hse.backend.services.UserStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user_stats")
@ResponseBody
public class UserStatsController {
    @Autowired
    private UserStatsService userStatsService;

    @PostMapping("/explore_object")
    public ResponseEntity<?> exploreObject(
            @RequestBody ExploreObjectRequest request
    ) {
        try{
            userStatsService.exploreObject(request.objectId);
            return ResponseEntity.ok(new CommonResponseSuccess());
        } catch (IllegalArgumentException e){
            var response = new CommonResponseError(e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/my_stats")
    public UserStats getMyStats() {
        return userStatsService.getUserStats();
    }

    @GetMapping("/my_explorations")
    public List<GeoObject> getMyExplorations() {
        return userStatsService.getAllExplorations();
    }

    @GetMapping("/last_exploration")
    public GeoObject getLastExploration() {
        return userStatsService.getLastExploration();
    }

    @GetMapping("/is_explored/{objectId}")
    public boolean isExplored(
            @PathVariable("objectId") int objectId
    ){
        return userStatsService.getUserStats().getAllExploredObjects().contains(objectId);
    }
}

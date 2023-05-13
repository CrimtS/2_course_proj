package com.hse.backend.repositories;

import com.hse.backend.models.UserStats;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserStatsRepository extends JpaRepository<UserStats, Integer> {
    UserStats getUserStatsByUserId(int userId);
}

package com.hse.backend.repositories;

import com.hse.backend.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    User getUserByUsername(String username);
    boolean existsByUsername(String username);
    User getUserByRefreshToken(String refreshToken);
    User getUserByAccessToken(String accessToken);
}

package com.hse.backend.services;

import com.hse.backend.models.User;
import com.hse.backend.models.UserStats;
import com.hse.backend.repositories.UserStatsRepository;
import com.hse.backend.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private UserStatsRepository userStatsRepository;

    public void createUser(String username, String rawPassword){
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(rawPassword));
        User userDb = userRepository.save(user);
        int userId = userDb.getUserId();

        UserStats userStats = new UserStats(userId);
        userStatsRepository.save(userStats);
    }

    public int getCurrentUserId(){
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userRepository.getUserByUsername(user.getUsername()).getUserId();
    }
}

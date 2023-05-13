package com.hse.backend.controllers;

import com.hse.backend.dto.*;
import com.hse.backend.models.User;
import com.hse.backend.repositories.UserRepository;
import com.hse.backend.security.SecurityUtils;
import com.hse.backend.security.userdetails.UserDetailsImpl;
import com.hse.backend.services.UserService;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {
    @Autowired
    private SecurityUtils securityUtils;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        Authentication authentication =
                authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                request.username,
                                request.password
                        )
                );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        User user = userRepository.getUserByUsername(request.username);

        Date issuedTime = new Date();
        Date accessTokenExpirationTime = new Date(issuedTime.getTime() + securityUtils.getAccessTokenExpirationTimeMs());
        Date refreshTokenExpirationTime = new Date(issuedTime.getTime() + securityUtils.getRefreshTokenExpirationTimeMs());
        String refreshToken = UUID.randomUUID().toString();
        String accessToken = Jwts.builder()
                .setSubject(userDetails.getUsername())
                .setIssuedAt(issuedTime)
                .setExpiration(accessTokenExpirationTime)
                .signWith(SignatureAlgorithm.HS512, securityUtils.getJwtSecret()).compact();

        user.setAccessToken(accessToken);
        user.setRefreshToken(refreshToken);
        user.setAccessTokenExpiration(accessTokenExpirationTime);
        user.setRefreshTokenExpiration(refreshTokenExpirationTime);
        userRepository.save(user);

        LoginResponseSuccess response = new LoginResponseSuccess();
        response.accessToken = accessToken;
        response.refreshToken = refreshToken;
        response.refreshTokenExpirationTime = refreshTokenExpirationTime;

        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody LoginRequest request) {
        if (userRepository.existsByUsername(request.username)) {
            CommonResponseError response = new CommonResponseError("Username already taken");
            return ResponseEntity.badRequest().body(response);
        }

        if(request.username.length() < 4){
            CommonResponseError response = new CommonResponseError("Username too short");
            return ResponseEntity.badRequest().body(response);
        }

        if(request.password.length() < 6){
            CommonResponseError response = new CommonResponseError("Password too short");
            return ResponseEntity.badRequest().body(response);
        }

        userService.createUser(request.username, request.password);

        User user = userRepository.getUserByUsername(request.username);

        Date issuedTime = new Date();
        Date accessTokenExpirationTime = new Date(issuedTime.getTime() + securityUtils.getAccessTokenExpirationTimeMs());
        Date refreshTokenExpirationTime = new Date(issuedTime.getTime() + securityUtils.getRefreshTokenExpirationTimeMs());
        String refreshToken = UUID.randomUUID().toString();
        String accessToken = Jwts.builder()
                .setSubject(request.username)
                .setIssuedAt(issuedTime)
                .setExpiration(accessTokenExpirationTime)
                .signWith(SignatureAlgorithm.HS512, securityUtils.getJwtSecret()).compact();

        user.setAccessToken(accessToken);
        user.setRefreshToken(refreshToken);
        user.setAccessTokenExpiration(accessTokenExpirationTime);
        user.setRefreshTokenExpiration(refreshTokenExpirationTime);
        userRepository.save(user);

        LoginResponseSuccess response = new LoginResponseSuccess();
        response.accessToken = accessToken;
        response.refreshToken = refreshToken;
        response.refreshTokenExpirationTime = refreshTokenExpirationTime;

        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@RequestBody RefreshRequest request) {
        Date currentTime = new Date();

        User user = userRepository.getUserByRefreshToken(request.refreshToken);
        if (user == null
                || !user.getRefreshToken().equals(request.refreshToken)
                || currentTime.after(user.getRefreshTokenExpiration())) {
            CommonResponseError response = new CommonResponseError("Invalid refresh token");
            return ResponseEntity.badRequest().body(response);
        }

        Date accessTokenExpirationTime = new Date(currentTime.getTime() + securityUtils.getAccessTokenExpirationTimeMs());
        String accessToken = Jwts.builder()
                .setSubject(user.getUsername())
                .setIssuedAt(currentTime)
                .setExpiration(accessTokenExpirationTime)
                .signWith(SignatureAlgorithm.HS512, securityUtils.getJwtSecret()).compact();

        user.setAccessToken(accessToken);
        user.setAccessTokenExpiration(accessTokenExpirationTime);
        userRepository.save(user);

        RefreshResponseSuccess response = new RefreshResponseSuccess();
        response.accessToken = accessToken;

        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verify(@RequestBody VerifyRequest request) {
        Date currentTime = new Date();

        User user = userRepository.getUserByAccessToken(request.accessToken);
        if (user == null
                || !user.getAccessToken().equals(request.accessToken)
                || currentTime.after(user.getAccessTokenExpiration())) {
            CommonResponseError response = new CommonResponseError("Invalid access token");
            return ResponseEntity.badRequest().body(response);
        }

        return ResponseEntity.ok(new CommonResponseSuccess());
    }
}
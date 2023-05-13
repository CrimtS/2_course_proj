package com.hse.backend.security;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SecurityUtils {
    @Value("${jwt.secret}")
    @Getter
    private String jwtSecret;

    @Value("${jwt.accessTokenExpirationTimeMs}")
    @Getter
    private int accessTokenExpirationTimeMs;

    @Value("${jwt.refreshTokenExpirationTimeMs}")
    @Getter
    private int refreshTokenExpirationTimeMs;
}

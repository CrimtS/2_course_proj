package com.hse.backend.security.jwt;

import com.hse.backend.models.User;
import com.hse.backend.repositories.UserRepository;
import com.hse.backend.security.SecurityUtils;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class TokenFilter extends OncePerRequestFilter {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SecurityUtils securityUtils;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {
        try {
            String jwtToken = parseJwtToken(request);
            if (isJwtTokenValid(jwtToken)) {
                User user = userRepository.getUserByUsername(parseUsernameFromJwtToken(jwtToken));
                var authenticationToken = new UsernamePasswordAuthenticationToken(user, null, null);
                authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        } catch (Exception e) {
            System.err.println("Authentication failed: " + e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwtToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (StringUtils.hasText(header) && header.startsWith("Bearer ")) {
            return header.substring(7);
        }

        return null;
    }

    private boolean isJwtTokenValid(String jwtToken) {
        if (jwtToken != null) {
            try {
                Jwts.parserBuilder().setSigningKey(securityUtils.getJwtSecret()).build().parseClaimsJws(jwtToken);
                return true;
            } catch (Exception e) {
                System.err.println("Authentication failed: " + e.getMessage());
            }
        }

        return false;
    }

    private String parseUsernameFromJwtToken(String jwtToken) {
        return Jwts.parserBuilder().setSigningKey(securityUtils.getJwtSecret()).build().parseClaimsJws(jwtToken).getBody().getSubject();
    }
}

package com.hse.backend.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonProperty
    @Column
    private int userId;

    @JsonProperty
    @Column
    private String username;

    @JsonIgnore
    @Column
    private String password;

    @JsonIgnore
    @Column
    private String accessToken;

    @JsonIgnore
    @Column
    private Date accessTokenExpiration;

    @JsonIgnore
    @Column
    private String refreshToken;

    @JsonIgnore
    @Column
    private Date refreshTokenExpiration;
}

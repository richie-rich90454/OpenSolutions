package com.richardjiang880.opensolutions.dto;

public record AuthResponse(
    String token,
    Long userId,
    String email,
    String name,
    String role
) {}

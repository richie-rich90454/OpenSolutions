package com.richardjiang880.opensolutions.dto;

public record LeaderboardEntry(
    Long userId,
    String name,
    String email,
    int credits
) {}

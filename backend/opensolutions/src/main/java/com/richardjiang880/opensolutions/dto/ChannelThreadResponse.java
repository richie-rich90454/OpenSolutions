package com.richardjiang880.opensolutions.dto;

import java.time.LocalDateTime;

public record ChannelThreadResponse(
    Long id,
    Long channelId,
    String title,
    Long userId,
    String userName,
    int postCount,
    LocalDateTime createdAt
) {}

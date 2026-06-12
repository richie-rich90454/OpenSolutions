package com.richardjiang880.opensolutions.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateReportRequest(
    @NotBlank(message = "Reason is required")
    String reason,

    @NotNull(message = "Target type is required")
    String targetType,

    @NotNull(message = "Target ID is required")
    Long targetId
) {}

package com.richardjiang880.opensolutions.dto;

import jakarta.validation.constraints.NotBlank;

public record ResolveReportRequest(
    @NotBlank(message = "Action is required")
    String action
) {}

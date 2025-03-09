package com.example.bookingservice.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class BookingDTO {
    private Long id;

    @NotNull(message = "User ID is mandatory")
    private Long userId;

    @NotNull(message = "Car ID is mandatory")
    private Long carId;

    @NotNull(message = "Start time is mandatory")
    private LocalDateTime startTime;

    @NotNull(message = "End time is mandatory")
    private LocalDateTime endTime;
}
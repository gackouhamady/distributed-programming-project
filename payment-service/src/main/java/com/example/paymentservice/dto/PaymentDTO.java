package com.example.paymentservice.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PaymentDTO {
    private Long id;

    @NotNull(message = "User ID is mandatory")
    private Long userId;

    @NotNull(message = "Booking ID is mandatory")
    private Long bookingId;

    @NotNull(message = "Amount is mandatory")
    private BigDecimal amount;

    @NotNull(message = "Payment date is mandatory")
    private LocalDateTime paymentDate;

    @NotNull(message = "Payment status is mandatory")
    private String status; // e.g., "PENDING", "COMPLETED", "FAILED"
}
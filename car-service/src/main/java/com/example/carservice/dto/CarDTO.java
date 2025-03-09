package com.example.carservice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CarDTO {
    private Long id;

    @NotBlank(message = "Brand is mandatory")
    private String brand;

    @NotBlank(message = "Model is mandatory")
    private String model;

    @NotNull(message = "Year is mandatory")
    private Integer year;

    @NotBlank(message = "Color is mandatory")
    private String color;
}


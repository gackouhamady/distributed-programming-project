package com.example.carservice.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "cars")
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Brand is mandatory")
    @Column(nullable = false)
    private String brand;

    @NotBlank(message = "Model is mandatory")
    @Column(nullable = false)
    private String model;

    @NotNull(message = "Year is mandatory")
    @Column(nullable = false)
    private Integer year;

    @NotBlank(message = "Color is mandatory")
    @Column(nullable = false)
    private String color;

    // Constructeur par défaut (requis par JPA)
    public Car() {
    }

    // Constructeur avec paramètres (facultatif, mais utile pour la création d'objets)
    public Car(String brand, String model, Integer year, String color) {
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.color = color;
    }

    // Méthode builder() (similaire à celle du modèle User)
    public static CarBuilder builder() {
        return new CarBuilder();
    }

    // Classe Builder pour la construction fluide d'objets Car
    public static class CarBuilder {
        private String brand;
        private String model;
        private Integer year;
        private String color;

        public CarBuilder brand(String brand) {
            this.brand = brand;
            return this;
        }

        public CarBuilder model(String model) {
            this.model = model;
            return this;
        }

        public CarBuilder year(Integer year) {
            this.year = year;
            return this;
        }

        public CarBuilder color(String color) {
            this.color = color;
            return this;
        }

        public Car build() {
            return new Car(brand, model, year, color);
        }
    }
}
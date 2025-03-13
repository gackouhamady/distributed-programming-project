package com.example.bookingservice.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "User ID is mandatory")
    @Column(nullable = false)
    private Long userId;

    @NotNull(message = "Car ID is mandatory")
    @Column(nullable = false)
    private Long carId;

    @NotNull(message = "Start time is mandatory")
    @Column(nullable = false)
    private LocalDateTime startTime;

    @NotNull(message = "End time is mandatory")
    @Column(nullable = false)
    private LocalDateTime endTime;

    // Constructeur par défaut (requis par JPA)
    public Booking() {
    }

    // Constructeur avec paramètres (facultatif, mais utile pour la création d'objets)
    public Booking(Long userId, Long carId, LocalDateTime startTime, LocalDateTime endTime) {
        this.userId = userId;
        this.carId = carId;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Méthode builder() (similaire à celle du modèle User)
    public static BookingBuilder builder() {
        return new BookingBuilder();
    }

    // Classe Builder pour la construction fluide d'objets Booking
    public static class BookingBuilder {
        private Long userId;
        private Long carId;
        private LocalDateTime startTime;
        private LocalDateTime endTime;

        public BookingBuilder userId(Long userId) {
            this.userId = userId;
            return this;
        }

        public BookingBuilder carId(Long carId) {
            this.carId = carId;
            return this;
        }

        public BookingBuilder startTime(LocalDateTime startTime) {
            this.startTime = startTime;
            return this;
        }

        public BookingBuilder endTime(LocalDateTime endTime) {
            this.endTime = endTime;
            return this;
        }

        public Booking build() {
            return new Booking(userId, carId, startTime, endTime);
        }
    }
}
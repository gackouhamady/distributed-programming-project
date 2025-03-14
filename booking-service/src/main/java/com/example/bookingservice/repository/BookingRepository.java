package com.example.bookingservice.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.bookingservice.model.Booking;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    // Trouver toutes les réservations d'un utilisateur spécifique
    List<Booking> findByUserId(Long userId);

    // Trouver toutes les réservations d'une voiture spécifique
    List<Booking> findByCarId(Long carId);

    // Trouver toutes les réservations dans une période donnée
    List<Booking> findByStartTimeBetween(LocalDateTime startTime, LocalDateTime endTime);

    // Trouver toutes les réservations pour une voiture dans une période donnée
    List<Booking> findByCarIdAndStartTimeBetween(Long carId, LocalDateTime startTime, LocalDateTime endTime);

    // Trouver toutes les réservations pour un utilisateur dans une période donnée
    List<Booking> findByUserIdAndStartTimeBetween(Long userId, LocalDateTime startTime, LocalDateTime endTime);

    // Vérifier si une voiture est déjà réservée dans une période donnée
    boolean existsByCarIdAndStartTimeLessThanEqualAndEndTimeGreaterThanEqual(Long carId, LocalDateTime endTime, LocalDateTime startTime);

    // Vérifier si un utilisateur a déjà une réservation dans une période donnée
    boolean existsByUserIdAndStartTimeLessThanEqualAndEndTimeGreaterThanEqual(Long userId, LocalDateTime endTime, LocalDateTime startTime);

    // Supprimer toutes les réservations d'un utilisateur
    void deleteByUserId(Long userId);

    // Supprimer toutes les réservations d'une voiture
    void deleteByCarId(Long carId);
}
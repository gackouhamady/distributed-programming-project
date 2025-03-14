package com.example.carservice.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.carservice.model.Car;

@Repository
public interface CarRepository extends JpaRepository<Car, Long> {

    // Trouver une voiture par sa marque
    List<Car> findByBrand(String brand);

    // Trouver une voiture par son modèle
    List<Car> findByModel(String model);

    // Trouver une voiture par son année
    List<Car> findByYear(Integer year);

    // Trouver une voiture par sa couleur
    List<Car> findByColor(String color);

    // Trouver une voiture par sa marque et son modèle
    List<Car> findByBrandAndModel(String brand, String model);

    // Trouver une voiture par sa marque et son année
    List<Car> findByBrandAndYear(String brand, Integer year);

    // Trouver une voiture par son modèle et son année
    List<Car> findByModelAndYear(String model, Integer year);

    // Trouver une voiture par son ID
    @SuppressWarnings("null")
    @Override
    Optional<Car> findById(Long id);

    // Vérifier si une voiture existe par sa marque
    boolean existsByBrand(String brand);

    // Vérifier si une voiture existe par son modèle
    boolean existsByModel(String model);

    // Vérifier si une voiture existe par son année
    boolean existsByYear(Integer year);

    // Vérifier si une voiture existe par sa couleur
    boolean existsByColor(String color);

    // Supprimer une voiture par sa marque
    void deleteByBrand(String brand);

    // Supprimer une voiture par son modèle
    void deleteByModel(String model);

    // Supprimer une voiture par son année
    void deleteByYear(Integer year);

    // Supprimer une voiture par sa couleur
    void deleteByColor(String color);
}
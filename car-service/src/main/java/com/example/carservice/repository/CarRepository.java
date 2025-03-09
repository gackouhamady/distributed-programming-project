package com.example.carservice.repository;

import com.example.carservice.model.Car;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CarRepository extends JpaRepository<Car, Long> {
    List<Car> findByBrand(String brand);
    List<Car> findByYear(Integer year);
}
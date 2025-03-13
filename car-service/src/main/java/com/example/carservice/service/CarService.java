package com.example.carservice.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.carservice.dto.CarDTO;
import com.example.carservice.model.Car;
import com.example.carservice.repository.CarRepository;

@Service
public class CarService {

    @Autowired
    private CarRepository carRepository;

    // Récupérer toutes les voitures
    public List<CarDTO> getAllCars() {
        return carRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Récupérer une voiture par son ID
    public Optional<CarDTO> getCarById(Long id) {
        return carRepository.findById(id).map(this::convertToDTO);
    }

    // Créer une nouvelle voiture
    public CarDTO createCar(CarDTO carDTO) {
        Car car = convertToEntity(carDTO);
        car = carRepository.save(car);
        return convertToDTO(car);
    }

    // Mettre à jour une voiture existante
    public Optional<CarDTO> updateCar(Long id, CarDTO carDTO) {
        return carRepository.findById(id).map(existingCar -> {
            existingCar.setBrand(carDTO.getBrand());
            existingCar.setModel(carDTO.getModel());
            existingCar.setYear(carDTO.getYear());
            existingCar.setColor(carDTO.getColor());
            Car updatedCar = carRepository.save(existingCar);
            return convertToDTO(updatedCar);
        });
    }

    // Supprimer une voiture par son ID
    public boolean deleteCar(Long id) {
        if (carRepository.existsById(id)) {
            carRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Convertir une entité Car en CarDTO
    private CarDTO convertToDTO(Car car) {
        CarDTO carDTO = new CarDTO();
        carDTO.setId(car.getId());
        carDTO.setBrand(car.getBrand());
        carDTO.setModel(car.getModel());
        carDTO.setYear(car.getYear());
        carDTO.setColor(car.getColor());
        return carDTO;
    }

    // Convertir un CarDTO en entité Car
    private Car convertToEntity(CarDTO carDTO) {
        Car car = new Car();
        car.setId(carDTO.getId()); // Assurez-vous que l'ID est également défini pour les mises à jour
        car.setBrand(carDTO.getBrand());
        car.setModel(carDTO.getModel());
        car.setYear(carDTO.getYear());
        car.setColor(carDTO.getColor());
        return car;
    }
}
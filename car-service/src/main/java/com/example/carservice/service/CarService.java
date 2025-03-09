package com.example.carservice.service;

import com.example.carservice.dto.CarDTO;
import com.example.carservice.model.Car;
import com.example.carservice.repository.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CarService {

    @Autowired
    private CarRepository carRepository;

    public List<CarDTO> getAllCars() {
        return carRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public Optional<CarDTO> getCarById(Long id) {
        return carRepository.findById(id).map(this::convertToDTO);
    }

    public CarDTO createCar(CarDTO carDTO) {
        Car car = convertToEntity(carDTO);
        car = carRepository.save(car);
        return convertToDTO(car);
    }

    public Optional<CarDTO> updateCar(Long id, CarDTO carDTO) {
        return carRepository.findById(id).map(existingCar -> {
            existingCar.setBrand(carDTO.getBrand());
            existingCar.setModel(carDTO.getModel());
            existingCar.setYear(carDTO.getYear());
            existingCar.setColor(carDTO.getColor());
            carRepository.save(existingCar);
            return convertToDTO(existingCar);
        });
    }

    public void deleteCar(Long id) {
        carRepository.deleteById(id);
    }

    private CarDTO convertToDTO(Car car) {
        CarDTO carDTO = new CarDTO();
        carDTO.setId(car.getId());
        carDTO.setBrand(car.getBrand());
        carDTO.setModel(car.getModel());
        carDTO.setYear(car.getYear());
        carDTO.setColor(car.getColor());
        return carDTO;
    }

    private Car convertToEntity(CarDTO carDTO) {
        Car car = new Car();
        car.setBrand(carDTO.getBrand());
        car.setModel(carDTO.getModel());
        car.setYear(carDTO.getYear());
        car.setColor(carDTO.getColor());
        return car;
    }
}
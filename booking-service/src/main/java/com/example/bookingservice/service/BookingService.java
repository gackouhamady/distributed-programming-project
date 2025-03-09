package com.example.bookingservice.service;

import com.example.bookingservice.dto.BookingDTO;
import com.example.bookingservice.exception.ResourceNotFoundException;
import com.example.bookingservice.model.Booking;
import com.example.bookingservice.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    public List<BookingDTO> getAllBookings() {
        return bookingRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public Optional<BookingDTO> getBookingById(Long id) {
        return bookingRepository.findById(id).map(this::convertToDTO);
    }

    public BookingDTO createBooking(BookingDTO bookingDTO) {
        Booking booking = convertToEntity(bookingDTO);
        booking = bookingRepository.save(booking);
        return convertToDTO(booking);
    }

    public Optional<BookingDTO> updateBooking(Long id, BookingDTO bookingDTO) {
        return bookingRepository.findById(id).map(existingBooking -> {
            existingBooking.setUserId(bookingDTO.getUserId());
            existingBooking.setCarId(bookingDTO.getCarId());
            existingBooking.setStartTime(bookingDTO.getStartTime());
            existingBooking.setEndTime(bookingDTO.getEndTime());
            bookingRepository.save(existingBooking);
            return convertToDTO(existingBooking);
        });
    }

    public void deleteBooking(Long id) {
        bookingRepository.deleteById(id);
    }

    private BookingDTO convertToDTO(Booking booking) {
        BookingDTO bookingDTO = new BookingDTO();
        bookingDTO.setId(booking.getId());
        bookingDTO.setUserId(booking.getUserId());
        bookingDTO.setCarId(booking.getCarId());
        bookingDTO.setStartTime(booking.getStartTime());
        bookingDTO.setEndTime(booking.getEndTime());
        return bookingDTO;
    }

    private Booking convertToEntity(BookingDTO bookingDTO) {
        Booking booking = new Booking();
        booking.setUserId(bookingDTO.getUserId());
        booking.setCarId(bookingDTO.getCarId());
        booking.setStartTime(bookingDTO.getStartTime());
        booking.setEndTime(bookingDTO.getEndTime());
        return booking;
    }
}
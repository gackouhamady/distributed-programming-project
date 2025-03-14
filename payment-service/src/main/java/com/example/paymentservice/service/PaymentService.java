package com.example.paymentservice.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.paymentservice.dto.PaymentDTO;
import com.example.paymentservice.model.Payment;
import com.example.paymentservice.repository.PaymentRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    public List<PaymentDTO> getAllPayments() {
        return paymentRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public Optional<PaymentDTO> getPaymentById(Long id) {
        return paymentRepository.findById(id).map(this::convertToDTO);
    }

    public PaymentDTO createPayment(PaymentDTO paymentDTO) {
        Payment payment = convertToEntity(paymentDTO);
        payment = paymentRepository.save(payment);
        return convertToDTO(payment);
    }

    public Optional<PaymentDTO> updatePayment(Long id, PaymentDTO paymentDTO) {
        return paymentRepository.findById(id).map(existingPayment -> {
            existingPayment.setUserId(paymentDTO.getUserId());
            existingPayment.setBookingId(paymentDTO.getBookingId());
            existingPayment.setAmount(paymentDTO.getAmount());
            existingPayment.setPaymentDate(paymentDTO.getPaymentDate());
            existingPayment.setStatus(paymentDTO.getStatus());
            paymentRepository.save(existingPayment);
            return convertToDTO(existingPayment);
        });
    }

    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }

    private PaymentDTO convertToDTO(Payment payment) {
        PaymentDTO paymentDTO = new PaymentDTO();
        paymentDTO.setId(payment.getId());
        paymentDTO.setUserId(payment.getUserId());
        paymentDTO.setBookingId(payment.getBookingId());
        paymentDTO.setAmount(payment.getAmount());
        paymentDTO.setPaymentDate(payment.getPaymentDate());
        paymentDTO.setStatus(payment.getStatus());
        return paymentDTO;
    }

    private Payment convertToEntity(PaymentDTO paymentDTO) {
        Payment payment = new Payment();
        payment.setUserId(paymentDTO.getUserId());
        payment.setBookingId(paymentDTO.getBookingId());
        payment.setAmount(paymentDTO.getAmount());
        payment.setPaymentDate(paymentDTO.getPaymentDate());
        payment.setStatus(paymentDTO.getStatus());
        return payment;
    }
}
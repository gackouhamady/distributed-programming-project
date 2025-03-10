package com.example.userservice.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.userservice.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Trouver un utilisateur par son nom d'utilisateur
    Optional<User> findByUsername(String username);

    // Trouver un utilisateur par son email
    Optional<User> findByEmail(String email);

    // Trouver tous les utilisateurs avec un rôle spécifique
    List<User> findByRolesContaining(String role);

    // Vérifier si un utilisateur existe par son nom d'utilisateur
    boolean existsByUsername(String username);

    // Vérifier si un utilisateur existe par son email
    boolean existsByEmail(String email);

    // Supprimer un utilisateur par son nom d'utilisateur
    void deleteByUsername(String username);
}
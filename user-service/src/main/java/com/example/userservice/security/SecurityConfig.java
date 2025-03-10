package com.example.userservice.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @SuppressWarnings({ "deprecation", "removal" })
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf().disable() // Désactive CSRF (utile pour les API REST)
                .authorizeRequests(auth -> auth
                        .requestMatchers("/api/users/register").permitAll() // Autorise l'accès sans authentification
                        .requestMatchers("/api/users/{id}").permitAll() // Autorise l'accès sans authentification
                        .requestMatchers("/api/users").permitAll() // Autorise l'accès sans authentification
                        .requestMatchers("/api/users/**").hasRole("ADMIN") // Les opérations sensibles nécessitent le rôle ADMIN
                        .anyRequest().authenticated() // Toutes les autres requêtes nécessitent une authentification
                )
                .httpBasic(); // Active l'authentification HTTP Basic
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // Utilise BCrypt pour le hachage des mots de passe
    }

   


      @Bean
    public UserDetailsService userDetailsService() {
        // Crée un utilisateur en mémoire pour tester l'authentification
        UserDetails user = User.builder()
                .username("admin")
                .password(passwordEncoder().encode("password")) // Mot de passe haché
                .roles("USER") // Rôle de l'utilisateur
                .build();

        return new InMemoryUserDetailsManager(user); // Gère les utilisateurs en mémoire
    }


}
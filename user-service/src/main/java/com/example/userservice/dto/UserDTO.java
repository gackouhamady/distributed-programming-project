package com.example.userservice.dto;

import java.util.Set;

public class UserDTO {
    private String username;
    private String password;
    private String email;
    private Set<String> roles;
        @SuppressWarnings("unused")
        private Long id;
    
        // Getters et setters
        public String getUsername() {
            return username;
        }
    
        public void setUsername(String username) {
            this.username = username;
        }
    
        public String getPassword() {
            return password;
        }
    
        public void setPassword(String password) {
            this.password = password;
        }
    
        public String getEmail() {
            return email;
        }
    
        public void setEmail(String email) {
            this.email = email;
        }
    
        public Set<String> getRoles() {
            return roles;
        }
    
        public void setRoles(Set<String> roles) {
            this.roles = roles;
        }
    
        public void setId(Long id) {
            this.id = id;
    }

    public Long getId() {
        return id;
    }

}
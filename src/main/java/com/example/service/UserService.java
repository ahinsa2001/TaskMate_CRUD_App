package com.example.service;

import com.example.bean.User;
import com.example.repo.UserRepository;

public class UserService {

    private UserRepository userRepository = new UserRepository();

    public void registerUser(User user) throws Exception {
        userRepository.saveUser(user);
    }

    public boolean authenticateUser(String username, String password) throws Exception {
        return userRepository.checkCredentials(username, password);
    }

    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public void incrementFailedAttempts(String username) {
        userRepository.incrementFailedAttempts(username);
    }

    public int getFailedAttempts(String username) {
        return userRepository.getFailedAttempts(username);
    }

    public void resetFailedAttempts(String username) {
        userRepository.resetFailedAttempts(username);
    }

    public void updateUserStatus(String username, String status) {
        userRepository.updateStatus(username, status);
    }

}

package com.example.service;

import com.example.bean.User;
import com.example.repo.UserRepository;

public class UserService {

    private UserRepository userRepository = new UserRepository();

    public void registerUser(User user) throws Exception {
        // Business logic
        userRepository.saveUser(user);
    }

    public User authenticateUser(String username, String password) throws Exception {
        // Business logic, validation
        return userRepository.getUserByUsernameAndPassword(username, password);
    }

}

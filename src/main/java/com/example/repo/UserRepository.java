package com.example.repo;

import com.example.bean.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserRepository {
    private DBConnection dbConnection = new DBConnection();

    public void saveUser(User user) throws SQLException, ClassNotFoundException {
        Connection con = null;
        try {
            con = dbConnection.getConnection();
            String query = "INSERT INTO users(uname, upwd, uemail, profile_pic) VALUES(?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, user.getUsername());
            pst.setString(2, user.getPassword());
            pst.setString(3, user.getEmail());
            pst.setString(4, user.getProfilePic());
            pst.executeUpdate();
        } finally {
        if (con != null) con.close();
        }
    }

    // Check credential when user login
    public boolean checkCredentials(String username, String password) {
        boolean isValidUser = false;
        try {
            Connection con = dbConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM users WHERE uname = ? AND upwd = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.setString(2, password);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        int count = resultSet.getInt(1);
                        if (count == 1) {
                            isValidUser = true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        return isValidUser;
    }

    public User findByUsername(String username) {
        User user = null;
        try {
            Connection con = dbConnection.getConnection();
            String sql = "SELECT * FROM users WHERE uname = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, username);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        user = new User();
                        user.setId(resultSet.getInt("uid"));
                        user.setUsername(resultSet.getString("uname"));
                        user.setPassword(resultSet.getString("upwd"));
                        user.setProfilePic(resultSet.getString("profile_pic"));
                        user.setStatus(resultSet.getString("status"));
                        user.setFailedAttempts(resultSet.getInt("failed_attempts"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        return user;
    }

    // Check login attempts and set status
    public void incrementFailedAttempts(String username) {
        try (Connection con = dbConnection.getConnection()) {
            String sql = "UPDATE users SET failed_attempts = failed_attempts + 1 WHERE uname = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public int getFailedAttempts(String username) {
        try (Connection con = dbConnection.getConnection()) {
            String sql = "SELECT failed_attempts FROM users WHERE uname = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, username);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        return resultSet.getInt("failed_attempts");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public void resetFailedAttempts(String username) {
        try {
            Connection con = dbConnection.getConnection();
            String sql = "UPDATE users SET failed_attempts = 0 WHERE uname = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public void updateStatus(String username, String status) {
        try (Connection con = dbConnection.getConnection()) {
            String sql = "UPDATE users SET status = ? WHERE uname = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setString(1, status);
                statement.setString(2, username);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}

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

    public User getUserByUsernameAndPassword(String username, String password) throws SQLException, ClassNotFoundException {

        Connection con = null;
        ResultSet rs = null;
        try {
            con = dbConnection.getConnection();
            String query = "SELECT * FROM users WHERE uname=? AND upwd=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            rs = pst.executeQuery();
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("uid"));
                    user.setUsername(rs.getString("uname"));
                    user.setEmail(rs.getString("uemail"));
                    user.setProfilePic(rs.getString("profile_pic"));
                    return user;
                } else {
                    return null;
                }
            } finally {
                if (con != null) con.close();
            }
        }
}

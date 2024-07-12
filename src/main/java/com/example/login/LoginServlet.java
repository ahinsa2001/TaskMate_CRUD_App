package com.example.login;

import com.example.bean.User;
import com.example.service.UserService;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();
    private static final int MAX_ATTEMPTS = 3;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String upwd = request.getParameter("password");

        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        try {
            User user = userService.getUserByUsername(uname);
            if (user == null) {
                // User does not exist
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("login.jsp");
            } else if ("inactive".equals(user.getStatus())) {
                // Account is inactive
                request.setAttribute("status", "inactive");
                dispatcher = request.getRequestDispatcher("login.jsp");
            } else {
                // Proceed with authentication
                if (userService.authenticateUser(uname, upwd)) {
                    // Successful login, reset the counter and set status to active
                    userService.resetFailedAttempts(uname);
                    userService.updateUserStatus(uname, "active");
                    session.setAttribute("user_id", user.getId());
                    session.setAttribute("name", user.getUsername());
                    session.setAttribute("profilePicPath", "uploads/" + user.getProfilePic());
                    dispatcher = request.getRequestDispatcher("index.jsp");
                } else {
                    // Failed login
                    userService.incrementFailedAttempts(uname);
                    int attempts = userService.getFailedAttempts(uname);
                    if (attempts >= MAX_ATTEMPTS) {
                        userService.updateUserStatus(uname, "inactive");
                        request.setAttribute("status", "inactive");
                        dispatcher = request.getRequestDispatcher("login.jsp");
                    } else {
                        request.setAttribute("status", "failed");
                        dispatcher = request.getRequestDispatcher("login.jsp");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("login.jsp");
        }

        dispatcher.forward(request, response);
    }
}

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String upwd = request.getParameter("password");

        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        if (uname == null || upwd == null) {
            request.setAttribute("error", "All fields are required.");
            dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        try {
            User user = userService.authenticateUser(uname, upwd);
            if (user != null) {
                session.setAttribute("user_id", user.getId());
                session.setAttribute("name", user.getUsername());
                session.setAttribute("profilePicPath", "uploads/" + user.getProfilePic());
                dispatcher = request.getRequestDispatcher("index.jsp");
            } else {
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            dispatcher = request.getRequestDispatcher("login.jsp");
        }

        dispatcher.forward(request, response);
    }
}
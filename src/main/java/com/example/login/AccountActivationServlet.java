package com.example.login;

import jakarta.servlet.http.HttpServlet;
import com.example.service.UserService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/AccountActivationServlet")
public class AccountActivationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        try {
            userService.updateUserStatus(username, "active");
            userService.resetFailedAttempts(username);
            response.sendRedirect("login.jsp?status=activationRequested");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during account reactivation request: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

}

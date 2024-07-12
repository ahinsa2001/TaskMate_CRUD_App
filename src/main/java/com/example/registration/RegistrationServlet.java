package com.example.registration;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.example.bean.User;
import com.example.service.UserService;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;


@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String uemail = request.getParameter("email");
        String upwd = request.getParameter("password");
        String confirm_pwd = request.getParameter("confirmPassword");
        Part filePart = request.getPart("profilePicture");

        RequestDispatcher dispatcher = null;

        if (uname == null || uemail == null || upwd == null || confirm_pwd == null || filePart == null) {
            request.setAttribute("error", "All fields are required.");
            dispatcher = request.getRequestDispatcher("registration.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Profile pic upload and save
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadPath + File.separator + fileName;
        try (InputStream fileContent = filePart.getInputStream();
             FileOutputStream fos = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        User user = new User(uname, uemail, upwd, fileName);

        try {
            userService.registerUser(user);
            request.setAttribute("status", "successful");
            request.setAttribute("profilePicPath", "uploads/" + fileName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
        }

        dispatcher = request.getRequestDispatcher("registration.jsp");
        dispatcher.forward(request, response);
    }

}

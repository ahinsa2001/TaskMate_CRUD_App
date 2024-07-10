package com.example.taskmanager;

import com.example.service.TaskService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;

import java.io.IOException;

@WebServlet("/UpdateTaskStatusServlet")
public class UpdateTaskStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private TaskService taskService = new TaskService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String status = request.getParameter("status");

        try {
            taskService.updateTaskStatus(taskId, status);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

}

package com.example.taskmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.example.service.TaskService;

import java.io.IOException;

@WebServlet("/DeleteTaskServlet")
public class DeleteTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TaskService taskService = new TaskService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("deleteTaskId"));

        try {
            taskService.deleteTask(taskId);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}

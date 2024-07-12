package com.example.taskmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.example.bean.Task;
import com.example.service.TaskService;

import java.io.IOException;


@WebServlet("/UpdateTaskServlet")
public class UpdateTaskServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private TaskService taskService = new TaskService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int taskId = Integer.parseInt(request.getParameter("updateTaskId"));
        String taskName = request.getParameter("updateTaskName");
        String taskDescription = request.getParameter("updateTaskDescription");
        String taskDueDate = request.getParameter("updateTaskDueDate");
        String status = request.getParameter("status"); // Get status parameter

        // Create Task object using constructor for update
        Task task = new Task(taskId, taskName, taskDescription, taskDueDate, status);

        try {
            taskService.updateTask(task);
            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

}

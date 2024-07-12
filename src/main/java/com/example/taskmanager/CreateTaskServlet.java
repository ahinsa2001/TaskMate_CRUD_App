package com.example.taskmanager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.bean.Task;
import com.example.service.TaskService;

import java.io.IOException;

@WebServlet("/CreateTaskServlet")
public class CreateTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private TaskService taskService = new TaskService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the current session or return null if there is no session
        HttpSession session = request.getSession(false);

        // Redirect to login if no session exists or if user_id attribute is missing
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve user_id from session
        Integer userId = (Integer) session.getAttribute("user_id");

        // Double check if user_id is null and redirect to login if it is
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }


        // Retrieve form parameters
        String title = request.getParameter("taskName");
        String description = request.getParameter("taskDescription");
        String due_date = request.getParameter("taskDueDate");
        String status = request.getParameter("status");

        try {
        // Check if task name already exists
        boolean taskExists = taskService.checkIfTaskExists(title, userId);

        if (taskExists) {
            // Set error message and forward back to the JSP
            request.setAttribute("taskNameError", "Task name already exists. Please choose a different name.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        // Create Task object using constructor
        Task task = new Task(title, description, due_date, userId, status);

        taskService.createTask(task);
        // Redirect to index page upon successful insertion
        response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to login page in case of an exception
            response.sendRedirect("login.jsp");
        }
    }
}

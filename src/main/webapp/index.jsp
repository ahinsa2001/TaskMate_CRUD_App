<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%
    if (session.getAttribute("name") == null) {
        response.sendRedirect("login.jsp");
    }

    // Fetch tasks from the database
    List<Map<String, String>> tasks = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jspCrudDb?useSSL=false", "root", "Lk1aAkOm@AN");
        String query = "SELECT id, title, description, due_date, status FROM tasks WHERE user_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, (Integer) session.getAttribute("user_id"));
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> task = new HashMap<>();
            task.put("id", rs.getString("id"));
            task.put("title", rs.getString("title"));
            task.put("description", rs.getString("description"));
            task.put("due_date", rs.getString("due_date"));
            task.put("status", rs.getString("status"));
            tasks.add(task);
        }
        con.close();

        // Sort tasks by due_date
        tasks.sort((task1, task2) -> {
            String dueDate1 = task1.get("due_date");
            String dueDate2 = task2.get("due_date");
            return dueDate1.compareTo(dueDate2);
        });

    } catch (Exception e) {
        e.printStackTrace();
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskMate Application</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #102C57 !important;
            height: 50px;
        }
        .navbar-brand, .nav-link, .nav-item.bg-danger a {
            color: #f8f9fa !important;
        }
        .hero-section {
            background: url('https://source.unsplash.com/1600x900/?task,management') no-repeat center center;
            background-size: cover;
            color: #102C57;
            height: 30vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 5px;
            position: relative;
            overflow: hidden;
        }
        .hero-section::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #f0f2f5;
            z-index: 1;
            opacity: 0.5;
        }
        .hero-section h1, .hero-section p {
            position: relative;
            z-index: 2;
        }
        .hero-section h1 {
            margin-top: 80px;
            font-size: 1.6rem;
            font-weight: bold;
        }
        .hero-section p {
            font-size: 0.8rem;
        }
        .task-list {
            margin-top: 20px;
            margin-left: 25px;
            margin-right: 25px;
        }
        .task-item {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
        }
        .task-details {
            display: flex;
            flex-direction: column;
            text-align: left;
            margin-right: 35px;
            margin-left: 5px;
        }
        .task-title {
            margin-bottom: 2px;
            font-size: 1rem;
            font-weight: bold;
        }
        .task-description {
            font-size: 0.75rem;
            color: #a6a6a6;
            margin-bottom: 5px;
        }
        .task-due-date {
            font-size: 0.8rem;
            color: #737171;
            margin-left: 0;
            flex-shrink: 0;
        }
        .task-actions {
            display: flex;
            align-items: center;
        }
        .task-actions .btn {
            border: none;
            background: none;
            font-size: 0.7rem;
        }
        .task-actions .btn img {
            width: 25px;
            height: 25px;
        }
        .task-container {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 30px;
            margin: 200px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .add-task-button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #ffffff;
            color: #102C57;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .add-task-button .button-icon {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        .add-task-button:hover {
            background-color: #E90074;
            border-color: #E90074;
        }
        .modal-body .btn-primary {
            background-color: #102C57;
        }
        .modal-body .btn-primary:hover {
            background-color: #E90074;
            border-color: #E90074;
        }
        .modal-body .btn {
            justify-content: center;
        }

        .navbar-nav .profile-pic-nav {
            width: 32px;
            height: 32px;
            margin-right: 8px;
        }

        /* style dropdown */
        .custom-dropdown {
            position: relative;
            display: inline-block;
            width: auto;
        }

        .custom-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            padding: 6px 12px;
            background-color: #f8f9fa;
            color: #333;
            font-size: 13px;
            border: none;
            border-radius: 4px;
            width: 120px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .custom-select:hover {
            background-color: #e0e0e0;
        }

        .custom-select:focus {
            background-color: #e0e0e0;
            outline: none;
        }

        .custom-select option {
            color: #333;
        }

        .custom-select:disabled {
            background-color: #e9ecef;
            cursor: not-allowed;
        }

        .error-message {
            color: #FF0000;
            font-size: 10px;
            margin: -3px 0 10px 0;
            text-align: left;
            justify-content: center;
        }


    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand" href="#home">TaskMate</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#home">Home</a>
                <li class="nav-item">
                    <a class="nav-link" href="logout">Logout</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <img src="<%= session.getAttribute("profilePicPath") %>" class="rounded-circle profile-pic-nav" alt="Profile Picture">
                        <span><%= session.getAttribute("name") %></span>
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero-section">
    <div>
        <h1>Welcome to the TaskMate Application</h1>
        <p class="lead">Manage your tasks efficiently with our application</p>
    </div>
</div>

<!-- Page Content -->
<div class="task-container mt-5">
    <div class="row">
        <div class="col-lg-12 text-center">
            <div class="button-container">
                <button class="btn btn-primary mb-3 add-task-button" onclick="showCreateTaskModal()">
                    <img src="add.png" alt="Add Task" class="button-icon"> Add New Task
                </button>
            </div>
            <div class="task-list">
                <% for (Map<String, String> task : tasks) { %>
                <div class="task-item">
                    <div class="task-details">
                        <div class="task-title"><%= task.get("title") %></div>
                        <div class="task-description"><%= task.get("description") %></div>
                        <div class="task-due-date"><%= task.get("due_date") %></div>
                    </div>
                    <div class="task-actions">
                        <form action="UpdateTaskStatusServlet" method="post" class="mr-2">
                            <input type="hidden" name="taskId" value="<%= task.get("id") %>">

                            <div class="custom-dropdown">
                            <select name="status" class="form-control custom-select" onchange="this.form.submit()">
                                <option value="Pending" <%= "Pending".equals(task.get("status")) ? "selected" : "" %>>Pending</option>
                                <option value="In Progress" <%= "In Progress".equals(task.get("status")) ? "selected" : "" %>>In Progress</option>
                                <option value="Completed" <%= "Completed".equals(task.get("status")) ? "selected" : "" %>>Completed</option>
                            </select>
                            </div>
                        </form>

                        <div class="task-actions">
                            <button class="btn" onclick="showUpdateTaskModal('<%= task.get("id") %>', '<%= task.get("title") %>', '<%= task.get("description") %>', '<%= task.get("due_date") %>', '<%= task.get("status") %>')">
                                <img src="pen.png" alt="Update">
                            </button>
                            <button class="btn" onclick="showDeleteTaskModal('<%= task.get("id") %>')">
                                <img src="remove.png" alt="Delete">
                            </button>
                        </div>

                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Create Task Modal -->
<div class="modal fade" id="createTaskModal" tabindex="-1" role="dialog" aria-labelledby="createTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createTaskModalLabel">Create a New Task</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="CreateTaskServlet" method="post" onsubmit="return validateCreateTaskForm()">
                    <div class="form-group">
                        <label for="taskName">Task Name</label>
                        <input type="text" class="form-control" id="taskName" name="taskName" maxlength="20">
                        <p class="error-message" id="taskNameError"><%= request.getAttribute("taskNameError") != null ? request.getAttribute("taskNameError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="taskDescription">Task Description</label>
                        <textarea class="form-control" id="taskDescription" name="taskDescription" rows="3" maxlength="50"></textarea>
                        <p class="error-message" id="taskDescriptionError"><%= request.getAttribute("taskDescriptionError") != null ? request.getAttribute("taskDescriptionError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="taskDueDate">Due Date</label>
                        <input type="date" class="form-control" id="taskDueDate" name="taskDueDate">
                        <p class="error-message" id="taskDueDateError"><%= request.getAttribute("taskDueDateError") != null ? request.getAttribute("taskDueDateError") : "" %></p>
                    </div>

                    <div class="form-group">
                        <label for="status">Status</label>
                        <select class="form-control" id="status" name="status" required>
                            <option value="Pending">Pending</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Create Task</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Update Task Modal -->
<div class="modal fade" id="updateTaskModal" tabindex="-1" role="dialog" aria-labelledby="updateTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateTaskModalLabel">Update Task</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="updateTaskForm" action="UpdateTaskServlet" method="post" onsubmit="return validateUpdateTaskForm()">
                    <input type="hidden" id="updateTaskId" name="updateTaskId">
                    <div class="form-group">
                        <label for="updateTaskName">Task Name</label>
                        <input type="text" class="form-control" id="updateTaskName" name="updateTaskName" maxlength="20">
                        <p class="error-message" id="updateTaskNameError"><%= request.getAttribute("updateTaskNameError") != null ? request.getAttribute("updateTaskNameError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="updateTaskDescription">Task Description</label>
                        <textarea class="form-control" id="updateTaskDescription" name="updateTaskDescription" rows="3" maxlength="50"></textarea>
                        <p class="error-message" id="updateTaskDescriptionError"><%= request.getAttribute("updateTaskDescriptionError") != null ? request.getAttribute("updateTaskDescriptionError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="updateTaskDueDate">Due Date</label>
                        <input type="date" class="form-control" id="updateTaskDueDate" name="updateTaskDueDate">
                        <p class="error-message" id="updateTaskDueDateError"><%= request.getAttribute("updateTaskDueDateError") != null ? request.getAttribute("updateTaskDueDateError") : "" %></p>
                    </div>

                    <div class="form-group">
                        <label for="edit_status">Status</label>
                        <select class="form-control" id="edit_status" name="status" required>
                            <option value="Pending">Pending</option>
                            <option value="In Progress">In Progress</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Update Task</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Delete Task Modal -->
<div class="modal fade" id="deleteTaskModal" tabindex="-1" role="dialog" aria-labelledby="deleteTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteTaskModalLabel">Delete Task</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="deleteTaskForm" action="DeleteTaskServlet" method="post">
                    <input type="hidden" id="deleteTaskId" name="deleteTaskId">
                    <p>Are you sure you want to delete this task?</p>
                    <button type="submit" class="btn btn-danger">Delete Task</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                </form>
            </div>
        </div>
    </div>
</div>



<script>
    function showCreateTaskModal() {
        $('#createTaskModal').modal('show');
    }

    function showUpdateTaskModal(id, title, description, dueDate, status) {
        $('#updateTaskId').val(id);
        $('#updateTaskName').val(title);
        $('#updateTaskDescription').val(description);
        $('#updateTaskDueDate').val(dueDate);
        $('#status').val(status);
        $('#updateTaskModal').modal('show');
    }

    function showDeleteTaskModal(id) {
        $('#deleteTaskId').val(id);
        $('#deleteTaskModal').modal('show');
    }

    document.addEventListener('DOMContentLoaded', function() {
        var dateInput = document.getElementById('taskDueDate');
        var today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);

        document.getElementById('createTaskForm').addEventListener('submit', function(event) {
            var taskDueDate = dateInput.value;
            if (taskDueDate < today) {
                event.preventDefault();
                alert('Due date cannot be in the past.');
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        var dateInput = document.getElementById('updateTaskDueDate');
        var today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);

        document.getElementById('updateTaskForm').addEventListener('submit', function(event) {
            var taskDueDate = dateInput.value;
            if (taskDueDate < today) {
                event.preventDefault();
                alert('Due date cannot be in the past.');
            }
        });
    });

    //Create Task Input Validations
    function validateCreateTaskForm() {
        var isValid = true;

        var taskName = document.getElementById("taskName").value;
        var taskDescription = document.getElementById("taskDescription").value;
        var taskDueDate = document.getElementById("taskDueDate").value;

        // Clear previous error messages
        document.getElementById("taskNameError").textContent = "";
        document.getElementById("taskDescriptionError").textContent = "";
        document.getElementById("taskDueDateError").textContent = "";

        // Task Name validation
        if (taskName === "") {
            document.getElementById("taskNameError").textContent = "Task Name is required";
            isValid = false;
        }

        // Task Description validation
        if (taskDescription == "") {
            document.getElementById("taskDescriptionError").textContent = "Task Description is required";
            isValid = false;
        }

        // Task DueDate validation
        if(taskDueDate == "") {
            document.getElementById("taskDueDateError").textContent = "DueDate is required";
            isValid = false;
        }
        return isValid;
    }

    //Update Task Input Validations
    function validateUpdateTaskForm() {
        var isValid = true;

        var updateTaskName = document.getElementById("updateTaskName").value;
        var updateTaskDescription = document.getElementById("updateTaskDescription").value;
        var updateTaskDueDate = document.getElementById("updateTaskDueDate").value;

        // Clear previous error messages
        document.getElementById("updateTaskNameError").textContent = "";
        document.getElementById("updateTaskDescriptionError").textContent = "";
        document.getElementById("updateTaskDueDateError").textContent = "";


        // Update Task Name validation
        if (updateTaskName == "") {
            document.getElementById("updateTaskNameError").textContent = "Task Name is required";
            isValid = false;
        }

        // Update Task Description validation
        if (updateTaskDescription == "") {
            document.getElementById("updateTaskDescriptionError").textContent = "Task Description is required";
            isValid = false;
        }

        // Update Task DueDate validation
        if (updateTaskDueDate == "") {
            document.getElementById("updateTaskDueDateError").textContent = "DueDate is required";
            isValid = false;
        }
        return isValid;
    }


    // Add event listeners to clear error messages when input fields are focused
    document.getElementById('taskName').addEventListener('focus', function() {
        clearError('taskNameError');
    });
    document.getElementById('taskDescription').addEventListener('focus', function() {
        clearError('taskDescriptionError');
    });
    document.getElementById('taskDueDate').addEventListener('focus', function() {
        clearError('taskDueDateError');
    });
    document.getElementById('updateTaskName').addEventListener('focus', function() {
        clearError('updateTaskNameError');
    });
    document.getElementById('updateTaskDescription').addEventListener('change', function() {
        clearError('updateTaskDescriptionError');
    });
    document.getElementById('updateTaskDueDate').addEventListener('change', function() {
        clearError('updateTaskDueDateError');
    });

    function clearError(errorId) {
        document.getElementById(errorId).textContent = "";
    }

</script>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>

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

        /* Style nav bar */
        .navbar {
            background-color: #102C57 !important;
            height: 50px;
        }
        .navbar-brand, .nav-link, .nav-item.bg-danger a {
            color: #f8f9fa !important;
            font-size: 1rem;
        }

        /* Style hero section */
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

        /* Style task listing view */
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

        .semi-nav-container {
            align-content: center;
            display: flex;
            flex-direction: row;
            justify-content: center;
            margin-bottom: -10px;
            margin-top: 10px;
        }

        /* Style add task button */
        .add-btn-title {
            font-size: 0.8rem;
            margin-top: 15px;
        }
        .add-task-button {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: left;
            height: 32px;
            background-color: #ffffff;
            color: #102C57;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-left: 300px;
            margin-top: 18px;
        }
        .add-task-button .button-icon {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        .add-task-button:hover {
            background-color: #102C57;
        }

        /* Style update and delete option */
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

        /* Style username and pro pic in nav bar */
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

        /* Error message style */
        .error-message {
            color: #FF0000;
            font-size: 10px;
            margin: -3px 0 10px 0;
            text-align: left;
            justify-content: center;
        }

        /* Search option style */
        .search-container {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: center;
        }
        .search-container input {
            align-content: center;
            width: 200px;
            padding: 10px;
            border: none;
            font-size: 0.8rem;
            color: inherit;
        }
        .search-container .search-icon {
            width: 17px;
            height: 17px;
            color: inherit;
            margin-right: 0px;
        }
        .search-container input:focus {
            outline: none;
            border: none;
            border-bottom: 1px solid #a6a6a6;
        }
        .search-container:hover input{
            border: none;
            border-bottom: 1px solid #a6a6a6;
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

            <div class="semi-nav-container">
            <div class="search-container text-center mb-3">
                <img src="search.png" alt="search" class="search-icon">
                <input type="text" id="searchInput" class="form-control" placeholder="Search tasks by title" onkeyup="filterTasks()">
            </div>

            <div class="button-container">
                <button class="btn btn-primary mb-3 add-task-button" onclick="showCreateTaskModal()">
                    <img src="add.png" alt="Add Task" class="button-icon"> <p class="add-btn-title">Add Task</p>
                </button>
            </div>
            </div>

            <div class="task-list"></div>
            <!-- Task items will be appended here -->
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
                        <input type="text" class="form-control" id="taskName" name="taskName" maxlength="20" value="<%= request.getAttribute("taskName") != null ? request.getAttribute("taskName") : "" %>">
                        <p class="error-message" id="taskNameError"><%= request.getAttribute("taskNameError") != null ? request.getAttribute("taskNameError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="taskDescription">Task Description</label>
                        <textarea class="form-control" id="taskDescription" name="taskDescription" rows="3" maxlength="50"><%= request.getAttribute("taskDescription") != null ? request.getAttribute("taskDescription") : "" %></textarea>
                        <p class="error-message" id="taskDescriptionError"><%= request.getAttribute("taskDescriptionError") != null ? request.getAttribute("taskDescriptionError") : "" %></p>
                    </div>
                    <div class="form-group">
                        <label for="taskDueDate">Due Date</label>
                        <input type="date" class="form-control" id="taskDueDate" name="taskDueDate" value="<%= request.getAttribute("taskDueDate") != null ? request.getAttribute("taskDueDate") : "" %>">
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
                        <input type="text" class="form-control" id="updateTaskName" name="updateTaskName" maxlength="20" readonly>
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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script>
    $(document).ready(function() {
        fetchTasks();

        function fetchTasks() {
            $.ajax({
                url: 'tasks',
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    var taskList = $('.task-list');
                    taskList.empty();
                    $.each(data, function(index, task) {
                        var taskHtml = '<div class="task-item">' +
                            '<div class="task-details">' +
                            '<div class="task-title">' + task.title + '</div>' +
                            '<div class="task-description">' + task.description + '</div>' +
                            '<div class="task-due-date">' + task.dueDate + '</div>' +
                            '</div>' +
                            '<div class="task-actions">' +
                            '<form action="UpdateTaskStatusServlet" method="post" class="mr-2">' +
                            '<input type="hidden" name="taskId" value="' + task.id + '">' +
                            '<div class="custom-dropdown">' +
                            '<select name="status" class="form-control custom-select" onchange="this.form.submit()">' +
                            '<option value="Pending"' + (task.status === 'Pending' ? ' selected' : '') + '>Pending</option>' +
                            '<option value="In Progress"' + (task.status === 'In Progress' ? ' selected' : '') + '>In Progress</option>' +
                            '<option value="Completed"' + (task.status === 'Completed' ? ' selected' : '') + '>Completed</option>' +
                            '</select>' +
                            '</div>' +
                            '</form>' +
                            '<div class="task-actions">' +
                            '<button class="btn" onclick="showUpdateTaskModal(\'' + task.id + '\', \'' + task.title + '\', \'' + task.description + '\', \'' + task.dueDate + '\', \'' + task.status + '\')">' +
                            '<img src="pen.png" alt="Update">' +
                            '</button>' +
                            '<button class="btn" onclick="showDeleteTaskModal(\'' + task.id + '\')">' +
                            '<img src="remove.png" alt="Delete">' +
                            '</button>' +
                            '</div>' +
                            '</div>' +
                            '</div>';
                        taskList.append(taskHtml);
                    });
                },
                error: function() {
                    alert('Failed to fetch tasks.');
                }
            });
        }
    });
</script>

<!-- JavaScript for Modals and Task Management -->
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

    function filterTasks() {
        var input = document.getElementById('searchInput').value.toLowerCase();
        var taskItems = document.getElementsByClassName('task-item');

        Array.from(taskItems).forEach(function(item) {
            var title = item.getElementsByClassName('task-title')[0].innerText.toLowerCase();
            if (title.includes(input)) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });
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

<!-- jQuery and Bootstrap JavaScript -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<script>
    $(document).ready(function() {
        $('#createTaskModal').on('hidden.bs.modal', function () {
            $(this).find('form').trigger('reset');
            $('.error-message').text(''); // Clear error messages
        });

        <% if (request.getAttribute("taskNameError") != null) { %>
        $('#createTaskModal').modal('show');
        <% } %>
    });
</script>




</body>
</html>

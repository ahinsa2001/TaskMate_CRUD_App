<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 7/3/2024
  Time: 10:39 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .register-container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 35px;
            width: 310px;
            text-align: center;
        }
        .register-container h1 {
            margin-bottom: 25px;
            color: #102C57;
        }
        .register-container h2 {
            margin-bottom: 20px;
            color: #102C57;
        }
        .register-container input[type="text"],
        .register-container input[type="password"],
        .register-container input[type="email"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .register-container input[type="submit"] {
            background-color: #102C57;
            width:100%;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }
        .register-container input[type="submit"]:hover {
            background-color: #E90074;
        }
        .register-container p {
            margin-top: 20px;
            color: #555;
            font-size: 0.7rem;
        }
        .register-container a {
            color: #102C57;
            text-decoration: none;
            font-weight: bold;
        }
        .register-container a:hover {
            text-decoration: underline;
        }
        .register-container .error-message {
            color: #FF0000;
            font-size: 10px;
            margin: -3px 0 10px 0;
            text-align: left;
            justify-content: center;
        }
        .profile-pic {
            margin-right: 100px;
            margin-left: 100px;
            align-content: center;
            display: block;
            width: 120px;
            height: 120px;
            cursor: pointer;
            border-radius: 50%;
            margin-bottom: -20px;
            background-color: white;
            object-fit: fill;
            opacity: 50%;
        }
        .file-input {
            display: none;
        }
        .file-label {
            font-size: 10px;
            color: #102C57;
            opacity: 50%;
            margin-bottom: 50px;
        }

    </style>
</head>
<body>


<% String status = (String) request.getAttribute("status"); %>
<% String error = (String) request.getAttribute("error"); %>

<div class="register-container">
    <h1>TaskMate</h1>
    <form id="registrationForm" action="RegisterServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">

        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" class="file-input" onchange="previewImage(event)">
        <% String profilePicPath = (String) request.getAttribute("profilePicPath"); %>
        <img id="profilePicPreview" src="<%= profilePicPath != null && !profilePicPath.isEmpty() ? profilePicPath : "uploads/user_pic.png" %>" alt="Profile Picture" class="profile-pic" onclick="triggerFileInput()"><br>
        <label for="profilePicture" class="file-label">Upload profile picture Here</label>
        <p class="error-message" id="profilePictureError"><%= request.getAttribute("profilePictureError") != null ? request.getAttribute("profilePictureError") : "" %></p>

        <input type="text" id="username" name="username" placeholder="Username" maxlength="10"><br>
        <p class="error-message" id="usernameError"><%= request.getAttribute("usernameError") != null ? request.getAttribute("usernameError") : "" %></p>
        <input type="text" id="email" name="email" placeholder="Email"><br>
        <p class="error-message" id="emailError"><%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %></p>
        <input type="password" id="password" name="password" placeholder="Password" maxlength="10"><br>
        <p class="error-message" id="passwordError"><%= request.getAttribute("passwordError") != null ? request.getAttribute("passwordError") : "" %></p>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" maxlength="10"><br>
        <p class="error-message" id="confirmPasswordError"><%= request.getAttribute("confirmPasswordError") != null ? request.getAttribute("confirmPasswordError") : "" %></p>
        <input type="submit" value="Register">
    </form>
    <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </form>
</div>
    <!-- JS for alert-->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">


<script type="text/javascript">

    function validateForm() {
        var isValid = true;

        var profilePicture = document.getElementById("profilePicture").value;
        var username = document.getElementById("username").value;
        var email = document.getElementById("email").value;
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;

        // Clear previous error messages
        document.getElementById("profilePictureError").textContent = "";
        document.getElementById("usernameError").textContent = "";
        document.getElementById("emailError").textContent = "";
        document.getElementById("passwordError").textContent = "";
        document.getElementById("confirmPasswordError").textContent = "";

        // Profile picture validation
        if (profilePicture === "") {
            document.getElementById("profilePictureError").textContent = "Profile picture is required";
            isValid = false;
        }

        // Username validation
        if (username == "") {
            document.getElementById("usernameError").textContent = "Username is required";
            isValid = false;
        }

        // Email validation
        var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if(email == "") {
            document.getElementById("emailError").textContent = "Email is required";
            isValid = false;
        }
        else if (!emailPattern.test(email)) {
            document.getElementById("emailError").textContent = "Please enter a valid email address";
            isValid = false;
        }

        // Password validation
        if (password == "") {
            document.getElementById("passwordError").textContent = "Password is required";
            isValid = false;
        }

        // Confirm password validation
        if (password !== confirmPassword) {
            document.getElementById("confirmPasswordError").textContent = "Passwords do not match";
            isValid = false;
        }

        return isValid;
    }

    var status = "<%= status %>";
    if(status === "successful"){
        document.getElementById('profilePicPreview').src = 'uploads/user_pic.png';
        document.getElementById('profilePicture').value = ''; // Clear the file input
        swal("Congrats", "Account Created Successfully", "success");
    }

    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            var output = document.getElementById('profilePicPreview');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }

    function triggerFileInput() {
        document.getElementById('profilePicture').click();
    }


    // Add event listeners to clear error messages when input fields are focused
    document.getElementById('username').addEventListener('focus', function() {
        clearError('usernameError');
    });
    document.getElementById('email').addEventListener('focus', function() {
        clearError('emailError');
    });
    document.getElementById('password').addEventListener('focus', function() {
        clearError('passwordError');
    });
    document.getElementById('confirmPassword').addEventListener('focus', function() {
        clearError('confirmPasswordError');
    });
    document.getElementById('profilePicture').addEventListener('change', function() {
        clearError('profilePictureError');
    });

    function clearError(errorId) {
        document.getElementById(errorId).textContent = "";
    }


</script>

</body>
</html>


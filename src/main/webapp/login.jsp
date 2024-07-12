<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("name") != null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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
        .login-container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 35px;
            width: 300px;
            text-align: center;
        }
        .login-container h2, h1 {
            margin-bottom: 20px;
            color: #102C57;
        }
        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .login-container input[type="submit"] {
            background-color: #102C57;
            width: 100%;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }
        .login-container input[type="submit"]:hover {
            background-color: #E90074;
        }
        .login-container p {
            margin-top: 20px;
            color: #555;
            font-size: 0.7rem;
        }
        .login-container a {
            color: #102C57;
            text-decoration: none;
            font-weight: bold;
        }
        .login-container a:hover {
            text-decoration: underline;
        }
        .login-container .error-message {
            color: #FF0000;
            font-size: 10px;
            margin: -5px 0 10px 0;
            text-align: left;
            justify-content: center;
        }
    </style>
</head>
<body>


<input type="hidden" id="status" value="<%= request.getAttribute("status") %>">

<div class="login-container">
    <h1>TaskMate</h1>

    <form action="LoginServlet" method="post" onsubmit="return validateLoginForm()">
        <input type="text" name="username" id="username" placeholder="Username" maxlength="10"><br>
        <p class="error-message" id="usernameError"><%= request.getAttribute("usernameError") != null ? request.getAttribute("usernameError") : "" %></p>
        <input type="password" name="password" id="password" placeholder="Password" maxlength="10"><br>
        <p class="error-message" id="passwordError"><%= request.getAttribute("passwordError") != null ? request.getAttribute("passwordError") : "" %></p>
        <input type="submit" value="Login">
    </form>
    <p>Don't have an account? <a href="registration.jsp">Register here</a></p>

    <!-- Reactivation form -->
    <form action="AccountActivationServlet" method="post" id="reactivationForm" style="display:none;">
        <input type="hidden" name="username" id="reactivationUsername">
        <button id="btn" type="submit">Request Account Reactivation</button>
    </form>
</div>


<!-- JS for alert -->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">

<script type="text/javascript">
    function validateLoginForm() {
        var isValid = true;

        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;

        // Clear previous error messages
        document.getElementById("usernameError").textContent = "";
        document.getElementById("passwordError").textContent = "";

        // Username validation
        if (username === "") {
            document.getElementById("usernameError").textContent = "Username is required";
            isValid = false;
        }

        // Password validation
        if (password === "") {
            document.getElementById("passwordError").textContent = "Password is required";
            isValid = false;
        }

        // Prevent form submission if validation fails
        return isValid;
    }

    document.getElementById('username').addEventListener('focus', function() {
        clearError('usernameError');
    });
    document.getElementById('password').addEventListener('focus', function() {
        clearError('passwordError');
    });

    function clearError(errorId) {
        document.getElementById(errorId).textContent = "";
    }

    var status = document.getElementById("status").value;
    if (status) {
        if (status === "failed") {
            swal("Sorry", "Wrong username or password!", "error");
        } else if (status === "inactive") {
            swal({
                title: "Account Deactivated",
                text: "Your account has been deactivated due to multiple failed login attempts! Please contact support or request reactivation.",
                icon: "error",
                buttons: ["Cancel", "Request Reactivation"],
            }).then((willReactivate) => {
                if (willReactivate) {
                    document.getElementById('reactivationUsername').value = "<%= request.getParameter("username") %>";
                    document.getElementById('reactivationForm').submit();
                }
            });
        } else if (status === "activationRequested") {
            swal("Request Sent", "Your account reactivation request has been sent. Please login again with correct username and password!.", "success");
        }
    }

</script>

</body>
</html>

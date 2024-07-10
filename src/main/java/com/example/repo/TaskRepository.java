package com.example.repo;

import com.example.bean.Task;
import com.example.repo.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TaskRepository {

    //Create Task
    public void createTask(Task task) throws SQLException, ClassNotFoundException {

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO tasks (title, description, due_date, user_id, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setString(3, task.getDueDate());
            ps.setInt(4, task.getUserId());
            ps.setString(5, task.getStatus());
            ps.executeUpdate();
        } finally {
            if (con != null) con.close();
        }
    }

    //Update Task
    public void updateTask(Task task) throws SQLException, ClassNotFoundException {

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE tasks SET title = ?, description = ?, due_date = ?, status = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setDate(3, java.sql.Date.valueOf(task.getDueDate()));
            ps.setString(4, task.getStatus());
            ps.setInt(5, task.getId());
            ps.executeUpdate();
        } finally {
            if (con != null) con.close();
        }
    }

    //Update status of the task
    public void updateTaskStatus(int taskId, String status) throws Exception {

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE tasks SET status = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, status);
                ps.setInt(2, taskId);
                ps.executeUpdate();
        } finally {
            if (con != null) con.close();
        }
    }

    //Delete Task
    public void deleteTask(int taskId) throws SQLException, ClassNotFoundException {

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String query = "DELETE FROM tasks WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, taskId);
            ps.executeUpdate();
        } finally {
            if (con != null) con.close();
        }
    }

}

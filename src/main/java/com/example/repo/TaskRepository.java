package com.example.repo;

import com.example.bean.Task;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
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
        } catch (Exception e) {
            e.printStackTrace();
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
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
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
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (con != null) con.close();
        }
    }

    // Check if task exists
    public boolean checkIfTaskExists(String title, int userId) throws SQLException, ClassNotFoundException {
        Connection con = null;
        boolean exists = false;
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) FROM tasks WHERE title = ? AND user_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, title);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (con != null) con.close();
        }
        return exists;
    }

    // View all tasks
    public List<Task> findByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Task> tasks = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String query = "SELECT id, title, description, due_date, status FROM tasks WHERE user_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Task task = new Task();
            task.setId(rs.getInt("id"));
            task.setTitle(rs.getString("title"));
            task.setDescription(rs.getString("description"));
            task.setDueDate(rs.getString("due_date"));
            task.setStatus(rs.getString("status"));
            tasks.add(task);
        }

        con.close();
        return tasks;
    }

}

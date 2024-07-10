package com.example.service;

import com.example.bean.Task;
import com.example.repo.TaskRepository;

import java.sql.SQLException;

public class TaskService {

    private TaskRepository taskRepository = new TaskRepository();

    public void createTask(Task task) throws SQLException, ClassNotFoundException {
        taskRepository.createTask(task);
    }

    public void updateTask(Task task) throws SQLException, ClassNotFoundException {
        taskRepository.updateTask(task);
    }

    public void updateTaskStatus(int taskId, String status) throws Exception {
        taskRepository.updateTaskStatus(taskId, status);
    }

    public void deleteTask(int taskId) throws SQLException, ClassNotFoundException {
        taskRepository.deleteTask(taskId);
    }
}

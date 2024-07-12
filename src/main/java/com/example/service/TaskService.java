package com.example.service;

import com.example.bean.Task;
import com.example.repo.TaskRepository;
import java.util.List;
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

    public boolean checkIfTaskExists(String title, int userId) throws SQLException, ClassNotFoundException {
        return taskRepository.checkIfTaskExists(title, userId);
    }

    public List<Task> getTasksByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Task> tasks = taskRepository.findByUserId(userId);

        // Sort tasks by due_date
        tasks.sort((task1, task2) -> {
            String dueDate1 = task1.getDueDate();
            String dueDate2 = task2.getDueDate();
            return dueDate1.compareTo(dueDate2);
        });

        return tasks;
    }
}

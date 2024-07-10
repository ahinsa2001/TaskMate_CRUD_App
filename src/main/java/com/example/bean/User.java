package com.example.bean;

public class User {

    private int id;
    private String username;
    private String email;
    private String password;
    private String profilePic;

    public User(String username, String email, String password, String profilePicture) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.profilePic = profilePicture;
    }

    public User(int id, String username, String email, String profilePicture) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.profilePic = profilePicture;
    }

    public User(int id, String username, String email, String password, String profilePicture) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.profilePic = profilePicture;
    }

    public User() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }
}

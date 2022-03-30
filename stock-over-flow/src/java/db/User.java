/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class User {
    private String userEmail;
    private String userName;
    private String userRole;
    private Boolean userVerified;
    private String userToken;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS users("
                + "userEmail VARCHAR(50) UNIQUE NOT NULL,"
                + "userName VARCHAR(200) NOT NULL,"
                + "userRole VARCHAR(20) NOT NULL,"
                + "userPassword LONG NOT NULL,"
                + "userVerified BIT,"
                + "userToken VARCHAR(8)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS users";
    }
    
    public static ArrayList<User> getUsers() throws Exception {
        ArrayList<User> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users");
        while(rs.next()) {
            String userEmail = rs.getString("userEmail");
            String userName = rs.getString("userName");
            String userRole = rs.getString("userRole");
            Boolean userVerified = rs.getBoolean("userVerified");
            String userToken = rs.getString("userToken");
            list.add(new User(userEmail, userName, userRole, userVerified, userToken));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static User getUser(String userEmail, String userPassword) throws Exception {
        User gotUser = null;
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM users WHERE userEmail = ? AND userPassword = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.setLong(2, userPassword.hashCode());
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            String userName = rs.getString("userName");
            String userRole = rs.getString("userRole");
            Boolean userVerified = rs.getBoolean("userVerified");
            String userToken = rs.getString("userToken");
            gotUser = new User(userEmail, userName, userRole, userVerified, userToken);
        }
        stmt.close();
        con.close();
        rs.close();
        return gotUser;
    }
    
    public static void insertUser(String userEmail, String userName, String userRole, String userPassword, Boolean userVerified, String userToken) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO users( userEmail, userName, userRole, userPassword, userVerified, userToken) "
                + "VALUES(?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.setString(2, userName); 
        stmt.setString(3, userRole);
        stmt.setLong(4, userPassword.hashCode());
        stmt.setBoolean(5, userVerified);
        stmt.setString(6, userToken);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterUser(String userEmail, String userName, String userRole, String userPassword) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE users SET userName = ?, userRole = ?, userPassword = ? "
                + "WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userName); 
        stmt.setString(2, userRole);
        stmt.setLong(3, userPassword.hashCode());
        stmt.setString(4, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteUser(String userEmail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM users WHERE userEmail = ? AND userRole <> 'admin'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void changePassword(String userEmail, String userPassword) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE users SET userPassword = ? WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, userPassword.hashCode());
        stmt.setString(2, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void changeStatus(String userEmail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE users SET userVerified = ? WHERE userEmail = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setBoolean(1, true);
        stmt.setString(2, userEmail);
        stmt.execute();
        stmt.close();
        con.close();
    }

     public User(String userEmail, String userName, String userRole, Boolean userVerified, String userToken) {
        this.userEmail = userEmail;
        this.userName = userName;
        this.userRole = userRole;
        this.userVerified = userVerified;
        this.userToken = userToken;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserName() {
        return userName;
    }

    public void setName(String userName) {
        this.userName = userName;
    }
    
    public Boolean getUserVerified() {
        return userVerified;
    }
     
    public void setUserVerified(Boolean userVerified) {
        this.userVerified = userVerified;
    }
     
    public String getUserToken() {
        return userToken;
    }
     
    public void setUserToken(String userToken) throws Exception {
        this.userToken = userToken;
    }


    
}

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
import java.util.Date;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class Movement {
    private int id;
    private String date;
    private double mediumValue;
    private double batchValue;
    private String description;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movement("
                + "id integer PRIMARY KEY AUTOINCREMENT,"
                + "date TEXT NOT NULL,"
                + "medium_value REAL NOT NULL,"
                + "batch_value REAL NOT NULL,"
                + "description TEXT NOT NULL"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS movement";
    }
    
    public static ArrayList<Movement> getMovements() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * from movement");
        while(rs.next()) {
            int id = rs.getInt("id");
            String date = rs.getString("date");
            Double mediumValue = rs.getDouble("medium_value");
            Double batchValue = rs.getDouble("batch_value");
            String description = rs.getString("description");
            list.add(new Movement(id, date, mediumValue, batchValue, description));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertMovement(String date, Double mediumValue, Double batchValue, String description) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO movement(date, medium_value, batch_value, description) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, date);
        stmt.setDouble(2, mediumValue);
        stmt.setDouble(3, batchValue);
        stmt.setString(4, description);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterMovement(int id, String date, Double mediumValue, Double batchValue, String description) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE movement SET date = ?, medium_value = ?, batch_value = ?, description = ? "
                + "WHERE id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, date);
        stmt.setDouble(2, mediumValue);
        stmt.setDouble(3, batchValue);
        stmt.setString(4, description);
        stmt.setInt(5, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteMovement(int id) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM movement WHERE id = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Movement(int id, String date, double mediumValue, double batchValue, String description) {
        this.id = id;
        this.date = date;
        this.mediumValue = mediumValue;
        this.batchValue = batchValue;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public String getDate() {
        return date;
    }

    public double getMediumValue() {
        return mediumValue;
    }

    public double getBatchValue() {
        return batchValue;
    }

    public String getDescription() {
        return description;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setMediumValue(double mediumValue) {
        this.mediumValue = mediumValue;
    }

    public void setBatchValue(double batchValue) {
        this.batchValue = batchValue;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

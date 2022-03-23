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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class Movement {
    private int movId;
    private String movDate;
    private int movProd;
    private String movType;
    private int movQuantity;
    private double movValue;
    private String movDescription;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movement("
                + "movId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "movDate VARCHAR(21) NOT NULL,"
                + "movProd INTEGER,"
                + "movType VARCHAR(7),"
                + "movQuantity INTEGER NOT NULL,"
                + "movValue REAL,"
                + "movDescription VARCHAR(500),"
                + "FOREIGN KEY (movProd) REFERENCES produtos(prodId)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS movement";
    }
    
    public static ArrayList<Movement> getMovements() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM movement");
        while(rs.next()) {
            int movId = rs.getInt("movId");
            int movProd = rs.getInt("movProd");
            String movDate = rs.getString("movDate");
            String movType = rs.getString("movType");
            int movQuantity = rs.getInt("movQuantity");
            Double movValue = rs.getDouble("movValue");
            String movDescription = rs.getString("movDescription");
            list.add(new Movement(movId, movDate, movProd, movType, movQuantity, movValue, movDescription));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertMovement(int movProd, String movType,int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO movement(movDate, movProd, movType, movQuantity, movValue, movDescription) "
                + "VALUES(?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        String currentDate = new SimpleDateFormat("HH:mm:ss | dd/MM/yyyy").format(Calendar.getInstance().getTime());
        stmt.setString(1, currentDate);
        stmt.setInt(2, movProd);
        stmt.setString(3, movType);
        stmt.setDouble(4, movQuantity);
        stmt.setDouble(5, movValue);
        stmt.setString(6, movDescription);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterMovement(int movId, int movProd ,String movType, int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE movement SET movProd = ?, movType = ?,  movQuantity = ?, movValue = ?, movDescription = ? "
                + "WHERE movId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        stmt.setString(2, movType);
        stmt.setInt(3, movQuantity);
        stmt.setDouble(4, movValue);
        stmt.setString(5, movDescription);
        stmt.setInt(6, movId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteMovement(int movId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM movement WHERE movId = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Movement(int movId, String movDate, int movProd, String movType, int movQuantity, double movValue, String movDescription) {
        this.movId = movId;
        this.movDate = movDate;
        this.movProd = movProd;
        this.movType = movType;
        this.movQuantity = movQuantity;
        this.movValue = movValue;
        this.movDescription = movDescription;
    }

    public int getMovId() {
        return movId;
    }

    public String getMovDate() {
        return movDate;
    }
    
    public int getMovProd() {
        return movProd;
    }
    
    public String getMovType() {
        return movType;
    }

    public int getMovQuantity() {
        return movQuantity;
    }

    public double getMovValue() {
        return movValue;
    }

    public String getMovDescription() {
        return movDescription;
    }

    public void setMovId(int movId) {
        this.movId = movId;
    }

    public void setMovDate(String movDate) {
        this.movDate = movDate;
    }
    
    public void setMovType(String movType) {
        this.movType = movType;
    }

    public void setMovQuantity(int movQuantity) {
        this.movQuantity = movQuantity;
    }

    public void setMovValue(double movValue) {
        this.movValue = movValue;
    }

    public void setMovDescription(String movDescription) {
        this.movDescription = movDescription;
    }
    
    public static Integer getQntById(Integer movProd) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT SUM(movQuantity) FROM movement WHERE movProd=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        ResultSet rs = stmt.executeQuery();
        Integer actualQuantity = rs.getInt("SUM(movQuantity)"); 
        stmt.close();
        con.close();
        rs.close();
        return actualQuantity;
    }
}

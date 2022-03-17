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
    private String prodType;
    private int movQuantity;
    private double movValue;
    private String movDescription;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movement("
                + "movId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "movDate VARCHAR(21),"
                + "prodType VARCHAR(200),"
                + "movQuantity INTEGER,"
                + "movValue REAL,"
                + "movDescription VARCHAR(500)"
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
            String prodType = rs.getString("prodType");
            String movDate = rs.getString("movDate");
            int movQuantity = rs.getInt("movQuantity");
            Double movValue = rs.getDouble("movValue");
            String movDescription = rs.getString("movDescription");
            list.add(new Movement(movId, movDate, prodType, movQuantity, movValue, movDescription));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertMovement(String prodType, int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO movement(movDate, prodType, movQuantity, movValue, movDescription) "
                + "VALUES(?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        String currentDate = new SimpleDateFormat("HH:mm:ss | dd/MM/yyyy").format(Calendar.getInstance().getTime());
        stmt.setString(1, currentDate);
        stmt.setString(2, prodType);
        stmt.setDouble(3, movQuantity);
        stmt.setDouble(4, movValue);
        stmt.setString(5, movDescription);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterMovement(int movId, int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE movement SET movQuantity = ?, movValue = ?, movDescription = ? "
                + "WHERE movId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movQuantity);
        stmt.setDouble(2, movValue);
        stmt.setString(3, movDescription);
        stmt.setInt(4, movId);
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

    public Movement(int movId, String movDate, String prodType, int movQuantity, double movValue, String movDescription) {
        this.movId = movId;
        this.movDate = movDate;
        this.prodType = prodType;
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
    
    public String getMovProdType() {
        return prodType;
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

    public void setMovQuantity(int movQuantity) {
        this.movQuantity = movQuantity;
    }

    public void setMovValue(double movValue) {
        this.movValue = movValue;
    }

    public void setMovDescription(String movDescription) {
        this.movDescription = movDescription;
    }
}

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
public class Provider {
    private int provId;
    private String provName;
    private String provLocation;
    private String provTelephone;
    private String provMail;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS provider("
                + "provId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "provName VARCHAR(50) UNIQUE NOT NULL,"
                + "provLocation VARCHAR(100),"
                + "provTelephone VARCHAR(15) UNIQUE,"
                + "provMail VARCHAR(100) UNIQUE"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS provider";
    }
    
    public static ArrayList<Provider> getProviders() throws Exception {
        ArrayList<Provider> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM provider");
        while(rs.next()) {
            int provId = rs.getInt("provId");
            String provName = rs.getString("provName");
            String provLocation = rs.getString("provLocation");
            String provTelephone = rs.getString("provTelephone");
            String provMail = rs.getString("provMail");
            list.add(new Provider(provId, provName, provLocation, provTelephone, provMail));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertProvider(String provName, String provLocation, String provTelephone, String provMail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO provider(provName, provLocation, provTelephone, provMail) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName);
        stmt.setString(2, provLocation);
        stmt.setString(3, provTelephone);
        stmt.setString(4, provMail);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProvider(int provId, String provName, String provLocation, String provTelephone, String provMail) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE provider SET provName = ?, provLocation = ?, provTelephone = ?, provMail = ? "
                + "WHERE provId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, provName); 
        stmt.setString(2, provLocation);
        stmt.setString(3, provTelephone);
        stmt.setString(4, provMail);
        stmt.setInt(5, provId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProvider(int provId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM provider WHERE provId = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, provId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Provider(int provId, String provName, String provLocation, String provTelephone, String provMail) {
        this.provId = provId;
        this.provName = provName;
        this.provLocation = provLocation;
        this.provTelephone = provTelephone;
        this.provMail = provMail;
    }

    public int getProvId() {
        return provId;
    }

    public String getProvName() {
        return provName.replaceAll("\"","&quot");
    }

    public String getProvLocation() {
        return provLocation.replaceAll("\"","&quot");
    }

    public String getProvTelephone() {
        return provTelephone.replaceAll("\"","&quot");
    }

    public String getProvMail() {
        return provMail.replaceAll("\"","&quot");
    }
    
    public void setProvId(int provId) {
        this.provId = provId;
    }

    public void setProvName(String provName) {
        this.provName = provName;
    }

    public void setProvLocation(String provLocation) {
        this.provLocation = provLocation;
    }

    public void setProvTelephone(String provTelephone) {
        this.provTelephone = provTelephone;
    }
    
    public void setProvMail(String provMail) {
        this.provMail = provMail;
    }
    
    public static ArrayList<Integer> getProvIds() throws Exception {
        ArrayList<Integer> idList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT provId FROM provider");
        while(rs.next()) {
            int provId = rs.getInt("provId");
            idList.add(provId);
        }
        rs.close();
        stmt.close();
        con.close();
        return idList;
    }
    
    public static String getProvNameById(Integer provId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT provName FROM provider WHERE provId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, provId);
        ResultSet rs = stmt.executeQuery();
        String provName = rs.getString("provName"); 
        stmt.close();
        con.close();
        rs.close();
        return provName;
    }
    
    public static Integer getProvQntById(Integer provId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT SUM(movQuantity) FROM movement WHERE movProv=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, provId);
        ResultSet rs = stmt.executeQuery();
        Integer provQnt = rs.getInt("SUM(movQuantity)"); 
        stmt.close();
        con.close();
        rs.close();
        return provQnt;
    }
}

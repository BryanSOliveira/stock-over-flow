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
public class Marca {

    private int brandId;
    private String brandName;
    private String brandDesc;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS brand("
                + "brandId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "brandName VARCHAR(50) NOT NULL,"
                + "brandDesc varchar(1000)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS brand";
    }
    
    public static ArrayList<Marca> getBrands() throws Exception {
        ArrayList<Marca> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM brand");
        while(rs.next()) {
            int brandId = rs.getInt("brandId");
            String brandName = rs.getString("brandName");
            String brandDesc = rs.getString("brandDesc");
            list.add(new Marca(brandId, brandName, brandDesc));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertBrand(String brandName, String brandDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO brand(brandName, brandDesc) "
                + "VALUES(?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName);
        stmt.setString(2, brandDesc);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterBrand(int brandId, String brandName, String brandDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE brand SET brandName = ?, brandDesc = ? "
                + "WHERE brandId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName); 
        stmt.setString(2, brandDesc); 
        stmt.setInt(3, brandId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteBrand(int brandId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM brand WHERE brandId = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, brandId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Marca(int brandId, String brandName, String brandDesc) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.brandDesc = brandDesc;
    }

    public int getBrandId() {
        return brandId;
    }

    public String getBrandName() {
        return brandName;
    }
    
    public String getBrandDesc() {
        return brandDesc;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public void setBrandDesc(String brandDesc) {
        this.brandDesc = brandDesc;
    }
    
    public static ArrayList<Integer> getBrandIds() throws Exception {
        ArrayList<Integer> idList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT brandId FROM brand");
        while(rs.next()) {
            int brandId = rs.getInt("brandId");
            idList.add(brandId);
        }
        rs.close();
        stmt.close();
        con.close();
        return idList;
    }
    
    public static String getBrandNameById(Integer brandId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT brandName FROM brand WHERE brandId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, brandId);
        ResultSet rs = stmt.executeQuery();
        String brandName = rs.getString("brandName"); 
        stmt.close();
        con.close();
        rs.close();
        return brandName;
    }
    
}
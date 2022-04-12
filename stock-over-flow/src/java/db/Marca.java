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

    private String brandName;
    private String brandDesc;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS brand("
                + "brandName VARCHAR(50) UNIQUE NOT NULL,"
                + "brandDesc VARCHAR(1000)"
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
            String brandName = rs.getString("brandName");
            String brandDesc = rs.getString("brandDesc");
            list.add(new Marca(brandName, brandDesc));
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
    
    public static void alterBrand(String oldBrandName, String brandName, String brandDesc) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE brand SET brandName = ?, brandDesc = ? "
                + "WHERE brandName = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName); 
        stmt.setString(2, brandDesc); 
        stmt.setString(3, oldBrandName);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteBrand(String brandName) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM brand WHERE brandName = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, brandName);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Marca(String brandName, String brandDesc) {
        this.brandName = brandName;
        this.brandDesc = brandDesc;
    }

    public String getBrandName() {
        return brandName.replaceAll("\"","&quot");
    }
    
    public String getBrandDesc() {
        return brandDesc.replaceAll("\"","&quot");
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    
    public void setBrandDesc(String brandDesc) {
        this.brandDesc = brandDesc;
    }
    
    public static ArrayList<String> getBrandNames() throws Exception {
        ArrayList<String> brandList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT brandName FROM brand");
        while(rs.next()) {
            String brandName = rs.getString("brandName");
            brandList.add(brandName);
        }
        rs.close();
        stmt.close();
        con.close();
        return brandList;
    }
    
}
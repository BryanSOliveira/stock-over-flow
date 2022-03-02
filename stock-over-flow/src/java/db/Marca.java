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

    private int id;
    private String name;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS brand("
                + "id integer PRIMARY KEY AUTOINCREMENT,"
                + "name VARCHAR(50) UNIQUE NOT NULL"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS brand";
    }
    
    public static ArrayList<Marca> getBrands() throws Exception {
        ArrayList<Marca> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * from brand");
        while(rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            list.add(new Marca(id, name));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertBrand(String name) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO brand(name) "
                + "VALUES(?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterBrand(int id, String name) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE brand SET name = ? "
                + "WHERE id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, name); 
        stmt.setInt(2, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteBrand(int id) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM brand WHERE id = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Marca(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }
}
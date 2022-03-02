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
    private int id;
    private String name;
    private String address;
    private String telephone;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS provider("
                + "id integer PRIMARY KEY AUTOINCREMENT,"
                + "name VARCHAR(50) UNIQUE NOT NULL,"
                + "address VARCHAR(100) NOT NULL,"
                + "telephone VARCHAR(15) UNIQUE NOT NULL"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS provider";
    }
    
    public static ArrayList<Provider> getProviders() throws Exception {
        ArrayList<Provider> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * from provider");
        while(rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String address = rs.getString("address");
            String telephone = rs.getString("telephone");
            list.add(new Provider(id, name, address, telephone));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertProvider(String name, String address, String telephone) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO provider(name, address, telephone) "
                + "VALUES(?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.setString(2, address);
        stmt.setString(3, telephone);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProvider(int id, String name, String address, String telephone) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE provider SET name = ?, address = ?, telephone = ? "
                + "WHERE id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, name); 
        stmt.setString(2, address);
        stmt.setString(3, telephone);
        stmt.setInt(4, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProvider(int id) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM provider WHERE id = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Provider(int id, String name, String address, String telephone) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.telephone = telephone;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
}

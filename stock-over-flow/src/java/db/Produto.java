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
public class Produto {
    private int prod_id;
    private String prod_nm;
    private String prod_mt;
    private String prod_sz;
    
    /*
    private Marca brand;
    private Provider provider;
    private Movement value;
    private Movement availability;
    private Movement amount;
    */
    
    public static String getCreateStatement() {
        return "create table if not exists prods("
                + "prod_id integer unique not null,"
                + "prod_nm varchar(200) not null,"
                + "prod_mt varchar(200) not null,"
                + "prod_sz varchar(20) not null"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "drop table if exists prods";
    }
    
    public static ArrayList<Produto> getProds() throws Exception {
        ArrayList<Produto> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("select * from prods");
        while(rs.next()) {
            Integer prod_id = rs.getInt("prod_id");
            String prod_nm = rs.getString("prod_nm");
            String prod_mt = rs.getString("prod_mt");
            String prod_sz = rs.getString("prod_sz");
            list.add(new Produto(prod_id, prod_nm, prod_mt, prod_sz));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static Produto getProd(Integer prod_id, String prod_nm, String prod_mt, String prod_sz) throws Exception {
        Produto prod = null;
        Connection con = DbListener.getConnection();
        String sql = "select * from prods where id=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prod_id);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            Integer id = rs.getInt("prod_id");
            String name = rs.getString("prod_nm");
            String material = rs.getString("prod_mt");
            String size = rs.getString("prod_sz");
            prod = new Produto(id, name, material, size);
        }
        stmt.close();
        con.close();
        rs.close();
        return prod;
    }
    
    public static void insertProd(Integer id, String name, String material, String size) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "insert into prods(prod_id, prod_nm, prod_mt, prod_sz) "
                + "values(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.setString(2, name); 
        stmt.setString(3, material);
        stmt.setString(4, size);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProd(Integer id, String name, String material, String size) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "update prods set prod_nm = ?, prod_mt = ?, prod_sz = ? "
                + "where prod_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, name); 
        stmt.setString(2, material);
        stmt.setString(3, size);
        stmt.setInt(4, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProd(Integer id) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "delete from prods where prod_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Produto(Integer id, String name, String material, String size) {
        this.prod_id = id;
        this.prod_nm = name;
        this.prod_mt = material;
        this.prod_sz = size;
    }

    public Integer getProdId() {
        return prod_id;
    }

    public void setProdId(Integer id) {
        this.prod_id = id;
    }

    public String getProdNm() {
        return prod_nm;
    }

    public void setProdNm(String name) {
        this.prod_nm = name;
    }
    public String getProdMt() {
        return prod_mt;
    }

    public void setProdMt(String material) {
        this.prod_mt = material;
    }
    public String getProdSz() {
        return prod_sz;
    }

    public void setProdSz(String size) {
        this.prod_sz = size;
    }
}

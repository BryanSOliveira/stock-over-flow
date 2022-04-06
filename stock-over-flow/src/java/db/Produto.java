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
    private int prodId;
    private String prodName;
    private int prodBrand;
    private String prodMaterial;
    private String prodSize;
    
    /*
    private Marca brand;
    private Provider provider;
    private Movement value;
    private Movement availability;
    private Movement amount;
    */
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS produtos("
                + "prodId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "prodName VARCHAR(200) NOT NULL,"
                + "prodBrand INTEGER,"
                + "prodMaterial VARCHAR(200) NOT NULL,"
                + "prodSize VARCHAR(20) NOT NULL,"
                + "FOREIGN KEY (prodBrand) REFERENCES brands(brandId)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS produtos";
    }
    
    public static ArrayList<Produto> getProdutos() throws Exception {
        ArrayList<Produto> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM produtos");
        while(rs.next()) {
            Integer prodId = rs.getInt("prodId");
            String prodName = rs.getString("prodName");
            Integer prodBrand = rs.getInt("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            list.add(new Produto(prodId, prodName, prodBrand, prodMaterial, prodSize));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static Produto getProd(Integer prodId) throws Exception {
        Produto prod = null;
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM produtos WHERE prodId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            String prodName = rs.getString("prodName");
            Integer prodBrand = rs.getInt("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            prod = new Produto(prodId, prodName, prodBrand, prodMaterial, prodSize);
        }
        stmt.close();
        con.close();
        rs.close();
        return prod;
    }
    
    public static void insertProd(String prodName, Integer prodBrand,String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO produtos(prodName, prodBrand, prodMaterial, prodSize) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setInt(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProd(Integer prodId, String prodName, Integer prodBrand, String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE produtos SET prodName = ?, prodBrand = ?, prodMaterial = ?, prodSize = ? "
                + "WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setInt(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.setInt(5, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProd(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM produtos WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public Produto(Integer prodId, String prodName, Integer prodBrand, String prodMaterial, String prodSize) {
        this.prodId = prodId;
        this.prodName = prodName;
        this.prodBrand = prodBrand;
        this.prodMaterial = prodMaterial;
        this.prodSize = prodSize;
    }

    public Integer getProdId() {
        return prodId;
    }

    public void setProdId(Integer prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName.replaceAll("\"","&quot");
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }
    
    public Integer getProdBrand() {
        return prodBrand;
    }

    public void setProdBrand(Integer prodBrand) {
        this.prodBrand = prodBrand;
    }
    
    public String getProdMaterial() {
        return prodMaterial.replaceAll("\"","&quot");
    }

    public void setProdMaterial(String prodMaterial) {
        this.prodMaterial = prodMaterial;
    }
    public String getProdSize() {
        return prodSize.replaceAll("\"","&quot");
    }

    public void setProdSize(String prodSize) {
        this.prodSize = prodSize;
    }
    
    public static ArrayList<Integer> getProdIds() throws Exception {
        ArrayList<Integer> idList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT prodId FROM produtos");
        while(rs.next()) {
            int prodId = rs.getInt("prodId");
            idList.add(prodId);
        }
        rs.close();
        stmt.close();
        con.close();
        return idList;
    }
    
    public static String getProdNameById(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT prodName FROM produtos WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        ResultSet rs = stmt.executeQuery();
        String prodName = rs.getString("prodName"); 
        stmt.close();
        con.close();
        rs.close();
        return prodName;
    }
    
    public static int countProds() throws Exception {
        int prodQuantity = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM produtos");
        while(rs.next()) {
            prodQuantity = rs.getInt("COUNT(*)");
        }
        rs.close();
        stmt.close();
        con.close();
        return prodQuantity;
    }
}

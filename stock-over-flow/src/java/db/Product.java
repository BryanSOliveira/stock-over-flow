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
public class Product {
    private int prodId;
    private String prodName;
    private String prodBrand;
    private String prodMaterial;
    private String prodSize;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS product("
                + "prodId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "prodName VARCHAR(200) NOT NULL,"
                + "prodBrand VARCHAR(50),"
                + "prodMaterial VARCHAR(200),"
                + "prodSize VARCHAR(20)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS product";
    }
    
    public static ArrayList<Product> getProds() throws Exception {
        ArrayList<Product> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM product");
        while(rs.next()) {
            Integer prodId = rs.getInt("prodId");
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            list.add(new Product(prodId, prodName, prodBrand, prodMaterial, prodSize));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static Product getProd(Integer prodId) throws Exception {
        Product prod = null;
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM product WHERE prodId=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            prod = new Product(prodId, prodName, prodBrand, prodMaterial, prodSize);
        }
        stmt.close();
        con.close();
        rs.close();
        return prod;
    }
    
    public static void insertProd(String prodName, String prodBrand,String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO product(prodName, prodBrand, prodMaterial, prodSize) "
                + "VALUES(?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setString(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterProd(Integer prodId, String prodName, String prodBrand, String prodMaterial, String prodSize) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE product SET prodName = ?, prodBrand = ?, prodMaterial = ?, prodSize = ? "
                + "WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, prodName); 
        stmt.setString(2, prodBrand); 
        stmt.setString(3, prodMaterial);
        stmt.setString(4, prodSize);
        stmt.setInt(5, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteProd(Integer prodId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM product WHERE prodId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, prodId);
        stmt.execute();
        stmt.close();
        con.close();
    }

    public static ArrayList<Integer> getProdIds() throws Exception {
        ArrayList<Integer> idList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT prodId FROM product");
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
        String sql = "SELECT prodName FROM product WHERE prodId = ?";
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
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM product");
        
        prodQuantity = rs.getInt("COUNT(*)");
        
        rs.close();
        stmt.close();
        con.close();
        return prodQuantity;
    }
    
    public static ArrayList<Product> getPageOrderBy(int offSet, String byOrder, String bySearch) throws Exception {
        ArrayList<Product> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        String sql = "SELECT * FROM product";
        String src = "";
        String ord = "";

        if (byOrder != "" && byOrder != null) {
            ord = " ORDER BY " + byOrder;
        }
        if (bySearch != "" && bySearch != null) {
            src = " WHERE prodId LIKE ? OR prodName LIKE ?"
                    + " OR prodBrand LIKE ? OR prodMaterial LIKE ?"
                    + " OR prodSize LIKE ?";

        }
        sql = sql + src + ord + " LIMIT 10 OFFSET ?";

        PreparedStatement stmt = con.prepareStatement(sql);

        if (bySearch != "" && bySearch != null) {

            stmt.setString(1, "%"+bySearch+"%");
            stmt.setString(2, "%"+bySearch+"%");
            stmt.setString(3, "%"+bySearch+"%");
            stmt.setString(4, "%"+bySearch+"%");
            stmt.setString(5, "%"+bySearch+"%");
            
            stmt.setInt(6, offSet);

        } else {
            stmt.setInt(1, offSet);
        }
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            int prodId = rs.getInt("prodId");
            String prodName = rs.getString("prodName");
            String prodBrand = rs.getString("prodBrand");
            String prodMaterial = rs.getString("prodMaterial");
            String prodSize = rs.getString("prodSize");
            
            list.add(new Product(prodId, prodName, prodBrand, prodMaterial, prodSize));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getSearchPage(String bySearch) throws Exception {
        int pgCount = 0;
        Connection con = DbListener.getConnection();
        String sql = "SELECT COUNT(*) FROM product"
                   + " WHERE prodId LIKE ? OR prodName LIKE ?"
                   + " OR prodBrand LIKE ? OR prodMaterial LIKE ?"
                   + " OR prodSize LIKE ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setString(1, "%"+bySearch+"%");
        stmt.setString(2, "%"+bySearch+"%");
        stmt.setString(3, "%"+bySearch+"%");
        stmt.setString(4, "%"+bySearch+"%");
        stmt.setString(5, "%"+bySearch+"%");

        ResultSet rs = stmt.executeQuery();
        pgCount = rs.getInt("COUNT(*)");
        rs.close();
        stmt.close();
        con.close();
        return pgCount;
    }

    public static int getAll() throws Exception {
        int allProd = 0;
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM product");

        allProd = rs.getInt("COUNT(*)");

        rs.close();
        stmt.close();
        con.close();
        return allProd;
    }
    
    public Product(Integer prodId, String prodName, String prodBrand, String prodMaterial, String prodSize) {
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
    
    public String getProdBrand() {
        return prodBrand;
    }

    public void setProdBrand(String prodBrand) {
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

}

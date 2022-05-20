/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import db.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author spbry
 */
public class DbListener implements ServletContextListener {
    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:stock-3.db";
    
    public static Exception exception = null;
    
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL);
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Class.forName(CLASS_NAME);
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            
            
            stmt.execute(User.getCreateStatement());
            stmt.execute(Product.getCreateStatement());
            stmt.execute(Brand.getCreateStatement());
            stmt.execute(Provider.getCreateStatement());
            stmt.execute(Movement.getCreateStatement());
            
            
            /*
            stmt.execute(User.getDestroyStatement());
            stmt.execute(Brand.getDestroyStatement());
            stmt.execute(Provider.getDestroyStatement());
            stmt.execute(Movement.getDestroyStatement());
            stmt.execute(Product.getDestroyStatement());
            */
            
            if(User.getUsers().isEmpty()) {
                User.insertUser("admin", "Administrador", "Admin", "123", true, "99999999");
                User.insertUser("user", "Usuário", "Usuario", "123", true, "99999999");
            }
            if(Product.getProds().isEmpty()) {
                Product.insertProd("Tênis", "Nike", "Composto", "41/42");
                Product.insertProd("Blusa", "Hering", "Poliester", "G");
                Product.insertProd("Calça Jeans Wide Leg", "Offtrack", "Jeans", "42");
            }
            if(Movement.getMovements().isEmpty()) {
                Movement.insertMovement(1, "Sistema","Nike", "Entrada", 40, 125.95, "Entrada de produtos no estoque");
                Movement.insertMovement(1, "Sistema","Hering", "Entrada", 30, 189.99, "Entrada de produtos no estoque");
                Movement.insertMovement(1, "Sistema","Offtrack", "Entrada", 30, 230.00, "Entrada de produtos no estoque");
                Movement.insertMovement(1, "Sistema","Offtrack", "Saída", 5, 100.00, "Saída de produtos no estoque");
               
            }
            if(Brand.getBrands().isEmpty()) {
                Brand.insertBrand("Nike", "Roupas");
                Brand.insertBrand("Hering", "Roupas");
                Brand.insertBrand("Offtrack", "Tenis");
                
            }
            if(Provider.getProviders().isEmpty()) {
                Provider.insertProvider("Departure Selling", "Rua São Paulo, 158", "(11) 98570-9815", "marketing@departure.com.br");
                Provider.insertProvider("Hering", "Av. Anchieta, 5981", "(13) 4567-4222", "hering@gmail.com");
                Provider.insertProvider("Offtrack", "Av. Rio Claro, 5981", "(13) 7865-4092", "offtrack@gmail.com");
                
            }
            stmt.close();
            con.close();
        } catch(Exception ex) {
            exception = ex;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Connection con = getConnection();
            Statement stmt = con.createStatement();
            stmt.execute(Brand.getDestroyStatement());
            stmt.execute(User.getDestroyStatement());
            stmt.execute(Provider.getDestroyStatement());
            stmt.execute(Movement.getCreateStatement());
            stmt.close();
            con.close();
        } catch(Exception ex) {
            exception = ex;
        }
    }
}

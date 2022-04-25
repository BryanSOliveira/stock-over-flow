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
    public static final String URL = "jdbc:sqlite:stk-17.db";
    
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
                Product.insertProd("Camisa", "Adidas", "Poliester", "G");
                Product.insertProd("Calça Jeans", "Offtrack", "Jeans", "42");
            }
            if(Movement.getMovements().isEmpty()) {
                Movement.insertMovement(1, "Departure Selling", "Entrada", 20, 15.99, "Entrada de produtos");
                Movement.insertMovement(1, "Mannugaroupas", "Entrada", 30, 14.99, "Preparação de estoque");
                Movement.insertMovement(1, "Departure Selling", "Saída", -4, 17.99, "Venda padrão");
            }
            if(Brand.getBrands().isEmpty()) {
                Brand.insertBrand("Nike", "Roupas");
                Brand.insertBrand("Adidas", "Roupas");
                Brand.insertBrand("Offtrack", "Tenis");
                
            }
            if(Provider.getProviders().isEmpty()) {
                Provider.insertProvider("Departure Selling", "Rua São Paulo, 158", "(11) 98570-9815", "marketing@departure.com.br");
                Provider.insertProvider("Manugaroupas", "Av. Anchieta, 5981", "(13) 4567-4222", "maguroupas@gmail.com");
                
                
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

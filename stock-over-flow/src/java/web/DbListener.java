/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import db.*;
/*import db.Marca;
import db.Movement;
import db.Produto;
import db.Provider;
import db.User;*/
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
    public static final String URL = "jdbc:sqlite:stock27.db";
    
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
            
            ///*
            stmt.execute(User.getCreateStatement());
            stmt.execute(Produto.getCreateStatement());
            stmt.execute(Marca.getCreateStatement());
            stmt.execute(Provider.getCreateStatement());
            stmt.execute(Movement.getCreateStatement());
            //*/
            
            /*
            stmt.execute(User.getDestroyStatement());
            stmt.execute(Marca.getDestroyStatement());
            stmt.execute(Provider.getDestroyStatement());
            stmt.execute(Movement.getDestroyStatement());
            stmt.execute(Produto.getDestroyStatement());
            */
            
            if(User.getUsers().isEmpty()) {
                User.insertUser("admin", "Administrador", "admin", "123", true);
            }
            if(Produto.getProdutos().isEmpty()) {
                Produto.insertProd("Tênis", 1, "Composto", "41/42");
                Produto.insertProd("Camisa", 2, "Poliester", "G");
                Produto.insertProd("Calça Jeans", 3, "Jeans", "42");
            }
            if(Movement.getMovements().isEmpty()) {
                Movement.insertMovement(1, 1, "Entrada", 20, 15.99, "Entrada de produtos");
                Movement.insertMovement(1, 2, "Entrada", 30, 14.99, "Preparação de estoque");
                Movement.insertMovement(1, 1, "Saida", -4, 17.99, "Venda padrão");
            }
            if(Marca.getBrands().isEmpty()) {
                Marca.insertBrand("Nike", "Roupas");
                Marca.insertBrand("Adidas", "Roupas");
                Marca.insertBrand("Offtrack", "Tenis");
                
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
            stmt.execute(Marca.getDestroyStatement());
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

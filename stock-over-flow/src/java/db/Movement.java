/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package db;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPRow;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.http.HttpServletResponse;
import web.DbListener;

/**
 *
 * @author spbry
 */
public class Movement {
    private int movId;
    private String movDate;
    private int movProd;
    private String movName;
    private String movProv;
    private String movType;
    private int movQuantity;
    private double movValue;
    private String movDescription;
    
    public static String getCreateStatement() {
        return "CREATE TABLE IF NOT EXISTS movement("
                + "movId INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "movDate VARCHAR(21) NOT NULL,"
                + "movProd INTEGER,"
                + "movName VARCHAR(200),"
                + "movProv VARCHAR(50),"
                + "movType VARCHAR(7),"
                + "movQuantity INTEGER NOT NULL,"
                + "movValue REAL,"
                + "movDescription VARCHAR(500)"
                + ")";
    }
    
    public static String getDestroyStatement() {
        return "DROP TABLE IF EXISTS movement";
    }
    
    public static ArrayList<Movement> getMovements() throws Exception {
        ArrayList<Movement> list = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM movement");
        while(rs.next()) {
            int movId = rs.getInt("movId");
            int movProd = rs.getInt("movProd");
            String movName = rs.getString("movName");
            String movProv = rs.getString("movProv");
            String movDate = rs.getString("movDate");
            String movType = rs.getString("movType");
            int movQuantity = rs.getInt("movQuantity");
            Double movValue = rs.getDouble("movValue");
            String movDescription = rs.getString("movDescription");
            list.add(new Movement(movId, movDate, movProd, movName, movProv, movType, movQuantity, movValue, movDescription));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static void insertMovement(int movProd, String movProv, String movType,int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "INSERT INTO movement(movDate, movProd, movName, movProv, movType, movQuantity, movValue, movDescription) "
                + "VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        String currentDate = new SimpleDateFormat("HH:mm:ss | dd/MM/yyyy").format(Calendar.getInstance().getTime());
        String prodTarget = Product.getProdNameById(movProd);
        stmt.setString(1, currentDate);
        stmt.setInt(2, movProd);
        stmt.setString(3, prodTarget);
        stmt.setString(4, movProv);
        stmt.setString(5, movType);
        stmt.setDouble(6, movQuantity);
        stmt.setDouble(7, movValue);
        stmt.setString(8, movDescription);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void alterMovement(int movId, int movProd , String movProv, String movType, int movQuantity, Double movValue, String movDescription) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "UPDATE movement SET movProd = ?, movProv = ?, movType = ?,  movQuantity = ?, movValue = ?, movDescription = ? "
                + "WHERE movId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        stmt.setString(2, movProv);
        stmt.setString(3, movType);
        stmt.setInt(4, movQuantity);
        stmt.setDouble(5, movValue);
        stmt.setString(6, movDescription);
        stmt.setInt(7, movId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void deleteMovement(int movId) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "DELETE FROM movement WHERE movId = ? ";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movId);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public static void generateReport(ArrayList<Movement> movements, HttpServletResponse response) throws Exception {
        Document document = new Document();
        response.setContentType("apllication/pdf");
	response.addHeader("Content-Disposition", "inline; filename=" + "movimentacoes.pdf");
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
        
        PdfPTable profitTable = new PdfPTable(3);
        profitTable.setWidthPercentage(100);
        //float[] widths = new float[] {20f, 120f, 50f, 70f, 70f, 30f, 50f, 100f};
        //profitTable.setWidths(widths);
        PdfPCell colProfit1 = new PdfPCell(new Paragraph("Total de Custo"));
        colProfit1.setBackgroundColor(BaseColor.LIGHT_GRAY);
        PdfPCell colProfit2 = new PdfPCell(new Paragraph("Total de Vendas"));
        colProfit2.setBackgroundColor(BaseColor.LIGHT_GRAY);
        PdfPCell colProfit3 = new PdfPCell(new Paragraph("Lucro / Prejuízo"));
        colProfit3.setBackgroundColor(BaseColor.LIGHT_GRAY);
        profitTable.addCell(colProfit1);
        profitTable.addCell(colProfit2);
        profitTable.addCell(colProfit3);    

        double valueAllEntries = 0, valueAllOutputs = 0;
        for(Movement movement: movements) {
            if(movement.getMovType().equals("Entrada")) {
                valueAllEntries += movement.getMovValue();
            } else if(movement.getMovType().equals("Saída")) {
                valueAllOutputs += movement.getMovValue();
            }
        }
        BigDecimal entries = new BigDecimal(valueAllEntries).setScale(2, RoundingMode.HALF_EVEN);
        BigDecimal outputs = new BigDecimal(valueAllOutputs).setScale(2, RoundingMode.HALF_EVEN);
        BigDecimal profit = new BigDecimal(valueAllOutputs - valueAllEntries).setScale(2, RoundingMode.HALF_EVEN);
        profitTable.addCell("R$ " + String.valueOf(entries.doubleValue()));
        profitTable.addCell("R$ " + String.valueOf(outputs.doubleValue()));
        profitTable.addCell("R$ " + String.valueOf(profit.doubleValue()));
        document.add(profitTable);
        
        document.add(new Paragraph("Movimentações:"));
        document.add(new Paragraph(" "));
        PdfPTable table = new PdfPTable(8);
        table.setWidthPercentage(100);
        float[] widths = new float[] {20f, 120f, 50f, 70f, 70f, 30f, 50f, 100f};
        table.setWidths(widths);
        PdfPCell col1 = new PdfPCell(new Paragraph("ID"));
        PdfPCell col2 = new PdfPCell(new Paragraph("Horário | Data"));
        PdfPCell col3 = new PdfPCell(new Paragraph("Mov."));
        PdfPCell col4 = new PdfPCell(new Paragraph("Produto"));
        PdfPCell col5 = new PdfPCell(new Paragraph("Fornecedor"));
        PdfPCell col6 = new PdfPCell(new Paragraph("Qtd."));
        PdfPCell col7 = new PdfPCell(new Paragraph("Valor"));
        PdfPCell col8 = new PdfPCell(new Paragraph("Descrição"));
        table.addCell(col1);
        table.addCell(col2);
        table.addCell(col3);
        table.addCell(col4);
        table.addCell(col5);
        table.addCell(col6);
        table.addCell(col7);
        table.addCell(col8);
        for(int i = 0; i < movements.size(); i++) {
            table.addCell(Integer.toString(movements.get(i).getMovId()));
            table.addCell(movements.get(i).getMovDate());
            table.addCell(movements.get(i).getMovType());
            table.addCell(Product.getProdNameById(movements.get(i).getMovProd()));
            table.addCell(movements.get(i).getMovProv());
            table.addCell(Integer.toString(movements.get(i).getMovQuantity()));
            table.addCell(Double.toString(movements.get(i).getMovValue()));
            table.addCell(movements.get(i).getMovDescription());
        }
        int i = 0;
        for(PdfPRow r: table.getRows()) {
            for(PdfPCell c: r.getCells()) {
                if(i == 0)
                    c.setBackgroundColor(BaseColor.LIGHT_GRAY);
                else 
                    c.setBackgroundColor(i % 2 == 0 ? BaseColor.ORANGE : BaseColor.WHITE);
            }
            i++;
        }
        document.add(table);
        document.close();
    }

    public Movement(int movId, String movDate, int movProd, String movName, String movProv, String movType, int movQuantity, double movValue, String movDescription) {
        this.movId = movId;
        this.movDate = movDate;
        this.movProd = movProd;
        this.movName = movName;
        this.movProv = movProv;
        this.movType = movType;
        this.movQuantity = movQuantity;
        this.movValue = movValue;
        this.movDescription = movDescription;
    }

    public int getMovId() {
        return movId;
    }

    public String getMovDate() {
        return movDate;
    }
    
    public int getMovProd() {
        return movProd;
    }
    
    public String getMovName() {
        return movName;
    }
    
    public String getMovProv() {
        return movProv;
    }
    
    public String getMovType() {
        return movType;
    }

    public int getMovQuantity() {
        return movQuantity;
    }

    public double getMovValue() {
        return movValue;
    }

    public String getMovDescription() {
        return movDescription.replaceAll("\"","&quot");
    }

    public void setMovId(int movId) {
        this.movId = movId;
    }

    public void setMovDate(String movDate) {
        this.movDate = movDate;
    }
    
    public void setMovProd(int movProd) {
        this.movProd = movProd;
    }
    
    public void setMovName(String movName) {
        this.movName = movName;
    }
    
    public void setMovProv(String movProv) {
        this.movProv = movProv;
    }
    
    public void setMovType(String movType) {
        this.movType = movType;
    }

    public void setMovQuantity(int movQuantity) {
        this.movQuantity = movQuantity;
    }

    public void setMovValue(double movValue) {
        this.movValue = movValue;
    }

    public void setMovDescription(String movDescription) {
        this.movDescription = movDescription;
    }
    
    public static Integer getQntById(Integer movProd) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT SUM(movQuantity) FROM movement WHERE movProd=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        ResultSet rs = stmt.executeQuery();
        Integer actualQuantity = rs.getInt("SUM(movQuantity)"); 
        stmt.close();
        con.close();
        rs.close();
        return actualQuantity;
    }
    
    public static double getAvgById(Integer movProd) throws Exception {
        Connection con = DbListener.getConnection();
        String sql = "SELECT AVG(movValue) FROM movement WHERE movProd=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, movProd);
        ResultSet rs = stmt.executeQuery();
        double prodAvgValue = Math.round(rs.getDouble("AVG(movValue)")*100); 
               prodAvgValue = prodAvgValue/100;
        stmt.close();
        con.close();
        rs.close();
        return prodAvgValue;
    }
    
    public static ArrayList<String> getMovNames() throws Exception {
        ArrayList<String> nameList = new ArrayList<>();
        Connection con = DbListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT movName FROM movement");
        while(rs.next()) {
            String movName = rs.getString("movName");
            nameList.add(movName);
        }
        rs.close();
        stmt.close();
        con.close();
        return nameList;
    }
    
}

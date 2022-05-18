<%-- 
    Document   : index
    Created on : 12 de fev. de 2022, 12:43:57
    Author     : spbry
--%>

<%@page import="db.Movement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Home</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <style>
            
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <% if (sessionUserEmail != null && sessionUserVerified == true) { %>
        <div class="container mt-5">
            
                <div class="table-responsive">
                        <table class="table table-striped" id="table-movements">
                            <thead class="bg-light">
                                <tr>
                                    <th>Tabelas</th>
                                    <th>Lucro</th>
                                    <th>Gasto</th>
                                    <th>Saídas</th>
                                    <th>Entradas</th>
                                    <th>Operador(Saída)</th>
                                    <th>Fornecedor(Saída)</th>
                                    <th>Produto/Vendido</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>7</th>
                                    <th>R$18.000</th>
                                    <th>R$5.000</th>
                                    <th><%=Movement.getOuts()%></th>
                                    <th><%=Movement.getIns()%></th>
                                    <th><%=Movement.getFrequentUser()%></th>
                                    <th><%=Movement.getFrequentProv()%></th>
                                    <th><%=Movement.getFrequentProd()%></th>
            
        </div>
        <%}%>
    </body>
</html>

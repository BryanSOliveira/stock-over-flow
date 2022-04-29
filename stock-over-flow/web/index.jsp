<%-- 
    Document   : index
    Created on : 12 de fev. de 2022, 12:43:57
    Author     : spbry
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Home</title>
        <link rel="icon" type="image/x-icon" href="images/favicon.png">
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
                                    <th>Saidas</th>
                                    <th>Entradas</th>
                                    <th>Operador/Mes</th>
                                    <th>Fornecedor/Mes</th>
                                    <th>Produto/Vendido</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>7</th>
                                    <th>R$18.000</th>
                                    <th>R$5.000</th>
                                    <th>402</th>
                                    <th>587</th>
                                    <th>Thaina</th>
                                    <th>MindF</th>
                                    <th>Blusa</th>
            
        </div>
        <%}%>
    </body>
</html>

<%-- 
    Document   : my-profile
    Created on : 2 de mar. de 2022, 17:56:21
    Author     : spbry
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Meu perfil</title>
        <link rel="icon" type="image/x-icon" href="images/favicon.png">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null) { %>
            <div class="card">
                <div class="card-body">
                    <h2>Meu perfil</h2>
                </div>
                <div class="alert alert-warning" role="alert">
                    <i class="bi bi-exclamation-triangle"></i> Em obras!
                </div>
            </div>
            <% }%>
        </div>
    </body>
</html>

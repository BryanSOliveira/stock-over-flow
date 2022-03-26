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
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <% if (sessionUserEmail != null) { %>
        <div class="container mt-5">
            <h1 class="text-center">
                <img src="https://pbs.twimg.com/media/DlDgB8BU4AAXoGq.jpg"/>
            </h1>
        </div>
        <%}%>
    </body>
</html>

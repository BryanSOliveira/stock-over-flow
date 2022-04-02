<%-- 
    Document   : my-profile
    Created on : 2 de mar. de 2022, 17:56:21
    Author     : spbry
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    try {
        if (request.getParameter("changePassword") != null) {
            String login = (String) session.getAttribute("loggedUser.userEmail");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");
            if (User.getUser(login, currentPassword) == null) {
                requestError = "Senha atual inválida!";
            } else if (!newPassword.equals(confirmNewPassword)) {
                requestError = "Confirmação de nova senha inválida!";
            } else {
                User.changePassword(login, newPassword);
                response.sendRedirect(request.getRequestURI());
            }
        }
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
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
            <% if (requestError != null) {%>
            <div class="alert alert-danger" role="alert">
                <%= requestError%>
            </div>
            <% } %>
            <% if (sessionUserEmail != null && sessionUserVerified == true) {%>
            <div class="card">
                <div class="card-body">
                    <h2>Meu perfil</h2>
                </div>
                <div class="container-fluid">
                    <form class="row g-3">
                        <div class="col-md-4">
                            <label for="name" class="form-label">Name</label>
                            <input type="text" class="form-control" id="name" value="<%= sessionUserName%>" readonly>
                        </div>
                        <div class="col-md-4">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" value="<%= sessionUserEmail%>" readonly>
                        </div>
                        <div class="col-md-4">
                            <label for="role" class="form-label">Função</label>
                            <selected id="role" class="form-select">
                                <option selected><%= sessionUserRole%></option>
                            </selected>
                        </div>
                    </form>
                    <h3 class="mt-4">Alterar senha</h3>
                    <form class="row g-3" method="post">
                        <div class="col-md-4">
                            <label for="senhaAtual" class="form-label">Senha atual</label>
                            <input type="password" class="form-control" name="currentPassword" id="senhaAtual">
                        </div>
                        <div class="col-md-4">
                            <label for="novaSenha" class="form-label">Nova senha</label>
                            <input type="password" class="form-control" name="newPassword" id="novaSenha">
                        </div>
                        <div class="col-md-4">
                            <label for="ConfirmarNovaSenha" class="form-label">Confirmação da nova senha</label>
                            <input type="password" class="form-control" name="confirmNewPassword" id="ConfirmarNovaSenha">
                        </div>
                        <div class="col-md-12 mb-2">
                            <button type="submit" name="changePassword" class="btn btn-lg btn-primary">Confirmar</button>
                        </div>
                    </form>
                </div>
            </div>
            <% }%>
        </div>
    </body>
</html>

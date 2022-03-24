<%-- 
    Document   : users
    Created on : 25 de fev. de 2022, 22:25:44
    Author     : spbry
--%>
<%@page import="db.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<User> users = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String userEmail = request.getParameter("targetUserEmail");
            String userName = request.getParameter("targetUserName");
            String userRole = request.getParameter("targetUserRole");
            String userPassword = request.getParameter("targetUserPassword");
            Boolean userVerified = Boolean.parseBoolean(request.getParameter("targetUserVerified"));
            User.insertUser(userEmail, userName, userRole, userPassword, userVerified);
            response.sendRedirect(request.getRequestURI());
            //response.sendRedirect("VerifyUser");
        } else if (request.getParameter("delete") != null) {
            String userEmail = request.getParameter("targetUserEmail");
            User.deleteUser(userEmail);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            String userEmail = request.getParameter("targetUserEmail");
            String userName = request.getParameter("targetUserName");
            String userRole = request.getParameter("targetUserRole");
            String userPassword = request.getParameter("targetUserPassword");
            Boolean userVerified = Boolean.parseBoolean(request.getParameter("targetUserVerified"));
            User.alterUser(userEmail, userName, userRole, userPassword, userVerified);
            response.sendRedirect(request.getRequestURI());
        }
        users = User.getUsers();
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Conten<t-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Usuários</title>
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null) { %>
            <div class="card">
                <div class="card-body">
                    <% if (sessionUserRole.equals("admin")) {%>
                    <h2>Usuários(<%= users.size()%>)
                        <!-- Button add user -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-person-plus"></i>
                        </button>
                    </h2>
                    <!-- Modal add user -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="targetUserEmail">Email</label>
                                            <input type="text" class="form-control" name="targetUserEmail" id="targetUserEmail"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="targetUserName">Nome</label>
                                            <input type="text" class="form-control" name="targetUserName" id="targetUserName"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="targetUserRole">Permissão</label>
                                            <select name="targetUserRole" class="form-select" id="tagetUserRole">
                                                <option value="admin">admin</option>
                                                <option value="user" selected>user</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="targetUserPassword">Senha</label>
                                            <input type="password" class="form-control" name="targetUserPassword" id="targetUserPassword" autocomplete="on"/>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Salvar" class="btn btn-primary">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% if (requestError != null) {%>
                    <div class="alert alert-danger" role="alert">
                        <%= requestError%>
                    </div>
                    <% } %>
                    <!-- Table user -->
                    <div class="table-responsive">
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>Email</th>
                                    <th>Nome</th>
                                    <th>Permissão</th>
                                    <th>Verificado</th>
                                    <th>Opções</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (User user : users) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= user.getUserEmail()%></td>
                                    <td><%= user.getUserName()%></td>
                                    <td><%= user.getUserRole()%></td>
                                    <td><%= user.getUserVerified()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="targetUserEmail" value="<%= user.getUserEmail()%>"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                        <!-- Modal edit -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label for="targetUserEmail-<%= i%>">Email</label>
                                                                <input type="text" class="form-control" name="targetUserEmail" id="targetUserEmail-<%= i%>" 
                                                                       value="<%= user.getUserEmail()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="targetUserName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="targetUserName" id="targetUserName-<%= i%>" 
                                                                       value="<%= user.getUserName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="targetUserRole-<%= i%>">Permissão</label>
                                                                <select name="targetUserRole" class="form-select" id="targetUserRole-<%= i%>">
                                                                    <% if (user.getUserRole().equals("admin")) { %>
                                                                    <option value="admin" selected>admin</option>
                                                                    <option value="user">user</option>
                                                                    <% } else { %>
                                                                    <option value="admin">admin</option>
                                                                    <option value="user" selected>user</option>
                                                                    <% }%>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="targetUserPassword-<%= i%>">Senha</label>
                                                                <input type="password" class="form-control" name="targetUserPassword" id="targetUserPassword-<%= i%>" autocomplete="on"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="targetUserVerified-<%= i%>">Verificação</label>
                                                                <select name="targetUserVerified" class="form-select" id="targetUserVerified-<%= i%>">
                                                                   <% if (user.getUserVerified().equals("true")) { %>
                                                                   <option value="true" selected>Verificado</option>
                                                                   <option value="false">Não Verificado</option>
                                                                   <% } else { %>
                                                                   <option value="true">Verificado</option>
                                                                   <option value="false" selected>Não Verificado</option>
                                                                   <% }%>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="targetUserEmail" value="<%= user.getUserEmail()%>"/>
                                                            <input type="submit" name="edit" value="Salvar" class="btn btn-primary">
                                                        </div>
                                                        
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% } else { %>
            Página restrita
            <% } %>
            <% }%>
        </div>
    </body>
</html>
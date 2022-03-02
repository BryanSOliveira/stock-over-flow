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
            String login = request.getParameter("login");
            String name = request.getParameter("name");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            User.insertUser(login, name, role, password);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            String login = request.getParameter("login");
            User.deleteUser(login);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            String login = request.getParameter("login");
            String name = request.getParameter("name");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            User.alterUser(login, name, role, password);
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Usuários</title>
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUsername != null) { %>
            <div class="card">
                <div class="card-body">
                    <% if (sessionRole.equals("admin")) {%>
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
                                            <label for="login">Login</label>
                                            <input type="text" class="form-control" name="login" id="login"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="name">Nome</label>
                                            <input type="text" class="form-control" name="name" id="name"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="role">Papel</label>
                                            <select name="role" class="form-select" id="role">
                                                <option value="admin">admin</option>
                                                <option value="user" selected>user</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label for="password">Senha</label>
                                            <input type="password" class="form-control" name="password" id="password" autocomplete="on"/>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <input type="submit" name="insert" value="Save" class="btn btn-primary">
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
                                    <th>Login</th>
                                    <th>Name</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (User user : users) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= user.getLogin()%></td>
                                    <td><%= user.getName()%></td>
                                    <td><%= user.getRole()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="login" value="<%= user.getLogin()%>"/>
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
                                                                <label for="login-<%= i%>">Login</label>
                                                                <input type="text" class="form-control" name="login" id="login-<%= i%>" 
                                                                       value="<%= user.getLogin()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="name-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="name" id="name-<%= i%>" 
                                                                       value="<%= user.getName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="role-<%= i%>">Papel</label>
                                                                <select name="role" class="form-select" id="role-<%= i%>">
                                                                    <% if (user.getRole().equals("admin")) { %>
                                                                    <option value="admin" selected>admin</option>
                                                                    <option value="user">user</option>
                                                                    <% } else { %>
                                                                    <option value="admin">admin</option>
                                                                    <option value="user" selected>user</option>
                                                                    <% }%>
                                                                </select>
                                                            </div>
                                                            <div>
                                                                <label for="password-<%= i%>">Senha</label>
                                                                <input type="password" class="form-control" name="password" id="password-<%= i%>" autocomplete="on"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="login" value="<%= user.getLogin()%>"/>
                                                            <input type="submit" name="edit" value="Save" class="btn btn-primary">
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
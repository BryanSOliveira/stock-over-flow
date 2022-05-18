<%-- 
    Document   : users
    Created on : 25 de fev. de 2022, 22:25:44
    Author     : spbry
--%>
<%@page import="mail.SendEmail"%>
<%@page import="db.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

    String requestError = null;
    ArrayList<User> users = new ArrayList<>();
    try {
    
        //ADD USER
        if (request.getParameter("insert") != null) {
            final HttpServletRequest a = request;
            
            new Thread(new Runnable() {
            public void run() {
            String userEmail = a.getParameter("targetUserEmail");
            String userName = a.getParameter("targetUserName");
            String userRole = a.getParameter("targetUserRole");
            String userPassword = a.getParameter("targetUserPassword");
            Boolean userVerified = Boolean.parseBoolean(a.getParameter("targetUserVerified"));
            SendEmail mailInstance = new SendEmail();
            String userToken = mailInstance.genToken();
            try{
            User.insertUser(userEmail, userName, userRole, userPassword, userVerified, userToken);
            User verifyUser = new User(userEmail, userName, userRole, userVerified, userToken);
            boolean emailSent = mailInstance.sendEmail(verifyUser);
            } catch (Exception ex) {
            //throw new Exception (ex.getMessage());
            System.out.println(ex.getMessage());
            }
                
            }
            }).start();
            
            response.sendRedirect(request.getRequestURI());
        
        //EDIT USER
        } else if (request.getParameter("edit") != null) {
            String userEmail = request.getParameter("targetUserEmail");
            String userName = request.getParameter("targetUserName");
            String userRole = request.getParameter("targetUserRole");
            String userPassword = request.getParameter("targetUserPassword");
            User.alterUser(userEmail, userName, userRole, userPassword);
            response.sendRedirect(request.getRequestURI());
         
        //DELETE USER
        } else if (request.getParameter("delete") != null) {
            String userEmail = request.getParameter("targetUserEmail");
            User.deleteUser(userEmail);
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
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null && sessionUserVerified == true) { %>
            <div class="card">
                <div class="card-body">
                    <% if (sessionUserRole.equals("Admin")) {%>
                    <h2>Usuários (<%= users.size()%>)
                        <!-- BUTTON ADD USER -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-person-plus"></i>
                        </button>
                    </h2>
                    <!-- ADD USER SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <!-- USER EMAIL -->
                                        <div class="mb-3">
                                            <label for="targetUserEmail">Email</label>
                                            <input type="email" class="form-control" name="targetUserEmail" id="targetUserEmail" required/>
                                        </div>
                                        <!-- USER NAME -->
                                        <div class="mb-3">
                                            <label for="targetUserName">Nome</label>
                                            <input type="text" class="form-control" name="targetUserName" id="targetUserName" required/>
                                        </div>
                                        <!-- USER ROLE -->
                                        <div class="mb-3">
                                            <label for="targetUserRole">Permissão</label>
                                            <select name="targetUserRole" class="form-select" id="tagetUserRole">
                                                <option value="Admin">Admin</option>
                                                <option value="Usuario" selected>Usuario</option>
                                            </select>
                                        </div>
                                        <!-- USER PASSWORD -->
                                        <div class="mb-3">
                                            <label for="targetUserPassword">Senha</label>
                                            <input type="password" class="form-control" name="targetUserPassword" id="targetUserPassword" autocomplete="on" required/>
                                        </div>
                                    </div>
                                    <!-- USER SAVE AND CANCEL BUTTON -->
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Salvar" class="btn btn-primary">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- SHOW ERROR CODE -->
                    <% if (requestError != null) {%>
                    <div class="alert alert-danger" role="alert">
                        <%= requestError%>
                    </div>
                    <% } %>
                    <!-- USER MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped" id="table-user">
                            <thead class="bg-light">
                                <tr>
                                    <th>Email</th>
                                    <th>Nome</th>
                                    <th>Permissão</th>
                                    <th>Status</th>
                                    <th>Token</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; 
                                   for (User user : users) { 
                                   i++;%>
                                <tr>
                                    <td><%= user.getUserEmail()%></td>
                                    <td><%= user.getUserName()%></td>
                                    <td><%= user.getUserRole()%></td>
                                    <td><% if (user.getUserVerified() == true) {%> Ativada <% } else {%> Pendente <% }%></td>
                                    <td><%= user.getUserToken()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- BUTTON EDIT USER -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i></button>
                                            <input type="hidden" name="targetUserEmail" value="<%= user.getUserEmail()%>"/>
                                            <!-- BUTTON DELETE USER -->
                                            <%if(user.getUserEmail().equals(session.getAttribute("loggedUser.userEmail"))){}else{%>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i></button><%}%>
                                        </form>
                                        <!-- EDIT USER SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form>
                                                        <div class="modal-body">
                                                            <!-- USER EMAIL -->
                                                            <div class="mb-3">
                                                                <label for="targetUserEmail-<%= i%>">Email</label>
                                                                <input type="text" class="form-control" name="targetUserEmail" id="targetUserEmail-<%= i%>" 
                                                                       value="<%= user.getUserEmail()%>" disabled/>
                                                            </div>
                                                            <!-- USER NAME -->
                                                            <div class="mb-3">
                                                                <label for="targetUserName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="targetUserName" id="targetUserName-<%= i%>" 
                                                                       value="<%= user.getUserName()%>"/>
                                                            </div>
                                                            <!-- USER ROLE -->
                                                            <div class="mb-3">
                                                                <label for="targetUserRole-<%= i%>">Permissão</label>
                                                                <select name="targetUserRole" class="form-select" id="targetUserRole-<%= i%>">
                                                                    <% if (user.getUserRole().equals("Admin")) { %>
                                                                    <option value="Admin" selected>Admin</option>
                                                                    <option value="Usuario">Usuario</option>
                                                                    <% } else { %>
                                                                    <option value="Admin">Admin</option>
                                                                    <option value="Usuario" selected>Usuario</option>
                                                                    <% }%>
                                                                </select>
                                                            </div>
                                                            <!-- USER PASSWORD -->
                                                            <div class="mb-3">
                                                                <label for="targetUserPassword-<%= i%>">Senha</label>
                                                                <input type="password" class="form-control" name="targetUserPassword" id="targetUserPassword-<%= i%>" autocomplete="on"/>
                                                            </div>
                                                            <!-- USER VERIFIED -->
                                                            <div class="mb-3">
                                                                <label for="targetUserVerified-<%= i%>">Status</label>
                                                                <% if (user.getUserVerified() == true) {%>
                                                                <input type="text" class="form-control" name="targetUserVerified" id="targetUserVerified-<%= i%>" 
                                                                       value="Ativada" disabled/>
                                                                <% } else {%>
                                                                <input type="text" class="form-control" name="targetUserVerified" id="targetUserVerified-<%= i%>" 
                                                                       value="Pendente" disabled/>
                                                                <% }%>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <!-- USER SAVE AND CANCEL BUTTON -->   
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
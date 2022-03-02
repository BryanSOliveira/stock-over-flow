<%-- 
    Document   : providers
    Created on : 2 de mar. de 2022, 19:05:37
    Author     : spbry
--%>

<%@page import="db.Provider"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Provider> providers = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            Provider.insertProvider(name, address, telephone);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            Provider.deleteProvider(id);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            Provider.alterProvider(id, name, address, telephone);
            response.sendRedirect(request.getRequestURI());
        }
        providers = Provider.getProviders();
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Fornecedores</title>
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUsername != null) { %>
            <div class="card">
                <div class="card-body">
                    <h2>Fornecedores
                        <!-- Button add providers -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                    </h2>
                    <!-- Modal add provider -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="name">Nome</label>
                                            <input type="text" class="form-control" name="name" id="name"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="address">Endereço</label>
                                            <input type="text" class="form-control" name="address" id="address"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="telephone">Telefone</label>
                                            <input type="text" class="form-control" name="telephone" id="telephone"/>
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
                    <!-- Table provider -->
                    <div class="table-responsive">
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Address</th>
                                    <th>Telephone</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Provider provider : providers) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= provider.getId()%></td>
                                    <td><%= provider.getName()%></td>
                                    <td><%= provider.getAddress()%></td>
                                    <td><%= provider.getTelephone()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="id" value="<%= provider.getId()%>"/>
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
                                                                <label for="id-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="id" id="id-<%= i%>" 
                                                                       value="<%= provider.getId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="name-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="name" id="name-<%= i%>" 
                                                                       value="<%= provider.getName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="address-<%= i%>">Endereço</label>
                                                                <input type="text" class="form-control" name="address" id="address-<%= i%>" 
                                                                       value="<%= provider.getAddress()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="telephone-<%= i%>">Telefone</label>
                                                                <input type="text" class="form-control" name="telephone" id="telephone-<%= i%>" 
                                                                       value="<%= provider.getTelephone()%>"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="id" value="<%= provider.getId()%>"/>
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
            <% } %>
        </div>
    </body>
</html>

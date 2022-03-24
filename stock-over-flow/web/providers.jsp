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
            String provName = request.getParameter("provName");
            String provLocation = request.getParameter("provLocation");
            String provTelephone = request.getParameter("provTelephone");
            String provMail = request.getParameter("provMail");
            Provider.insertProvider(provName, provLocation, provTelephone, provMail);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            int provId = Integer.parseInt(request.getParameter("provId"));
            Provider.deleteProvider(provId);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            int provId = Integer.parseInt(request.getParameter("provId"));
            String provName = request.getParameter("provName");
            String provLocation = request.getParameter("provLocation");
            String provTelephone = request.getParameter("provTelephone");
            String provMail = request.getParameter("provMail");
            Provider.alterProvider(provId, provName, provLocation, provTelephone, provMail);
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
            <% if (sessionUserEmail != null) { %>
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
                                            <label for="provName">Nome</label>
                                            <input type="text" class="form-control" name="provName" id="provName"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="provLocation">Endereço</label>
                                            <input type="text" class="form-control" name="provLocation" id="provLocation"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="provTelephone">Telefone</label>
                                            <input type="text" class="form-control" name="provTelephone" id="provTelephone"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="provMail">E-mail</label>
                                            <input type="text" class="form-control" name="provMail" id="provMail"/>
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
                    <!-- Table provider -->
                    <div class="table-responsive">
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>Endereço</th>
                                    <th>Telefone</th>
                                    <th>Email</th>
                                    <th>Produtos (Estoque)</th>
                                    <th>Opções</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Provider provider : providers) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= provider.getProvId()%></td>
                                    <td><%= provider.getProvName()%></td>
                                    <td><%= provider.getProvLocation()%></td>
                                    <td><%= provider.getProvTelephone()%></td>
                                    <td><%= provider.getProvMail()%></td>
                                    <td><%= Provider.getProvQntById(provider.getProvId())%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="provId" value="<%= provider.getProvId()%>"/>
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
                                                                <label for="provId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="provId" id="provId-<%= i%>" 
                                                                       value="<%= provider.getProvId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="provName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="provName" id="provName-<%= i%>" 
                                                                       value="<%= provider.getProvName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="provLocation-<%= i%>">Endereço</label>
                                                                <input type="text" class="form-control" name="provLocation" id="provLocation-<%= i%>" 
                                                                       value="<%= provider.getProvLocation()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="provTelephone-<%= i%>">Telefone</label>
                                                                <input type="text" class="form-control" name="provTelephone" id="provTelephone-<%= i%>" 
                                                                       value="<%= provider.getProvTelephone()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="provMail-<%= i%>">E-mail</label>
                                                                <input type="text" class="form-control" name="provMail" id="provMail-<%= i%>" 
                                                                       value="<%= provider.getProvMail()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="provQnt-<%= i%>">Produto (Estoque)</label>
                                                                <input type="text" class="form-control" name="provQnt" id="provQnt-<%= i%>" 
                                                                       value="<%= Provider.getProvQntById(provider.getProvId())%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="provId" value="<%= provider.getProvId()%>"/>
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
            <% } %>
        </div>
    </body>
</html>

<%-- 
    Document   : brands
    Created on : 2 de mar. de 2022, 17:51:42
    Author     : spbry
--%>

<%@page import="db.Brand"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Brand> brands = new ArrayList<>();
    try {
        //ADD BRAND
        if (request.getParameter("insert") != null) {
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Brand.insertBrand(brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT BRAND    
        } else if (request.getParameter("edit") != null) {
            String oldBrandName = request.getParameter("oldBrandName");
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Brand.alterBrand(oldBrandName, brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
            
        //DELETE BRAND
        } else if (request.getParameter("delete") != null) {
            String brandName = request.getParameter("brandName");
            Brand.deleteBrand(brandName);
            response.sendRedirect(request.getRequestURI());
        }    
        
        brands = Brand.getBrands();
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Marcas</title>
        <link rel="icon" type="image/x-icon" href="images/Stock2Flow.svg">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null && sessionUserVerified == true) {%>
            <div class="card">
                <div class="card-body">
                    <h2>Marcas (<%= brands.size()%>)
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON ADD BRAND -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
                    </h2>
                    <!-- ADD BRAND SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <!-- BRAND NAME -->
                                        <div class="mb-3">
                                            <label for="name">Nome</label>
                                            <input type="text" class="form-control" name="brandName" id="brandName" required/>
                                        </div>
                                        <!-- BRAND DESCRIPTION -->
                                        <div class="mb-3">
                                            <label for="name">Descrição</label>
                                            <input type="text" class="form-control" name="brandDesc" id="brandDesc"/>
                                        </div>
                                    </div>
                                    <!-- BRAND SAVE AND CANCEL BUTTON -->
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
                    <!-- BRAND MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead class="bg-light">
                                <tr>
                                    <th>Nome</th>
                                    <th>Descrição</th>
                                    <% if (sessionUserRole.equals("Admin")) {%><th></th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; 
                                   for (Brand brand : brands) { 
                                   i++; %>
                                <tr>
                                    <td><%= brand.getBrandName()%></td>
                                    <td><%= brand.getBrandDesc()%></td>
                                    <% if (sessionUserRole.equals("Admin")) {%>
                                    <td>
                                        <form method="post">
                                            <!-- BUTTON EDIT BRAND -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="brandName" value="<%= brand.getBrandName()%>"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                        <!-- EDIT BRAND SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form>
                                                        <div class="modal-body">
                                                            <!-- BRAND NAME -->
                                                            <div class="mb-3">
                                                                <label for="brandName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="brandName" id="brandName-<%= i%>" 
                                                                       value="<%= brand.getBrandName()%>"/>
                                                            </div>
                                                            <!-- BRAND DESCRIPTION -->
                                                            <div class="mb-3">
                                                                <label for="brandDesc-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="brandDesc" id="brandDesc-<%= i%>" 
                                                                       value="<%= brand.getBrandDesc()%>"/>
                                                            </div>
                                                        </div>
                                                        <!-- BRAND SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="oldBrandName" value="<%= brand.getBrandName()%>"/>
                                                            <input type="submit" name="edit" value="Salvar" class="btn btn-primary">
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% }%>
        </div>
        
    </body>
</html>

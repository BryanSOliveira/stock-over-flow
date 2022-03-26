<%-- 
    Document   : brands
    Created on : 2 de mar. de 2022, 17:51:42
    Author     : spbry
--%>

<%@page import="db.Marca"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Marca> brands = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Marca.insertBrand(brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            Marca.deleteBrand(brandId);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            String brandName = request.getParameter("brandName");
            String brandDesc = request.getParameter("brandDesc");
            Marca.alterBrand(brandId, brandName, brandDesc);
            response.sendRedirect(request.getRequestURI());
        }
        brands = Marca.getBrands();
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
        <link rel="icon" type="image/x-icon" href="images/favicon.png">
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
        <%@include file="WEB-INF/jspf/jquery-header.jspf" %>
        <%@include file="WEB-INF/jspf/datatable-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUserEmail != null) {%>
            <div class="card">
                <div class="card-body">
                    <h2>Marcas (<%= brands.size()%>)
                        <!-- Button add brand -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                    </h2>
                    <!-- Modal add user -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="name">Nome</label>
                                            <input type="text" class="form-control" name="brandName" id="brandName"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="name">Descrição</label>
                                            <input type="text" class="form-control" name="brandDesc" id="brandDesc"/>
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
                    <!-- Table brand -->
                    <div class="table-responsive">
                        <table class="table table-striped" id="table-brands">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>Descrição</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Marca brand : brands) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= brand.getBrandId()%></td>
                                    <td><%= brand.getBrandName()%></td>
                                    <td><%= brand.getBrandDesc()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="brandId" value="<%= brand.getBrandId()%>"/>
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
                                                                <label for="brandId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="brandId" id="brandId-<%= i%>" 
                                                                       value="<%= brand.getBrandId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="brandName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="brandName" id="brandName-<%= i%>" 
                                                                       value="<%= brand.getBrandName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="brandDesc-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="brandDesc" id="brandDesc-<%= i%>" 
                                                                       value="<%= brand.getBrandDesc()%>"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="brandId" value="<%= brand.getBrandId()%>"/>
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
            <% }%>
        </div>
        <script>
            $(document).ready(function () {
                $('#table-brands').DataTable({
                    "language": {
                        "lengthMenu": "Mostrando _MENU_ registros por página",
                        "zeroRecords": "Nada encontrado",
                        "info": "Mostrando página _PAGE_ de _PAGES_",
                        "infoEmpty": "Nenhum registro disponível",
                        "infoFiltered": "(filtrado de _MAX_ registros no total)"
                    }
                });
            });
        </script>
    </body>
</html>

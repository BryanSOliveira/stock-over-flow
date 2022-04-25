<%-- 
    Document   : products
    Created on : 2 de mar. de 2022, 19:54:10
    Author     : spbry
--%>

<%@page import="db.Brand"%>
<%@page import="db.Movement"%>
<%@page import="db.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Product> products = new ArrayList<>();
    try {
        //ADD PRODUCT
        if (request.getParameter("insert") != null) {
            String prodName = request.getParameter("prodName");
            String prodBrand = request.getParameter("prodBrand");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Product.insertProd(prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT PRODUCT
        } else if (request.getParameter("edit") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            String prodName = request.getParameter("prodName");
            String prodBrand = request.getParameter("prodBrand");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Product.alterProd(prodId, prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
            
        //DELETE PRODUCT
        } else if (request.getParameter("delete") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            Product.deleteProd(prodId);
            response.sendRedirect(request.getRequestURI());
        }
        
        products = Product.getProds();
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Produtos</title>
        <link rel="icon" type="image/x-icon" href="images/favicon.png">
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
                    <h2>Produtos (<%= products.size()%>)
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON ADD PRODUCT -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
                    </h2>
                    <!-- ADD PRODUCT SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <!-- PRODUCT NAME -->
                                        <div class="mb-3">
                                            <label for="prodName">Nome</label>
                                            <input type="text" class="form-control" name="prodName" id="prodName" required/>
                                        </div>
                                        <!-- PRODUCT BRAND -->
                                        <div class="mb-3">
                                            <label for="prodBrand">Marca</label>
                                            <select class="form-control" name="prodBrand" id="prodBrand">
                                                <%  ArrayList<String> brandNames = Brand.getBrandNames();
                                                    for (int j = 0; j < brandNames.size(); j++) {%>
                                                <option value="<%=brandNames.get(j)%>"><%=brandNames.get(j)%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <!-- PRODUCT MATERIAL -->
                                        <div class="mb-3">
                                            <label for="prodMaterial">Material</label>
                                            <input type="text" class="form-control" name="prodMaterial" id="prodMaterial"/>
                                        </div>
                                        <!-- PRODUCT SIZE -->
                                        <div class="mb-3">
                                            <label for="prodSize">Tamanho</label>
                                            <input type="text" class="form-control" name="prodSize" id="prodSize"/>
                                        </div>
                                    </div>
                                    <!-- PRODUCT SAVE AND CANCEL BUTTON -->
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Adicionar" class="btn btn-primary">
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
                    <!-- PRODUCT MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped" id="table-products">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>Marca</th>
                                    <th>Material</th>
                                    <th>Tamanho</th>
                                    <th>Valor Médio</th>
                                    <th>Quantidade</th>
                                    <% if (sessionUserRole.equals("Admin")) {%><th></th><% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0;
                                   for (Product product : products) {
                                   i++; %>
                                <tr>
                                    <td><%= product.getProdId()%></td>
                                    <td><%= product.getProdName()%></td>     
                                    <td><%= product.getProdBrand()%></td>
                                    <td><%= product.getProdMaterial()%></td>
                                    <td><%= product.getProdSize()%></td>
                                    <td><%= Movement.getAvgById(product.getProdId())%></td>
                                    <td><%= Movement.getQntById(product.getProdId())%></td>
                                    <% if (sessionUserRole.equals("Admin")) {%>
                                    <td>
                                        <form method="post">
                                            <!-- BUTTON EDIT PRODUCT -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i></button>
                                            <input type="hidden" name="prodId" value="<%= product.getProdId()%>"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i></button>
                                        </form>
                                        <!-- EDIT PRODUCT SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form>
                                                        <div class="modal-body">
                                                            <!-- PRODUCT ID -->
                                                            <div class="mb-3">
                                                                <label for="prodId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="prodId" id="prodId-<%= i%>" 
                                                                       value="<%= product.getProdId()%>" disabled/>
                                                            </div>
                                                            <!-- PRODUCT NAME -->
                                                            <div class="mb-3">
                                                                <label for="prodName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="prodName" id="prodName-<%= i%>" 
                                                                       value="<%= product.getProdName()%>" required/>
                                                            </div>
                                                            <!-- PRODUCT BRAND -->
                                                            <div class="mb-3">
                                                                <label for="prodBrand-<%= i%>">Marca</label>
                                                                <select class="form-control" name="prodBrand" id="prodBrand-<%= i%>">
                                                                    <% ArrayList<String> brandNamesEdit = Brand.getBrandNames();
                                                                        for (int k = 0; k < brandNamesEdit.size(); k++) {
                                                                            if (brandNamesEdit.get(k).equals(product.getProdBrand())) {%>
                                                                                <option value="<%=brandNamesEdit.get(k)%>" selected><%=brandNamesEdit.get(k)%></option>
                                                                            <%} else {%>
                                                                                <option value="<%=brandNamesEdit.get(k)%>"><%=brandNamesEdit.get(k)%></option>
                                                                        <%}}%>
                                                                </select>
                                                            </div>
                                                            <!-- PRODUCT MATERIAL -->
                                                            <div class="mb-3">
                                                                <label for="prodMaterial-<%= i%>">Material</label>
                                                                <input type="text" class="form-control" name="prodMaterial" id="prodMaterial-<%= i%>" 
                                                                       value="<%= product.getProdMaterial()%>"/>
                                                            </div>
                                                            <!-- PRODUCT SIZE -->
                                                            <div class="mb-3">
                                                                <label for="prodSize-<%= i%>">Tamanho</label>
                                                                <input type="text" class="form-control" name="prodSize" id="prodSize-<%= i%>" 
                                                                       value="<%= product.getProdSize()%>"/>
                                                            </div>
                                                            <!-- PRODUCT AVG VALUE -->
                                                            <div class="mb-3">
                                                                <label for="prodAvgValue-<%= i%>">Valor Médio</label>
                                                                <input type="number" class="form-control" name="prodAvgValue" id="prodAvgValue-<%= i%>" 
                                                                       value="<%= Movement.getAvgById(product.getProdId())%>" disabled/>
                                                            </div>
                                                            <!-- PRODUCT QUANTITY -->
                                                            <div class="mb-3">
                                                                <label for="movQuantity-<%= i%>">Quantidade</label>
                                                                <input type="number" class="form-control" name="movQuantity" id="movQuantity-<%= i%>" 
                                                                       value="<%= Movement.getQntById(product.getProdId())%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <!-- PRODUCT SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="prodId" value="<%= product.getProdId()%>"/>
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
        <!-- SEARCH BAR -->
        <script>
            $(document).ready(function () {
                $('#table-products').DataTable({
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

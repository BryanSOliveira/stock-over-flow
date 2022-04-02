<%-- 
    Document   : products
    Created on : 2 de mar. de 2022, 19:54:10
    Author     : spbry
--%>

<%@page import="db.Marca"%>
<%@page import="db.Movement"%>
<%@page import="db.Produto"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Produto> products = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String prodName = request.getParameter("prodName");
            Integer prodBrand = Integer.parseInt(request.getParameter("prodBrand"));
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Produto.insertProd(prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            Produto.deleteProd(prodId);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            String prodName = request.getParameter("prodName");
            Integer prodBrand = Integer.parseInt(request.getParameter("prodBrand"));
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Produto.alterProd(prodId, prodName, prodBrand, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
        }
        products = Produto.getProdutos();
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
                        <% if (sessionUserRole.equals("admin")) {%>
                        <!-- Button add prod -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% } %>
                    </h2>
                    <!-- Modal add prod -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label for="prodName">Nome</label>
                                            <input type="text" class="form-control" name="prodName" id="prodName"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="prodBrand">Marca</label>
                                            <select class="form-control" name="prodBrand" id="prodBrand">
                                                <%
                                                    ArrayList<Integer> brandIds = Marca.getBrandIds();
                                                    for (int p = 0; p < brandIds.size(); p++) {%>
                                                <option value="<%=brandIds.get(p)%>"><%=Marca.getBrandNameById(brandIds.get(p))%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="prodMaterial">Material</label>
                                            <input type="text" class="form-control" name="prodMaterial" id="prodMaterial"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="prodSize">Tamanho</label>
                                            <input type="text" class="form-control" name="prodSize" id="prodSize"/>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                        <input type="submit" name="insert" value="Adicionar" class="btn btn-primary">
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
                    <!-- Table prod -->
                    <div class="table-responsive">
                        <table class="table table-striped" id="table-products">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>Marca</th>
                                    <th>Material</th>
                                    <th>Tamanho</th>
                                    <th>Quantidade</th>
                                        <% if (sessionUserRole.equals("admin")) {%>
                                    <th></th>
                                        <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0;
                                    for (Produto prod : products) {
                                        i++;
                                %>
                                <tr>
                                    <td><%= prod.getProdId()%></td>
                                    <td><%= prod.getProdName()%></td>     

                                    <td><%= Marca.getBrandNameById(prod.getProdBrand())%></td>

                                    <td><%= prod.getProdMaterial()%></td>
                                    <td><%= prod.getProdSize()%></td>
                                    <td><%= Movement.getQntById(prod.getProdId())%></td>
                                    <% if (sessionUserRole.equals("admin")) {%>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="prodId" value="<%= prod.getProdId()%>"/>
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
                                                                <label for="prodId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="prodId" id="prodId-<%= i%>" 
                                                                       value="<%= prod.getProdId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="prodName" id="prodName-<%= i%>" 
                                                                       value="<%= prod.getProdName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodBrand-<%= i%>">Marca</label>
                                                                <select class="form-control" name="prodBrand" id="prodBrand-<%= i%>">
                                                                    <% ArrayList<Integer> editBrandIds = Marca.getBrandIds();
                                                                        for (int f = 0; f < editBrandIds.size(); f++) {%>
                                                                    <% if (editBrandIds.get(f).equals(prod.getProdBrand())) {%>
                                                                    <option value="<%=editBrandIds.get(f)%>" selected><%=Marca.getBrandNameById(editBrandIds.get(f))%></option>
                                                                    <%} else {%>
                                                                    <option value="<%=editBrandIds.get(f)%>"><%=Marca.getBrandNameById(editBrandIds.get(f))%></option>
                                                                    <%}%>
                                                                    <%}%>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodMaterial-<%= i%>">Material</label>
                                                                <input type="text" class="form-control" name="prodMaterial" id="prodMaterial-<%= i%>" 
                                                                       value="<%= prod.getProdMaterial()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodSize-<%= i%>">Tamanho</label>
                                                                <input type="text" class="form-control" name="prodSize" id="prodSize-<%= i%>" 
                                                                       value="<%= prod.getProdSize()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movQuantity-<%= i%>">Quantidade</label>
                                                                <input type="number" class="form-control" name="movQuantity" id="movQuantity-<%= i%>" 
                                                                       value="<%= Movement.getQntById(prod.getProdId())%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="prodId" value="<%= prod.getProdId()%>"/>
                                                            <input type="submit" name="edit" value="Salvar" class="btn btn-primary">
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <% i++; %>
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

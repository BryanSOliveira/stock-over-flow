<%-- 
    Document   : products
    Created on : 2 de mar. de 2022, 19:54:10
    Author     : spbry
--%>

<%@page import="db.Movement"%>
<%@page import="db.Produto"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Produto> produtos = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String prodName = request.getParameter("prodName");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Produto.insertProd(prodName, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            Produto.deleteProd(prodId);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            Integer prodId = Integer.parseInt(request.getParameter("prodId"));
            String prodName = request.getParameter("prodName");
            String prodMaterial = request.getParameter("prodMaterial");
            String prodSize = request.getParameter("prodSize");
            Produto.alterProd(prodId, prodName, prodMaterial, prodSize);
            response.sendRedirect(request.getRequestURI());
        }
        produtos = Produto.getProdutos();
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
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUsername != null) { %>
            <div class="card">
                <div class="card-body">
                    <% if (sessionRole.equals("admin")) {%>
                    <h2>Produtos - <%= produtos.size()%>
                        <!-- Button add prod -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
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
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nome</th>
                                    <th>Material</th>
                                    <th>Tamanho</th>
                                    <th>Quantidade</th>
                                    <th>Opções</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Produto x : produtos) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= x.getProdId()%></td>
                                    <td><%= x.getProdName()%></td>
                                    <td><%= x.getProdMaterial()%></td>
                                    <td><%= x.getProdSize()%></td>
                                    <td><%= Movement.getQntById(x.getProdId())%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="prodId" value="<%= x.getProdId()%>"/>
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
                                                                       value="<%= x.getProdId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodName-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="prodName" id="prodName-<%= i%>" 
                                                                       value="<%= x.getProdName()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodMaterial-<%= i%>">Material</label>
                                                                <input type="text" class="form-control" name="prodMaterial" id="prodMaterial-<%= i%>" 
                                                                       value="<%= x.getProdMaterial()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodSize-<%= i%>">Tamanho</label>
                                                                <input type="text" class="form-control" name="prodSize" id="prodSize-<%= i%>" 
                                                                       value="<%= x.getProdSize()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movQuantity-<%= i%>">Quantidade</label>
                                                                <input type="number" class="form-control" name="movQuantity" id="movQuantity-<%= i%>" 
                                                                       value="<%= Movement.getQntById(x.getProdId())%>" disabled/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="prodId" value="<%= x.getProdId()%>"/>
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

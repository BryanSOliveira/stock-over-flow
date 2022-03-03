<%-- 
    Document   : products
    Created on : 2 de mar. de 2022, 19:54:10
    Author     : spbry
--%>

<%@page import="db.Produto"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Produto> prods = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            Integer id = Integer.parseInt(request.getParameter("prod_id"));
            String nm = request.getParameter("prod_nm");
            String mt = request.getParameter("prod_mt");
            String sz = request.getParameter("prod_sz");
            Produto.insertProd(id, nm, mt, sz);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            Integer id = Integer.parseInt(request.getParameter("prod_id"));
            Produto.deleteProd(id);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            Integer id = Integer.parseInt(request.getParameter("prod_id"));
            String nm = request.getParameter("prod_nm");
            String mt = request.getParameter("prod_mt");
            String sz = request.getParameter("prod_sz");
            Produto.alterProd(id, nm, mt, sz);
            response.sendRedirect(request.getRequestURI());
        }
        prods = Produto.getProds();
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
                    <h2>Produtos - <%= prods.size()%>
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
                                            <label for="id">ID</label>
                                            <input type="text" class="form-control" name="prod_id" id="prod_id"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="nm">Nome</label>
                                            <input type="text" class="form-control" name="prod_nm" id="prod_nm"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="mt">Material</label>
                                            <input type="text" class="form-control" name="prod_mt" id="prod_mt"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="sz">Tamanho</label>
                                            <input type="text" class="form-control" name="prod_sz" id="prod_sz"/>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <input type="submit" name="insert" value="Add" class="btn btn-primary">
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
                                    <th>Opções</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Produto prod : prods) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= prod.getProdId()%></td>
                                    <td><%= prod.getProdNm()%></td>
                                    <td><%= prod.getProdMt()%></td>
                                    <td><%= prod.getProdSz()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="id" value="<%= prod.getProdId()%>"/>
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
                                                                <label for="prodid-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="prod_id" id="prodid-<%= i%>" 
                                                                       value="<%= prod.getProdId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodnm-<%= i%>">Nome</label>
                                                                <input type="text" class="form-control" name="prod_nm" id="prodnm-<%= i%>" 
                                                                       value="<%= prod.getProdNm()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodmt-<%= i%>">Material</label>
                                                                <input type="text" class="form-control" name="prod_mt" id="prodmt-<%= i%>" 
                                                                       value="<%= prod.getProdMt()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodsz-<%= i%>">Tamanho</label>
                                                                <input type="text" class="form-control" name="prod_sz" id="prodsz-<%= i%>" 
                                                                       value="<%= prod.getProdSz()%>"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="id" value="<%= prod.getProdId()%>"/>
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

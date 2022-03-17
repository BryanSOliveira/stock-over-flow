<%-- 
    Document   : movements
    Created on : 2 de mar. de 2022, 19:53:47
    Author     : spbry
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="db.Movement"%>
<%@page import="db.Produto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Movement> movements = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String prodType = request.getParameter("prodType");
            int movQuantity = Integer.parseInt(request.getParameter("movQuantity"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDescription = request.getParameter("movDescription");
            Movement.insertMovement(prodType, movQuantity, movValue, movDescription);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            Movement.deleteMovement(movId);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            int movQuantity = Integer.parseInt(request.getParameter("movQuantity"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDescription = request.getParameter("movDescription");
            Movement.alterMovement(movId, movQuantity, movValue, movDescription);
            response.sendRedirect(request.getRequestURI());
        }
        movements = Movement.getMovements();
        
    } catch (Exception ex) {
        requestError = ex.getLocalizedMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Movimentações</title>
        <%@include file="WEB-INF/jspf/bootstrap-header.jspf" %>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/header.jspf" %>
        <div class="container-fluid mt-2">
            <% if (sessionUsername != null) { %>
            <div class="card">
                <div class="card-body">
                    <h2>Movimentações
                        <!-- Button add movements -->
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
                                            <label for="prodType">Tipo de Produto</label>
                                            <select name="prodType" id="prodType">
                                                <% 
                                                   ArrayList<String> prodNames = Produto.getProdNames();
                                                   for(int p = 0; p < prodNames.size(); p++){ %>
                                                <option value="prodType"><%=prodNames.get(p)%></option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="movQuantityt">Quantidade</label>
                                            <input type="number" class="form-control" name="movQuantity" id="movQuantity"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="movValue">Valor</label>
                                            <input type="number" step="0.1" class="form-control" name="movValue" id="movValue"/>
                                            <!--DROPDOWN DOS PRODUTOS EXISTENTES-->
                                        </div>
                                        <div class="mb-3">
                                            <!--BOTAO DE ENTREDA OU SAIDA-->
                                            <label for="movDescription">Descrição</label>
                                            <input type="text" class="form-control" name="movDescription" id="movDescription"/>
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
                    <!-- Table movements -->
                    <div class="table-responsive">
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Horário | Data</th>
                                    <th>Tipo de Movimentação</th>
                                    <th>Produto</th>
                                    <th>Quantidade</th>
                                    <th>Valor</th>
                                    <th>Descrição</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Movement x : movements) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= x.getMovId()%></td>
                                    <td><%= x.getMovDate()%></td>
                                    <td>||</td>
                                    <td><%= x.getMovProdType()%></td>
                                    <td><%= x.getMovQuantity()%></td>
                                    <td><%= x.getMovValue()%></td>
                                    <td><%= x.getMovDescription()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="id" value="<%= x.getMovId()%>"/>
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
                                                                <label for="movId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="movId" id="movId-<%= i%>" 
                                                                       value="<%= x.getMovId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movDate-<%= i%>">Horário | Data</label>
                                                                <input type="text" class="form-control" name="movDate" id="movDate-<%= i%>" 
                                                                       value="<%= x.getMovDate()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="prodType-<%= i%>">Produto</label>
                                                                <input type="text" class="form-control" name="prodType" id="prodType-<%= i%>" 
                                                                       value="<%=x.getMovProdType()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movType-<%= i%>">Tipo de Movimentação</label>
                                                                <input type="text" class="form-control" name="movType" id="movType-<%= i%>" 
                                                                       value="||"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movQuantity-<%= i%>">Quantidade</label>
                                                                <input type="number" class="form-control" name="movQuantity" id="movQuantity-<%= i%>" 
                                                                       value="<%= x.getMovQuantity()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movValue-<%= i%>">Valor</label>
                                                                <input type="number" step="0.01" class="form-control" name="movValue" id="movValue-<%= i%>" 
                                                                       value="<%= x.getMovValue()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movAvgValue-<%= i%>">Valor médio</label>
                                                                <input type="number" class="form-control" name="movAvgValue" id="movAvgValue-<%= i%>" 
                                                                       value="<%= x.getMovValue()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="movDescription-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="movDescription" id="movDescription-<%= i%>" 
                                                                       value="<%= x.getMovDescription()%>"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="movId" value="<%= x.getMovId()%>"/>
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
    </body>
</html>

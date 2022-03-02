<%-- 
    Document   : movements
    Created on : 2 de mar. de 2022, 19:53:47
    Author     : spbry
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="db.Movement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Movement> movements = new ArrayList<>();
    try {
        if (request.getParameter("insert") != null) {
            String date = request.getParameter("date");
            Double mediumValue = Double.parseDouble(request.getParameter("medium_value"));
            Double batchValue = Double.parseDouble(request.getParameter("batch_value"));
            String description = request.getParameter("description");
            Movement.insertMovement(date, mediumValue, batchValue, description);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("delete") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            Movement.deleteMovement(id);
            response.sendRedirect(request.getRequestURI());
        } else if (request.getParameter("edit") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String date = request.getParameter("date");
            Double mediumValue = Double.parseDouble(request.getParameter("medium_value"));
            Double batchValue = Double.parseDouble(request.getParameter("batch_value"));
            String description = request.getParameter("description");
            Movement.alterMovement(id, date, mediumValue, batchValue, description);
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
                                            <label for="date">Data</label>
                                            <input type="datetime-local" class="form-control" name="date" id="date"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="medium_value">Valor médio(produto)</label>
                                            <input type="number" step="0.01" class="form-control" name="medium_value" id="medium_value"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="batch_value">Valor lote(produto)</label>
                                            <input type="number" step="0.01" class="form-control" name="batch_value" id="batch_value"/>
                                        </div>
                                        <div class="mb-3">
                                            <label for="description">Descrição</label>
                                            <input type="text" class="form-control" name="description" id="description"/>
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
                    <!-- Table movements -->
                    <div class="table-responsive">
                        <table class="table table-striped w-auto">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Date</th>
                                    <th>Medium value</th>
                                    <th>Batch value</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; %>
                                <% for (Movement movement : movements) { %>
                                <% i++;%>
                                <tr>
                                    <td><%= movement.getId()%></td>
                                    <td><%= movement.getDate()%></td>
                                    <td><%= movement.getMediumValue()%></td>
                                    <td><%= movement.getBatchValue()%></td>
                                    <td><%= movement.getDescription()%></td>
                                    <td>
                                        <form method="post">
                                            <!-- Button edit modal -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <input type="hidden" name="id" value="<%= movement.getId()%>"/>
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
                                                                       value="<%= movement.getId()%>" disabled/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="date-<%= i%>">Data </label>
                                                                <input type="datetime-local" class="form-control" name="date" id="date-<%= i%>" 
                                                                       value="<%= movement.getDate()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="medium_value-<%= i%>">Valor médio(produto)</label>
                                                                <input type="number" step="0.01" class="form-control" name="medium_value" id="medium_value-<%= i%>" 
                                                                       value="<%= movement.getMediumValue()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="batch_value-<%= i%>">Valor lote(produto)</label>
                                                                <input type="number" step="0.01" class="form-control" name="batch_value" id="batch_value-<%= i%>" 
                                                                       value="<%= movement.getBatchValue()%>"/>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label for="description-<%= i%>">Descrição </label>
                                                                <input type="text" class="form-control" name="description" id="description-<%= i%>" 
                                                                       value="<%= movement.getDescription()%>"/>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                            <input type="hidden" name="id" value="<%= movement.getId()%>"/>
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
            <% }%>
        </div>
    </body>
</html>

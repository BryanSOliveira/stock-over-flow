<%-- 
    Document   : movements
    Created on : 2 de mar. de 2022, 19:53:47
    Author     : spbry
--%>

<%@page import="db.Provider"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="db.Movement"%>
<%@page import="db.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String requestError = null;
    ArrayList<Movement> movements = new ArrayList<>();
    try {
        //ADD MOVEMENT
        if (request.getParameter("insert") != null) {
            int movProd = Integer.parseInt(request.getParameter("movProd"));
            String movOp = (String) session.getAttribute("loggedUser.userName");
            String movProv = request.getParameter("movProv");
            String movType = request.getParameter("movType");
            int movQnt = Integer.parseInt(request.getParameter("movQnt"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDesc = request.getParameter("movDesc");
            
            if (movType.equals("Entrada")) movQnt = Math.abs(movQnt);
            else if (movType.equals("Saida")) movQnt = -movQnt;  
            
            Movement.insertMovement(movProd, movOp, movProv, movType, movQnt, movValue, movDesc);
            response.sendRedirect(request.getRequestURI());
            
        //EDIT MOVEMENT
        } else if (request.getParameter("edit") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            int movProd = Integer.parseInt(request.getParameter("movProd"));
            String movProv = request.getParameter("movProv");
            String movType = request.getParameter("movType");
            int movQnt = Integer.parseInt(request.getParameter("movQnt"));
            Double movValue = Double.parseDouble(request.getParameter("movValue"));
            String movDesc = request.getParameter("movDesc");
            if (movType.equals("Entrada")) movQnt = Math.abs(movQnt);
            else if (movType.equals("Saida")) movQnt = -movQnt; 
            
            Movement.alterMovement(movId, movProd, movProv, movType, movQnt, movValue, movDesc);
            response.sendRedirect(request.getRequestURI());
        
        //DELETE MOVEMENT
        } else if (request.getParameter("delete") != null) {
            int movId = Integer.parseInt(request.getParameter("movId"));
            Movement.deleteMovement(movId);
            response.sendRedirect(request.getRequestURI());
            
        //GENERATE REPORT
        } else if (request.getParameter("report") != null) {
            movements = Movement.getMovements();
            Movement.generateReport(movements, response);
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
                    <h2>Movimentações (<%= movements.size()%>)
                        <!-- BUTTON ADD MOVEMENTS -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                        <% if (sessionUserRole.equals("Admin")) {%>
                        <!-- BUTTON GENERATE REPORT -->
                        <form method="post" class="d-inline">
                            <button type="submit" name="report" class="btn btn-primary">
                                <i class="bi bi-filetype-pdf"></i>
                            </button>
                        </form>
                        <% } %>
                    </h2>
                    <!-- ADD MOVEMENT SCREEN -->
                    <div class="modal fade" id="add" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post">
                                    <div class="modal-body">
                                        <!-- MOVEMENT PRODUCT -->
                                        <div class="mb-3">
                                            <label for="movProd">Produto</label>
                                            <select class="form-control" name="movProd" id="movProd">
                                                <%
                                                    ArrayList<Integer> prodIds = Product.getProdIds();
                                                    if(prodIds.size() > 0){
                                                    for (int j = 0; j < prodIds.size(); j++) {%>
                                                <option value="<%=prodIds.get(j)%>"><%=Product.getProdNameById(prodIds.get(j))%></option>
                                                <%}}else{%>
                                                <option value="---" selected>Cadastre produtos na guia "Produtos"</option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT PROVIDER -->
                                        <div class="mb-3">
                                            <label for="movProv">Fornecedor</label>
                                            <select class="form-control" name="movProv" id="movProv">
                                                <%
                                                    ArrayList<String> provNames = Provider.getProvNames();
                                                    if(provNames.size() > 0){
                                                    for (int k = 0; k < provNames.size(); k++) {%>
                                                <option value="<%=provNames.get(k)%>"><%=provNames.get(k)%></option>
                                                <%}}else{%>
                                                <option value="---" selected>Cadastre fornecedores na guia "Fornecedores"</option>
                                                <%}%>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT TYPE -->
                                        <div class="mb-3">
                                            <label for="movType">Tipo de Movimentação</label>
                                            <select class="form-control" name="movType" id="movType">
                                                <option value="Saida">Saida</option>
                                                <option value="Entrada">Entrada</option>
                                            </select>
                                        </div>
                                        <!-- MOVEMENT QUANTITY -->
                                        <div class="mb-3">
                                            <label for="movQnt">Quantidade</label>
                                            <input type="number" min="0" class="form-control" name="movQnt" id="movQnt" required/>
                                        </div>
                                        <!-- MOVEMENT VALUE -->
                                        <div class="mb-3">
                                            <label for="movValue">Valor</label>
                                            <input type="number" step="0.1" min="0" class="form-control" name="movValue" id="movValue" required/>
                                        </div>
                                        <!-- MOVEMENT DESCRIPTION -->
                                        <div class="mb-3">
                                            <label for="movDesc">Descrição</label>
                                            <input type="text" class="form-control" name="movDesc" id="movDesc"/>
                                        </div>
                                    </div>
                                    <!-- MOVEMENT SAVE AND CANCEL BUTTON -->
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
                    <!-- MOVEMENT MAIN TABLE -->
                    <div class="table-responsive">
                        <table class="table table-striped" id="table-movements">
                            <thead class="bg-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Horário | Data</th>
                                    <th>Tipo de Movimentação</th>
                                    <th>Produto</th>
                                    <th>Operador</th>
                                    <th>Fornecedor</th>
                                    <th>Quantidade</th>
                                    <th>Valor</th>
                                    <th>Descrição</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int i = 0; 
                                   for (Movement movement : movements) { 
                                   i++; %>
                                <tr>
                                    <td><%= movement.getMovId()%></td>
                                    <td><%= movement.getMovDate()%></td>
                                    <td><%= movement.getMovType()%></td>
                                    <td><%= movement.getMovName()%></td>
                                    <td><%= movement.getMovOp()%></td>
                                    <td><%= movement.getMovProv()%></td>
                                    <%if (movement.getMovQnt() > 0) {%> <td style="color:green;"><%= movement.getMovQnt()%></td>
                                    <%}else if (movement.getMovQnt() < 0) {%> <td style="color:red;"><%= movement.getMovQnt()%></td>
                                    <%}else {%> <td style="color:blue;"><%= movement.getMovQnt()%></td><%}%>
                                    <td><%= movement.getMovValue()%></td>
                                    <td><%= movement.getMovDesc()%></td>
                                    <td>
                                        <form method="post">
                                        <!-- BUTTON EDIT MOVEMENT -->
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#edit-<%= i%>">
                                                <i class="bi bi-pencil-square"></i></button>
                                            <input type="hidden" name="movId" value="<%= movement.getMovId()%>"/>
                                            <button type="submit" name="delete" class="btn btn-danger btn-sm">
                                                <i class="bi bi-trash3"></i></button>
                                        </form>
                                        <!-- EDIT MOVEMENT SCREEN -->
                                        <div class="modal fade" id="edit-<%= i%>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <form>
                                                        <div class="modal-body">
                                                            <!-- MOVEMENT ID -->
                                                            <div class="mb-3">
                                                                <label for="movId-<%= i%>">ID</label>
                                                                <input type="text" class="form-control" name="movId" id="movId-<%= i%>" 
                                                                       value="<%= movement.getMovId()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT TIME/DATE -->
                                                            <div class="mb-3">
                                                                <label for="movDate-<%= i%>">Horário | Data</label>
                                                                <input type="text" class="form-control" name="movDate" id="movDate-<%= i%>" 
                                                                       value="<%= movement.getMovDate()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT PRODUCT -->
                                                            <div class="mb-3">
                                                                <label for="movProd-<%= i%>">Produto</label>
                                                                <select class="form-control" name="movProd" id="movProd-<%= i%>">
                                                                    <% ArrayList<Integer> prodIdsEdit = Product.getProdIds();
                                                                    if(prodIdsEdit.size() > 0){
                                                                        for (int l = 0; l < prodIdsEdit.size(); l++) {
                                                                            if (prodIdsEdit.get(l).equals(movement.getMovProd())) {%>
                                                                                <option value="<%=prodIdsEdit.get(l)%>" selected><%=Product.getProdNameById(prodIdsEdit.get(l))%></option>
                                                                            <% } else {%>
                                                                                <option value="<%=prodIdsEdit.get(l)%>"><%=Product.getProdNameById(prodIdsEdit.get(l))%></option>
                                                                    <%}}}%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT OPERATOR -->
                                                            <div class="mb-3">
                                                                <label for="movOp-<%= i%>">Operador</label>
                                                                <input type="text" class="form-control" name="movOp" id="movOp-<%= i%>" 
                                                                       value="<%= movement.getMovOp()%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT PROVIDER -->
                                                            <div class="mb-3">
                                                                <label for="movProv-<%= i%>">Fornecedor</label>
                                                                <select class="form-control" name="movProv" id="movProv-<%= i%>">
                                                                    <% ArrayList<String> provNamesEdit = Provider.getProvNames();
                                                                        for (int m = 0; m < provNamesEdit.size(); m++) {
                                                                            if (provNamesEdit.get(m).equals(movement.getMovProv())) {%>
                                                                                <option value="<%=provNamesEdit.get(m)%>" selected><%=provNamesEdit.get(m)%></option>
                                                                            <%} else {%>
                                                                                <option value="<%=provNamesEdit.get(m)%>"><%=provNamesEdit.get(m)%></option>
                                                                        <%}}%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT TYPE -->
                                                            <div class="mb-3">
                                                                <label for="movType-<%= i%>">Tipo de Movimentação</label>
                                                                <select class="form-control" name="movType" id="movType-<%= i%>">
                                                                    <% if (movement.getMovType().equals("Saída")) { %>
                                                                    <option value="Saida" selected>Saida</option>
                                                                    <option value="Entrada">Entrada</option>
                                                                    <% } else { %>
                                                                    <option value="Saida">Saida</option>
                                                                    <option value="Entrada" selected>Entrada</option>
                                                                    <% }%>
                                                                </select>
                                                            </div>
                                                            <!-- MOVEMENT QUANTITY -->
                                                            <div class="mb-3">
                                                                <label for="movQnt-<%= i%>">Quantidade</label>
                                                                <input type="number" min="0" class="form-control" name="movQnt" id="movQnt-<%= i%>" 
                                                                       value="<%= Math.abs(movement.getMovQnt())%>" required/>
                                                            </div>
                                                            <!-- MOVEMENT VALUE -->
                                                            <div class="mb-3">
                                                                <label for="movValue-<%= i%>">Valor</label>
                                                                <input type="number" min="0" step="0.01" class="form-control" name="movValue" id="movValue-<%= i%>" 
                                                                       value="<%= movement.getMovValue()%>" required/>
                                                            </div>
                                                            <!-- MOVEMENT AVG VALUE -->
                                                            <div class="mb-3">
                                                                <label for="movAvgValue-<%= i%>">Valor médio</label>
                                                                <input type="number" class="form-control" name="movAvgValue" id="movAvgValue-<%= i%>" 
                                                                       value="<%= Movement.getAvgById(movement.getMovProd())%>" disabled/>
                                                            </div>
                                                            <!-- MOVEMENT DESCRIPTION -->
                                                            <div class="mb-3">
                                                                <label for="movDesc-<%= i%>">Descrição</label>
                                                                <input type="text" class="form-control" name="movDesc" id="movDesc-<%= i%>" 
                                                                       value="<%= movement.getMovDesc()%>"/>
                                                            </div>
                                                        </div>
                                                        <!-- MOVEMENT SAVE AND CANCEL BUTTON -->
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                            <input type="hidden" name="movId" value="<%= movement.getMovId()%>"/>
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
        <!-- SEARCH BAR -->
        <script>
            $(document).ready(function () {
                $('#table-movements').DataTable({
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

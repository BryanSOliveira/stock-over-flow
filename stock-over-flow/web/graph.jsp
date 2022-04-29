<%-- 
    Document   : graph
    Created on : 28 de abr. de 2022, 01:04:19
    Author     : Okami
--%>

<%@page import="db.Movement"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    ArrayList<Integer> mov = Movement.getSells();
    ArrayList<String> dat = Movement.getSalesDates();
%>
<!DOCTYPE html>
<html>
    <head>
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js"></script>
    </head>
    <body>
        <div>
        <canvas id="myChart" height="20px" width="200px"></canvas>
        
        </div>
        
        
        
        
        
           
    </body>
</html>

<script>
  const labels = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
  ];
  var x = 40;
  alert("<%=dat%>");
  const data = {
    labels: labels,
    datasets: [{
      label: 'My First dataset',
      backgroundColor: 'rgb(255, 99, 132)',
      borderColor: 'rgb(255, 99, 132)',
      
      data: <%=mov%>,
    }]
  };
console.log(data);
  const config = {
    type: 'line',
    data: data,
    options: {}
  };
</script>
<script>
  const myChart = new Chart(
    document.getElementById('myChart'),
    config
  );
</script>
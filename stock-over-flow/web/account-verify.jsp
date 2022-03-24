<%-- 
    Document   : account-verify
    Created on : 24 de mar. de 2022, 10:49:30
    Author     : K4mi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verify Page</title>
    </head>
    <body>
        <span>We already send a verification code to your email.</span>
        
        <form action="VerifyToken" method="post">
            <input type="text" name="authToken" >
            <input type="submit" value="verify">
        </form>
    </body>
</html>

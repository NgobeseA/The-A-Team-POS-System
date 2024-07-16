<%-- 
    Document   : IBTReceiveDashboard
    Created on : 15 Jul 2024, 3:49:36 PM
    Author     : carme
--%>

<%@page import="ateam.Models.IBT"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>IBT Receive Dashboard Page</title>
    </head>
    <body>
        <h1>IBT Receive Dashboard</h1>
        <form action="IBTServlet" method="post">
            <label>IBT Requests needed for approval</label>
            <input type="submit" value="Check_IBT" name="IBT_switch">   
        </form>
        
        <% 
    List<IBT> stores = (List<IBT>) request.getAttribute("Stores");
    if (stores != null && !stores.isEmpty()) {
        for (IBT i : stores) {
    %>
    <form action="IBTServlet" method="post">
        <div style="border: 1px solid #ccc; padding: 10px; margin-bottom: 10px;">
            <h2>Requested Store ID: <%= i.getStoreID() %></h2>
            <p>Requested Product ID: <%= i.getProductID() %></p>
            
            <input type="submit" value="Approve" name="IBT_switch">
            <input type="hidden" value="<%= i.getProductID() %>" name="product_id">
            <input type="hidden" value="<%= i.getStoreID() %>" name="store_id"> 
        </div>
    </form>
    <% 
        }
    } else {
    %>
    <p><%= request.getAttribute("message") %></p>
    <p>No stores found.</p>
    <% 
    } 
    %>
    </body>
</html>

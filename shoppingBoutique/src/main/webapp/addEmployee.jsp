<%-- 
    Document   : addEmployee
    Created on : Jul 10, 2024, 2:44:36 PM
    Author     : Train 01
--%>

<%@page import="java.util.List"%>
<%@page import="ateam.Models.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add employee</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/log.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    
    </head>
    <body>
        <%  List<Role> roles = (List<Role>) request.getSession(false).getAttribute("roles");
            String message = (String) request.getAttribute("addEmployeeMessage");%>
        <div class="container">
            <div class="login-box">
                <div class="login-header">
                    <h4>Carols Boutique</h4>
                    <h3>Login</h3>
                </div>
                <form action="employees" method="post">
                    <div class="two-forms">
                        <div class="input-box">
                            <input type="text"
                                   placeholder='Firstname'
                                   name='firstname'
                                   class='input-field'
                                   autocomplete="off" required
                                   />
                             <i class="bx bx-user"></i>
                        </div>
                        <div class="input-box">
                            <input type="text"
                                   placeholder='Lastname'
                                   name='lastname'
                                   class='input-field'
                                   autocomplete="off" required
                                   />
                             <i class="bx bx-user"></i>
                        </div>
                    </div>
                    
                    <div class="input-box">
                        <input type="password"
                               placeholder='Password'
                               name='password'
                               class="input-field"
                               autocomplete="off" required
                               />
                        <i class="bx bx-lock-alt"></i>
                    </div>
                    
                    <div class="select-container">
                        <label>Role</label>
                        <select class="select-box">Select Role</select>
                            <% if(roles != null){
                                for(Role role : roles){%>
                                <option value="<%=role.name()%>"><%=role.name()%></option>
                                <%}}%>
                            
                    </div>
                    
                    
                    <%if(message != null){%>
                    <p><%=message%></p>
                    <%}%>
                    <div class="input-submit">
                        <input name="submit" value="login" hidden>
                        <button class="submit-btn" id="submit">LogIn</button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

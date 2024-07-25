<%-- 
    Document   : managerDashboard
    Created on : Jul 10, 2024, 1:27:16 PM
    Author     : Train 01
--%>

<%@page import="ateam.Models.Product"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="ateam.Models.Store"%>
<%@page import="ateam.Models.Sale"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="ateam.Models.Role"%>
<%@page import="ateam.Models.Employee"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/report.css">
        <!-- Script to trigger notification update on IBT Main Dashboard -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/topSellingEmployee.js"></script>
        <script>
            $(document).ready(function() {
                // Trigger a click on "IBT Requests" button in IBTMainDashboard.jsp
                $("a[href='IBTMainDashboard.jsp']").click(function() {
                    // Post a message to parent window (IBTMainDashboard.jsp)
                    window.postMessage("refreshIBTNotifications", "*");
                });
            });
        </script>
    </head>
    <body>
        <% 
        Employee employee = (Employee) request.getSession(false).getAttribute("Employee"); 
        List<Sale> sales = (List<Sale>) request.getSession(false).getAttribute("Sales");
        List<Employee> employees = (List<Employee>) request.getSession(false).getAttribute("Employees");
        List<Store> stores = (List<Store>) request.getSession(false).getAttribute("Stores");
        Map<String, Integer> salesData = (Map<String, Integer>) request.getAttribute("salesData");
        Map<String, Integer> monthSales = (Map<String, Integer>) request.getSession(false).getAttribute("report");
        Map<String, Integer> topEmp = (Map<String, Integer>) request.getSession(false).getAttribute("topSellingEmp");
        List<Product> products = (List<Product>) request.getSession(false).getAttribute("Products");

        if(employee != null){
            if(salesData != null && !salesData.isEmpty()){
                StringBuilder labels = new StringBuilder();
                StringBuilder data = new StringBuilder();
                int totalSales = 0;

                for(Map.Entry<String, Integer> entry : salesData.entrySet()){
                    if(entry.getValue() > totalSales)
                        totalSales += entry.getValue();
                    labels.append("'").append(entry.getKey()).append("',");
                    data.append(String.format("%.2f",(entry.getValue() * 100.0 / totalSales))).append(",");
                }

                if(labels.length() > 0){
                    labels.setLength(labels.length() - 1);
                    data.setLength(data.length() - 1);
                }
        %>

        <div class="manager-container">
            <div class="sidebar">
                <jsp:include page="sidebar.jsp"/>
            </div>
            <div class="menu-content">
                <div class='heading'>
                    <h1>Reports</h1>
                </div>
                <div class="report">
                    <div class="two">
                        <h4>Top Achieving Store</h4>
                        <div class="input-submit">
                            <input name="submit" value="download" hidden>
                            <button class="submit-btn" id="submit">Download</button>
                        </div>
                    </div>
                    <div class="graphBox">
                        <div class="box">
                            <canvas id="salesChart"></canvas>
                        </div>
                        <div class="box">
                            <canvas id="salesPieChart"></canvas>
                        </div>
                    </div>

                    <!-- Monthly Sales in a Store -->
                    <div class="two">
                        <h4>Sale of the Month</h4>
                        <form action="SalesDemo" method="post">
                            <div>
                                <select class="select-box" name="storeId">
                                    <% if(stores != null) {
                                        for(Store store : stores) { %>
                                        <option value="<%=store.getStore_ID() %>"><%=store.getStore_name() %></option>
                                        <% } } %>
                                </select>
                            </div>
                            <input id="date" name="date" type="month" required/>
                            <button type="submit" name="submit" value="filter">Filter</button>
                        </form>
                        <div class="input-submit">
                            <input name="submit" value="download" hidden />
                            <button class="submit-btn" id="submit">Download</button>
                        </div>
                    </div>
                    <div class="graphBox">
                        <div class="box">
                            <canvas id="monthlySalesChart"></canvas>
                        </div>
                        <div class="box">
                            <canvas id="salesPieChart"></canvas>
                        </div>
                    </div>


                    <!-- Top selling employeee  -->
                    <div class="two">
                        <h4>Top Selling Employee</h4>

                        <form action="SalesDemo" method="post">
                            <div>
                                <select id="employeeSalesPerStore" class="select-box" name="storeId">
                                    <% if(stores != null) {
                                        for(Store store : stores) { %>
                                        <option value="<%=store.getStore_ID() %>"><%=store.getStore_name() %></option>
                                        <% } } %>
                                </select>
                            </div>
                            <button type="submit" name="submit" value="topEmp">Filter</button>
                        </form>
                        <div class="input-submit">
                            <input name="submit" value="download" hidden />
                            <button class="submit-btn" id="submit">Download</button>
                        </div>
                    </div>
                    <div class="graphBox">
                        <div class="box">
                            <canvas id="topEmpBar"></canvas>
                        </div>
                        <div class="box">
                            <canvas id="salesPieChart"></canvas>
                        </div>
                    </div>
                                
                     <!-- Store achieved target for a particular month  -->
                    <div class="two">
                        <h4>Stores Achieved target for particular month</h4>

                        <form action="SalesDemo" method="post">
                            <input id="storeAchievedTarget" name="storeAchievedTarget" type="month" required/>
                            <button type="submit" name="submit" value="storeAchievedTarget">Filter</button>
                        </form>
                        <div class="input-submit">
                            <input name="submit" value="download" hidden />
                            <button class="submit-btn" id="submit">Download</button>
                        </div>
                    </div>
                    <div class="graphBox">
                        <div class="box">
                            <canvas id="StoreAchievedMonthBar"></canvas>
                        </div>
                        <div class="box">
                            <canvas id="salesPieChart"></canvas>
                        </div>
                    </div>
                     
                     <!-- Top selling employee based on product -->
                     <% if(products != null){%>
                     <div class="two">
                         <h4>Top selling employee based on product</h4>
                         <div>
                                <select id="topEmployeeBasedOnProduct" class="select-box" name="productId">
                                    <% if(products != null) {
                                        for(Product product : products) { %>
                                        <option value="<%=product.getProduct_ID() %>"><%=product.getProduct_name() %></option>
                                        <% } } %>
                                </select>
                                <button id="getTopEmployeeButton">Get Top Employee</button>
                                <div id="topEmployeeResult">
                                    <!-- Result will be displayed here -->
                                </div>
                            </div>
                     </div>
                         <%}%>
                         
                        <!-- Current daily sales -->
                        <div class="two">
                            <h4>View Any store current progress in sale</h4>
                            <p>Select the store you want</p>
                            <div>
                                <select id="currentSalesStoreId" name="currentSalesStoreId" class="select-box">
                                    <option>choose store here</option>
                                    <% for(Store store : stores){%>
                                    <option value="<%=store.getStore_ID()%>"><%=store.getStore_name()%></option>
                                    <%}%>
                                </select>
                                <button id="getStoreCurrentSales">Current Sales</button>
                                
                                <div id="storeDailyResult"></div>
                            </div>
                        </div>
                       
                        
                        
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // Retrieve the sales data from JSP

                // Chart for Sales Data
                var ctx = document.getElementById('salesChart').getContext('2d');
                var salesChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: [<%= labels.toString() %>],
                        datasets: [{
                            barPercentage: 1,
                            label: 'Sales',
                            data: [<%= data.toString() %>],
                            backgroundColor: [
                                'rgba(255, 99, 132, 1)'
                            ]
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                ticks: {
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                }
                            }
                        }
                    }
                });

                // Chart for Pie Data
                var ctxP = document.getElementById('salesPieChart').getContext('2d');
                var salesPieChart = new Chart(ctxP, {
                    type: 'pie',
                    data: {
                        labels: [<%= labels.toString() %>],
                        datasets: [{
                            label: 'Sales',
                            data: [<%= data.toString() %>],
                            backgroundColor: [
                                'rgba(255, 99, 132, 1)',
                                'rgba(123, 89, 132, 1)',
                                'rgba(255, 165, 99, 1)',
                                'rgba(94, 83, 83, 1)'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'right'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context){
                                        let label = context.label || '';
                                        if(context.parsed !== null){
                                            let percentage = context.raw + '%';
                                            label += ': ' + percentage;
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });

                const monthYear = document.getElementById('date');

                // Function to Filter Sales
            });
        </script>

        <% if(monthSales != null){
            StringBuilder monthLabels = new StringBuilder();
            StringBuilder monthData = new StringBuilder();
            for(Map.Entry<String, Integer> entry : monthSales.entrySet()){
                monthLabels.append("'").append(entry.getKey()).append("',");
                monthData.append(entry.getValue()).append(",");
            }
        %>
        
        <script>
            var monthCtx = document.getElementById("monthlySalesChart").getContext('2d');
            
            var monthBar = new Chart(monthCtx, {
                type: 'bar',
                data: {
                    labels: [<%=monthLabels.toString() %>],
                    datasets: [{
                        label: 'Sales of the month',
                        data: [<%=monthData.toString()%>],
                        backgroundColor: ['rgba(61, 179, 242, 0.2)',
                        'rgba(255, 99, 132, 0.2)'
                        ],
                        borderColor: 'rgba(61, 179, 242, 1)',
                        borderWidth: 1
                    }]
                }
            });

        </script>
        
    <% }%> 
        
    <!-- Top Selling Emp data -->    
    <% if(topEmp != null){
        StringBuilder topEmpLabels = new StringBuilder();
        StringBuilder topEmpData = new StringBuilder();
        for(Map.Entry<String, Integer> entry : topEmp.entrySet()){
            topEmpLabels.append("'").append(entry.getKey()).append("',");
            topEmpData.append(entry.getValue()).append(",");
        }
        %>    
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const emp = document.getElementById('employeeSalesPerStore');
                const topCtx = document.getElementById("topEmpBar").getContext('2d');

                // Initialize the chart with the sorted data
                const topEmpBar = new Chart(topCtx, {
                    type: 'bar',
                    data: {
                        labels: [<%= topEmpLabels.toString() %>],
                        datasets: [{
                            label: 'Top Selling Employee',
                            data: [<%= topEmpData.toString() %>],
                            backgroundColor: 'rgba(61, 179, 242, 0.2)',  // Light blue background color
                            borderColor: 'rgba(61, 179, 242, 1)',
                            borderWidth: 2,
                            borderRadius: 5,
                            borderSkipped: false
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });

                // Event listener for storeId changes
                emp.addEventListener('change', function() {
                    const storeId = emp.value;

                    // Fetch new data based on storeId
                    fetch('SalesDemo', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: new URLSearchParams({
                            storeId: storeId,
                            submit: 'topEmpByStore'  // Include an action parameter if needed for the server logic
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        // Assuming `data` is an object with `labels` and `data` arrays
                        const labels = data.labels;
                        const salesData = data.data;
                        console.log(salesData);
                        // Update the chart with new data
                        topEmpBar.data.labels = labels;
                        topEmpBar.data.datasets[0].data = salesData;
                        topEmpBar.update();
                    })
                    .catch(error => console.error('Error fetching data:'+ error));
                            });
                            
                const storeAchievedTarget = document.getElementById('storeAchievedTarget');
                storeAchievedTarget.addEventListener('change', function(){
                    const date = storeAchievedTarget.value;
                    
                    fetch('SalesDemo', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'},
                        body: new URLSearchParams({date: date, submit:'storeAchievedTarget'})
                    })
                            .then(response => response.json())
                            .then(data => {
                                const storelabels = data.labels;
                                const storeData = data.data;
                                storeAchieved.data.labels = storelabels;
                                storeAchieved.data.datasets[0].data = storeData;
                                storeAchieved.update();    
                }).catch(error => console.error('Error fecthing data: '+ error));
                });
                
                const achievedCtx = document.getElementById("StoreAchievedMonthBar").getContext('2d');

                // Initialize the chart with the sorted data
                const storeAchieved = new Chart(achievedCtx, {
                    type: 'bar',
                    data: {
                        labels: [],
                        datasets: [{
                            label: 'Stores Achieved Target For Selected Month',
                            data: [],
                            backgroundColor: 'rgba(61, 179, 242, 0.2)',  // Light blue background color
                            borderColor: 'rgba(61, 179, 242, 1)',
                            borderWidth: 2,
                            borderRadius: 5,
                            borderSkipped: false
                        }]
                    },
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
                        });
        </script>
        <% }%>
    <% }%> 




        <% } %>
    </body>
</html>

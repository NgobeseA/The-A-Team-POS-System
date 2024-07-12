package ateam.Servlets;

import ateam.BDconnection.Connect;
import ateam.DAO.EmployeeDAO;
import ateam.DAOIMPL.EmployeeDAOIMPL;
import ateam.DAOIMPL.StoreDAOIMPL;
import ateam.Models.Employee;
import ateam.Models.Role;
import ateam.Models.Store;
import ateam.Service.EmployeeService;
import ateam.Service.StoreService;
import ateam.ServiceImpl.EmployeeServiceImpl;
import ateam.ServiceImpl.StoreServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EmployeeServlet", urlPatterns = "/employees")
public class EmployeeServlet extends HttpServlet {

    private final EmployeeService employeeService;
    private final StoreService storeService;

    public EmployeeServlet() {
        try {
            EmployeeDAO employeeDAO = new EmployeeDAOIMPL();
            this.employeeService = new EmployeeServiceImpl(employeeDAO);
            this.storeService = new StoreServiceImpl(new StoreDAOIMPL(new Connect().connectToDB()));
        } catch (Exception e) {
            Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, "Error initializing EmployeeService", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("submit");

        switch (action) {
            case "add":
                addEmployee(request, response);
                break;
            case "update":
                updateEmployee(request, response);
                break;
            case "delete":
                deleteEmployee(request, response);
                break;
            case "login":
                handleLogin(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("submit");
        HttpSession session = request.getSession(false);

        switch(action){
            case "getAddEmployee":
                List<Store> stores = storeService.getAllStores();
                session.setAttribute("stores", stores);
                request.getRequestDispatcher("addEmployee.jsp").forward(request, response);
                break;
          
        }
        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("addForm".equals(action)) {
            showAddForm(request, response);
        } else if ("deleteConfirm".equals(action)) {
            showDeleteConfirm(request, response);
        } else {
            listEmployees(request, response);

        }
        
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employee> employees = employeeService.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/listEmployees.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/addEmployee.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        Employee employee = employeeService.getEmployeeById(employeeId);
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/editEmployee.jsp").forward(request, response);
    }

    private void showDeleteConfirm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        Employee employee = employeeService.getEmployeeById(employeeId);
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/deleteEmployee.jsp").forward(request, response);
    }

    private void addEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /*
        retrieving the manager from the session
        want to get a store id from the manager so I can assign it to employee
        might change this code as time goes on
        */
        Employee emp = (Employee) request.getSession(false).getAttribute("Employee");
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        Integer storeId = emp.getStore_ID();
        String employeesId = request.getParameter("employeesId");     // employee Id will be generated from the database so there is no need to send it from this side
        String password = request.getParameter("password");
        Role role = Role.valueOf(request.getParameter("role"));

        Employee newEmployee = new Employee();
        newEmployee.setFirstName(firstName.trim());
        newEmployee.setLastName(lastName.trim());
        newEmployee.setStore_ID(storeId);
        newEmployee.setEmployees_id(employeesId.trim());
        newEmployee.setEmployeePassword(password.trim());
        newEmployee.setRole(role);

        boolean success = employeeService.addEmployee(newEmployee);
        
        if (success) {
            request.setAttribute("addEmployeeMessage", "Employee added successfully");
            response.sendRedirect(request.getContextPath() + "/employees?submit=getAddEmployee");
        } else {
            
            response.sendRedirect(request.getContextPath() + "/employees?submit=getAddEmployee");
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        //String email = request.                                               // Please add email
        String employeesId = request.getParameter("employeesId");
        String password = request.getParameter("password");
        Role role = Role.valueOf(request.getParameter("role"));
        int storeId;
        if(role == Role.Manager){
            storeId = Integer.parseInt(request.getParameter("managerStoreId"));
        }else{
            storeId = Integer.parseInt(request.getParameter("tellerStoreId"));
        }

        Employee employeeToUpdate = new Employee();
        employeeToUpdate.setEmployee_ID(employeeId);
        employeeToUpdate.setFirstName(firstName);
        employeeToUpdate.setLastName(lastName);
        employeeToUpdate.setStore_ID(storeId);
        employeeToUpdate.setEmployees_id(employeesId);
        employeeToUpdate.setEmployeePassword(password);
        employeeToUpdate.setRole(role);

        boolean success = employeeService.updateEmployee(employeeToUpdate);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/employees");
        } else {
            response.sendRedirect(request.getContextPath() + "/employees");
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));

        boolean success = employeeService.deleteEmployee(employeeId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/employees");
        } else {
            response.sendRedirect(request.getContextPath() + "/employees");
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Employee employee = employeeService.login(
                request.getParameter("employeeId"), 
                request.getParameter("password"));
        if(employee != null){
            HttpSession session = request.getSession(true);
            session.setAttribute("Employee", employee);
            System.out.println("store Id: "+employee.getStore_ID());
            Store store = storeService.getStoreById(employee.getStore_ID());
            session.setAttribute("store", store);
            
            
            switch (employee.getRole()) {
                case Admin:
                    request.getRequestDispatcher("admin.jsp").forward(request, response);
                    break;
                case Manager:
                    request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
                    break;
                default:
                    request.getRequestDispatcher("tellerDashboard.jsp").forward(request, response);
                    break;
            }

        }else{
            request.setAttribute("message", "failed to login");
             request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

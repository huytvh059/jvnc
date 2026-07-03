package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import dao.CategoryDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final ProductDAO productDao = new ProductDAO();
    private final CategoryDAO categoryDao = new CategoryDAO();
    private final CustomerDAO customerDao = new CustomerDAO();
    private final InvoiceDAO invoiceDao = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            req.setAttribute("productCount",  productDao.count());
            req.setAttribute("categoryCount", categoryDao.count());
            req.setAttribute("customerCount", customerDao.count());
            req.setAttribute("todayInvoices", invoiceDao.countTodayInvoices());
            BigDecimal rev = invoiceDao.todayRevenue();
            req.setAttribute("todayRevenue", rev == null ? "0" : rev.toPlainString());
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi khi tải thống kê: " + e.getMessage());
        }
        req.setAttribute("active", "dashboard");
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}

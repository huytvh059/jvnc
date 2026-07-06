package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import util.FlashUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO dao = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!auth(req, resp)) return;
        String action = req.getParameter("action");
        try {
            if ("new".equals(action)) {
                req.setAttribute("form", new Customer());
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/WEB-INF/views/customer-form.jsp").forward(req, resp);
            } else if ("edit".equals(action)) {
                int id = parseInt(req.getParameter("id"));
                Customer c = dao.findById(id);
                if (c == null) { redirectList(req, resp); return; }
                req.setAttribute("form", c);
                req.setAttribute("mode", "update");
                req.getRequestDispatcher("/WEB-INF/views/customer-form.jsp").forward(req, resp);
            } else {
                String q = req.getParameter("q");
                List<Customer> list = dao.search(q);
                req.setAttribute("list", list);
                req.setAttribute("q", q);
                req.setAttribute("active", "customers");
                req.getRequestDispatcher("/WEB-INF/views/customers.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!auth(req, resp)) return;
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            if ("create".equals(action)) {
                Customer c = bind(req, new Customer());
                dao.insert(c);
                flash(req, "Đã thêm khách hàng.");
            } else if ("update".equals(action)) {
                Customer c = bind(req, new Customer());
                c.setId(parseInt(req.getParameter("id")));
                dao.update(c);
                flash(req, "Đã cập nhật khách hàng #" + c.getId());
            } else if ("delete".equals(action)) {
                handleDelete(req, parseInt(req.getParameter("id")));
            }
            redirectList(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", FlashUtil.friendlyMessage(e, "Lỗi CSDL."));
            req.setAttribute("form", new Customer());
            req.setAttribute("mode", "create");
            req.getRequestDispatcher("/WEB-INF/views/customer-form.jsp").forward(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, int id) throws SQLException {
        if (id <= 0) {
            FlashUtil.error(req, "ID khách hàng không hợp lệ.");
            return;
        }
        try {
            int n = dao.delete(id);
            if (n == 0) {
                FlashUtil.error(req, "Khách hàng không tồn tại hoặc đã bị xóa.");
            } else {
                FlashUtil.success(req, "Đã xóa khách hàng.");
            }
        } catch (SQLException e) {
            FlashUtil.error(req, FlashUtil.friendlyMessage(e,
                    "Không thể xóa khách hàng."));
        }
    }

    private Customer bind(HttpServletRequest req, Customer c) {
        c.setFullname(req.getParameter("fullname"));
        c.setPhone(req.getParameter("phone"));
        c.setEmail(req.getParameter("email"));
        c.setAddress(req.getParameter("address"));
        return c;
    }

    private void redirectList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/customers");
    }
    private void flash(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("flash", msg);
    }
    private static int parseInt(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return 0; } }
    private boolean auth(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}

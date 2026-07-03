package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    private final ProductDAO dao = new ProductDAO();
    private final CategoryDAO catDao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!auth(req, resp)) return;
        String action = req.getParameter("action");
        try {
            if ("new".equals(action) || "edit".equals(action)) {
                Product p;
                if ("edit".equals(action)) {
                    int id = parseInt(req.getParameter("id"));
                    p = dao.findById(id);
                    if (p == null) { redirectList(req, resp); return; }
                } else {
                    p = new Product();
                }
                req.setAttribute("form", p);
                req.setAttribute("categories", catDao.findAll());
                req.setAttribute("mode", "new".equals(action) ? "create" : "update");
                req.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(req, resp);
            } else {
                String q = req.getParameter("q");
                List<Product> list = dao.searchByName(q);
                req.setAttribute("list", list);
                req.setAttribute("q", q);
                req.setAttribute("active", "products");
                req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
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
            Product p = bind(req);
            if ("create".equals(action)) {
                dao.insert(p);
                flash(req, "Đã thêm sản phẩm.");
            } else if ("update".equals(action)) {
                p.setId(parseInt(req.getParameter("id")));
                dao.update(p);
                flash(req, "Đã cập nhật sản phẩm #" + p.getId());
            } else if ("delete".equals(action)) {
                dao.delete(parseInt(req.getParameter("id")));
                flash(req, "Đã xóa sản phẩm.");
            }
            redirectList(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.setAttribute("form", new Product());
            try { req.setAttribute("categories", catDao.findAll()); } catch (SQLException ignored) {}
            req.setAttribute("mode", "create");
            req.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(req, resp);
        }
    }

    private Product bind(HttpServletRequest req) {
        Product p = new Product();
        p.setName(req.getParameter("name"));
        try { p.setCategoryId(Integer.parseInt(req.getParameter("categoryId"))); } catch (Exception e) { p.setCategoryId(0); }
        try { p.setPrice(new BigDecimal(req.getParameter("price"))); } catch (Exception e) { p.setPrice(BigDecimal.ZERO); }
        try { p.setQuantity(Integer.parseInt(req.getParameter("quantity"))); } catch (Exception e) { p.setQuantity(0); }
        p.setMaterial(req.getParameter("material"));
        p.setImage(req.getParameter("image"));
        p.setDescription(req.getParameter("description"));
        return p;
    }

    private void redirectList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/products");
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

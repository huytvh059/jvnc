package controller;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * CRUD cho Category:
 *   GET  /categories           -> list
 *   GET  /categories?action=new  -> form thêm
 *   GET  /categories?action=edit&id=X -> form sửa
 *   POST /categories           (action=create|update|delete) -> xử lý rồi redirect list
 */
@WebServlet(name = "CategoryServlet", urlPatterns = {"/categories"})
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO dao = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isLoggedIn(req, resp)) return;
        String action = req.getParameter("action");
        try {
            if ("new".equals(action)) {
                req.setAttribute("formCategory", new Category());
                req.setAttribute("mode", "create");
                req.getRequestDispatcher("/WEB-INF/views/category-form.jsp").forward(req, resp);
            } else if ("edit".equals(action)) {
                int id = parseInt(req.getParameter("id"));
                Category c = dao.findById(id);
                if (c == null) { resp.sendRedirect(req.getContextPath() + "/categories"); return; }
                req.setAttribute("formCategory", c);
                req.setAttribute("mode", "update");
                req.getRequestDispatcher("/WEB-INF/views/category-form.jsp").forward(req, resp);
            } else if ("delete".equals(action)) {
                int id = parseInt(req.getParameter("id"));
                try {
                    dao.delete(id);
                    req.getSession().setAttribute("flash", "Đã xóa danh mục #" + id);
                } catch (SQLException e) {
                    req.getSession().setAttribute("flash", "Không thể xóa: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/categories");
            } else {
                List<Category> list = dao.findAll();
                req.setAttribute("list", list);
                req.setAttribute("active", "categories");
                req.getRequestDispatcher("/WEB-INF/views/categories.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isLoggedIn(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        try {
            if ("create".equals(action)) {
                Category c = new Category();
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                dao.insert(c);
                req.getSession().setAttribute("flash", "Đã thêm danh mục mới.");
            } else if ("update".equals(action)) {
                Category c = new Category();
                c.setId(parseInt(req.getParameter("id")));
                c.setName(req.getParameter("name"));
                c.setDescription(req.getParameter("description"));
                dao.update(c);
                req.getSession().setAttribute("flash", "Đã cập nhật danh mục #" + c.getId());
            } else if ("delete".equals(action)) {
                dao.delete(parseInt(req.getParameter("id")));
                req.getSession().setAttribute("flash", "Đã xóa danh mục.");
            }
            resp.sendRedirect(req.getContextPath() + "/categories");
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi CSDL: " + e.getMessage());
            req.setAttribute("formCategory", new Category());
            req.setAttribute("mode", "create");
            req.getRequestDispatcher("/WEB-INF/views/category-form.jsp").forward(req, resp);
        }
    }

    private static int parseInt(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return 0; } }

    private boolean isLoggedIn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}

package controller;

import java.io.IOException;
import java.sql.SQLException;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 * Servlet xử lý đăng nhập / đăng xuất.
 *
 * - GET  /login            : hiển thị form đăng nhập (forward sang login.jsp)
 * - POST /login            : kiểm tra username/password, lưu session, redirect -> dashboard
 * - GET  /logout          : hủy session, redirect về /login
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        // Nếu đã đăng nhập rồi thì chuyển thẳng dashboard
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = trim(req.getParameter("username"));
        String password = trim(req.getParameter("password"));

        String error = null;
        if (username.isEmpty() || password.isEmpty()) {
            error = "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.";
        } else {
            try {
                Account acc = accountDAO.login(username, password);
                if (acc == null) {
                    error = "Sai tên đăng nhập hoặc mật khẩu.";
                } else {
                    HttpSession s = req.getSession(true);
                    s.setAttribute("user", acc);
                    s.setAttribute("role", acc.getRole());
                    s.setMaxInactiveInterval(30 * 60); // 30 phút
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            } catch (SQLException e) {
                e.printStackTrace();
                error = "Lỗi CSDL: " + e.getMessage();
            }
        }

        req.setAttribute("error", error);
        req.setAttribute("username", username);
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}

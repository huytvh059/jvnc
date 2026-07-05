package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;
import java.util.Set;

/**
 * Filter phân quyền:
 *  - Yêu cầu đăng nhập cho tất cả URL bảo vệ.
 *  - Quy ước quyền:
 *      GET (xem)                       : admin + staff đều vào được
 *      POST create/update              : admin toàn quyền; staff chỉ trên /customers & /invoices
 *      POST delete                     : chỉ admin
 *      GET ?action=status (Invoice)    : chỉ admin
 *
 *  Áp dụng cho: /dashboard, /products, /categories, /customers, /invoices
 */
@WebFilter(filterName = "AuthorizationFilter",
        urlPatterns = {"/products", "/categories", "/customers", "/invoices", "/dashboard"})
public class AuthorizationFilter implements Filter {

    private static final Set<String> ADMIN_ONLY_ACTIONS = Set.of("delete", "status");
    private static final Set<String> STAFF_ALLOWED_WRITE = Set.of("create", "update");
    private static final Set<String> STAFF_WRITE_URLS   = Set.of("/customers", "/invoices");

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account user = (Account) session.getAttribute("user");
        String role  = user.getRole() == null ? "" : user.getRole().toLowerCase();

        if ("admin".equals(role)) {
            chain.doFilter(req, resp);
            return;
        }

        // staff: chỉ xem + (create|update) trên customers & invoices
        String uri    = request.getRequestURI();
        String ctx    = request.getContextPath();
        String path   = uri.substring(ctx.length());

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");
            if (action != null && ADMIN_ONLY_ACTIONS.contains(action)) {
                deny(response, request, action);
                return;
            }
            chain.doFilter(req, resp);
            return;
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");
            if (action != null
                && !STAFF_ALLOWED_WRITE.contains(action)
                || action == null) {
                deny(response, request, action);
                return;
            }
            if (!STAFF_WRITE_URLS.contains(path)) {
                deny(response, request, action);
                return;
            }
            chain.doFilter(req, resp);
            return;
        }

        // Other methods: deny
        deny(response, request, null);
    }

    private void deny(HttpServletResponse response, HttpServletRequest request, String action) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setContentType("text/html;charset=UTF-8");
        String ctx = request.getContextPath();
        response.getWriter().write(
            "<!DOCTYPE html><html><head><meta charset='UTF-8'>"
            + "<title>403 - Không có quyền</title>"
            + "<link rel='stylesheet' href='" + ctx + "/css/app.css'>"
            + "</head><body><div class='app' style='display:block;padding:40px;'>"
            + "<div class='card' style='max-width:520px;margin:80px auto;text-align:center;'>"
            + "<h1 style='color:#dc2626;'>⛔ 403 — Không có quyền</h1>"
            + "<p>Tài khoản <b>staff</b> không được phép thực hiện thao tác: "
            + "<code>" + (action == null ? "(không xác định)" : action) + "</code></p>"
            + "<p>Vui lòng liên hệ quản trị viên nếu cần thiết.</p>"
            + "<a class='btn btn-primary' href='" + ctx + "/dashboard'>← Về Dashboard</a>"
            + "</div></div></body></html>"
        );
    }
}

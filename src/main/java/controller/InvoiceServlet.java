package controller;

import dao.CustomerDAO;
import dao.InvoiceDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Customer;
import model.Invoice;
import model.InvoiceDetail;
import model.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoices"})
public class InvoiceServlet extends HttpServlet {

    private final InvoiceDAO dao = new InvoiceDAO();
    private final CustomerDAO customerDao = new CustomerDAO();
    private final ProductDAO productDao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!auth(req, resp)) return;
        String action = req.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "new": {
                    req.setAttribute("form", new Invoice());
                    req.setAttribute("customers", customerDao.findAll());
                    List<model.Product> prods = productDao.findAll();
                    req.setAttribute("products", prods);
                    // Chuẩn bị sẵn JSON để truyền xuống JS an toàn (tránh escape issue)
                    StringBuilder sb = new StringBuilder("[");
                    for (int i = 0; i < prods.size(); i++) {
                        if (i > 0) sb.append(',');
                        model.Product p = prods.get(i);
                        sb.append("{\"id\":").append(p.getId())
                          .append(",\"name\":").append(jsonString(p.getName()))
                          .append(",\"price\":").append(p.getPrice() != null ? p.getPrice().toPlainString() : "0")
                          .append('}');
                    }
                    sb.append(']');
                    req.setAttribute("productJson", sb.toString());
                    req.setAttribute("mode", "create");
                    req.getRequestDispatcher("/WEB-INF/views/invoice-form.jsp").forward(req, resp);
                    return;
                }
                case "view": {
                    int id = parseInt(req.getParameter("id"));
                    Invoice inv = dao.findById(id);
                    List<InvoiceDetail> details = dao.findDetails(id);
                    req.setAttribute("inv", inv);
                    req.setAttribute("details", details);
                    req.getRequestDispatcher("/WEB-INF/views/invoice-detail.jsp").forward(req, resp);
                    return;
                }
                case "status": {
                    int id = parseInt(req.getParameter("id"));
                    String status = req.getParameter("status");
                    if (status != null) {
                        dao.updateStatus(id, status);
                        flash(req, "Đã cập nhật trạng thái hóa đơn #" + id);
                    }
                    resp.sendRedirect(req.getContextPath() + "/invoices?action=view&id=" + id);
                    return;
                }
                default: {
                    String from = req.getParameter("from");
                    String to = req.getParameter("to");
                    List<Invoice> list = (from != null && to != null && !from.isEmpty() && !to.isEmpty())
                            ? dao.findByDateRange(from, to)
                            : dao.findAll();
                    req.setAttribute("list", list);
                    req.setAttribute("from", from);
                    req.setAttribute("to", to);
                    req.setAttribute("active", "invoices");
                    req.getRequestDispatcher("/WEB-INF/views/invoices.jsp").forward(req, resp);
                }
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
                Invoice inv = new Invoice();
                inv.setCode(InvoiceDAO.nextCode());
                inv.setCustomerId(parseInt(req.getParameter("customerId")));
                inv.setAccountId(((Account) req.getSession().getAttribute("user")).getId());
                inv.setStatus("PENDING");

                String[] productIds  = req.getParameterValues("productId");
                String[] quantities  = req.getParameterValues("quantity");

                List<InvoiceDetail> details = new ArrayList<>();
                BigDecimal total = BigDecimal.ZERO;
                if (productIds != null) {
                    for (int i = 0; i < productIds.length; i++) {
                        int pid = parseInt(productIds[i]);
                        int qty = parseInt(quantities[i]);
                        if (pid == 0 || qty <= 0) continue;
                        Product p = productDao.findById(pid);
                        if (p == null) continue;
                        InvoiceDetail d = new InvoiceDetail();
                        d.setProductId(pid);
                        d.setQuantity(qty);
                        d.setUnitPrice(p.getPrice());
                        details.add(d);
                        total = total.add(p.getPrice().multiply(BigDecimal.valueOf(qty)));
                    }
                }
                inv.setTotalAmount(total);

                if (details.isEmpty()) {
                    flash(req, "Vui lòng chọn ít nhất một sản phẩm.");
                    resp.sendRedirect(req.getContextPath() + "/invoices?action=new");
                    return;
                }
                int newId = dao.createInvoice(inv, details);
                flash(req, "Đã tạo hóa đơn #" + newId + " — " + inv.getCode());
                resp.sendRedirect(req.getContextPath() + "/invoices?action=view&id=" + newId);
                return;
            } else if ("delete".equals(action)) {
                int id = parseInt(req.getParameter("id"));
                try {
                    dao.delete(id);
                    flash(req, "Đã xóa hóa đơn #" + id);
                } catch (SQLException e) {
                    flash(req, "Không thể xóa: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/invoices");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/invoices");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void flash(HttpServletRequest req, String msg) {
        req.getSession().setAttribute("flash", msg);
    }
    private static int parseInt(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return 0; } }

    /** Escape chuỗi thành JSON string hợp lệ. */
    private static String jsonString(String s) {
        if (s == null) return "\"\"";
        StringBuilder sb = new StringBuilder("\"");
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) sb.append(String.format("\\u%04x", (int) c));
                    else sb.append(c);
            }
        }
        sb.append('"');
        return sb.toString();
    }

    private boolean auth(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}

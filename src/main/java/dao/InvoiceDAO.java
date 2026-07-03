package dao;

import model.Invoice;
import model.InvoiceDetail;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    private static final String SELECT_JOIN =
        "SELECT i.id, i.code, i.customerId, c.fullname AS customerName, " +
        "       i.accountId, a.fullname AS accountName, " +
        "       i.totalAmount, i.status, i.createdAt " +
        "FROM Invoice i " +
        "  LEFT JOIN Customer c ON c.id = i.customerId " +
        "  LEFT JOIN Account  a ON a.id = i.accountId ";

    public List<Invoice> findAll() throws SQLException {
        return queryInvoices(SELECT_JOIN + " ORDER BY i.id DESC", null);
    }

    public List<Invoice> findByDateRange(String from, String to) throws SQLException {
        return queryInvoices(SELECT_JOIN + " WHERE CAST(i.createdAt AS DATE) BETWEEN ? AND ? ORDER BY i.id DESC", ps -> {
            ps.setString(1, from);
            ps.setString(2, to);
        });
    }

    public Invoice findById(int id) throws SQLException {
        List<Invoice> list = queryInvoices(SELECT_JOIN + " WHERE i.id = ?", ps -> ps.setInt(1, id));
        return list.isEmpty() ? null : list.get(0);
    }

    public List<InvoiceDetail> findDetails(int invoiceId) throws SQLException {
        String sql = "SELECT d.id, d.invoiceId, d.productId, p.name AS productName, " +
                "d.quantity, d.unitPrice, (d.quantity * d.unitPrice) AS lineTotal " +
                "FROM InvoiceDetail d LEFT JOIN Product p ON p.id = d.productId " +
                "WHERE d.invoiceId = ? ORDER BY d.id";
        List<InvoiceDetail> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceDetail d = new InvoiceDetail();
                    d.setId(rs.getInt("id"));
                    d.setInvoiceId(rs.getInt("invoiceId"));
                    d.setProductId(rs.getInt("productId"));
                    d.setProductName(rs.getString("productName"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setUnitPrice(rs.getBigDecimal("unitPrice"));
                    d.setLineTotal(rs.getBigDecimal("lineTotal"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    public int countTodayInvoices() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM Invoice WHERE CAST(createdAt AS DATE) = CAST(GETDATE() AS DATE)");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public BigDecimal todayRevenue() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT ISNULL(SUM(totalAmount),0) FROM Invoice WHERE CAST(createdAt AS DATE) = CAST(GETDATE() AS DATE) AND status = N'DONE'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }

    /**
     * Tạo hóa đơn + chi tiết trong transaction.
     * @return invoice id
     */
    public int createInvoice(Invoice inv, List<InvoiceDetail> details) throws SQLException {
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                int invoiceId;
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO Invoice(code, customerId, accountId, totalAmount, status) VALUES (?, ?, ?, ?, ?)",
                        PreparedStatement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, inv.getCode());
                    ps.setInt(2, inv.getCustomerId());
                    ps.setInt(3, inv.getAccountId());
                    ps.setBigDecimal(4, inv.getTotalAmount() == null ? BigDecimal.ZERO : inv.getTotalAmount());
                    ps.setString(5, inv.getStatus() == null ? "PENDING" : inv.getStatus());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        invoiceId = keys.getInt(1);
                    }
                }
                if (details != null) {
                    try (PreparedStatement ps = c.prepareStatement(
                            "INSERT INTO InvoiceDetail(invoiceId, productId, quantity, unitPrice) VALUES (?, ?, ?, ?)")) {
                        for (InvoiceDetail d : details) {
                            ps.setInt(1, invoiceId);
                            ps.setInt(2, d.getProductId());
                            ps.setInt(3, d.getQuantity());
                            ps.setBigDecimal(4, d.getUnitPrice());
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }
                c.commit();
                return invoiceId;
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public int updateStatus(int id, String status) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE Invoice SET status = ? WHERE id = ?")) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM Invoice WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    public static String nextCode() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        return String.format("HD-%s-%03d",
                now.format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd")),
                (int) (now.getSecond() % 1000));
    }

    private List<Invoice> queryInvoices(String sql, SqlBinder binder) throws SQLException {
        List<Invoice> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (binder != null) binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice i = new Invoice();
                    i.setId(rs.getInt("id"));
                    i.setCode(rs.getString("code"));
                    i.setCustomerId(rs.getInt("customerId"));
                    i.setCustomerName(rs.getString("customerName"));
                    i.setAccountId(rs.getInt("accountId"));
                    i.setAccountName(rs.getString("accountName"));
                    i.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    i.setStatus(rs.getString("status"));
                    list.add(i);
                }
            }
        }
        return list;
    }

    @FunctionalInterface
    private interface SqlBinder { void bind(PreparedStatement ps) throws SQLException; }
}

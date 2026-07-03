package dao;

import model.Customer;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public List<Customer> findAll() throws SQLException {
        return query("SELECT id, fullname, phone, email, address FROM Customer ORDER BY id DESC", null);
    }

    public List<Customer> search(String keyword) throws SQLException {
        if (keyword == null || keyword.isBlank()) return findAll();
        String sql = "SELECT id, fullname, phone, email, address FROM Customer " +
                "WHERE fullname LIKE ? OR phone LIKE ? OR email LIKE ? ORDER BY id DESC";
        return query(sql, ps -> {
            String like = "%" + keyword.trim() + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
        });
    }

    public Customer findById(int id) throws SQLException {
        String sql = "SELECT id, fullname, phone, email, address FROM Customer WHERE id = ?";
        List<Customer> list = query(sql, ps -> ps.setInt(1, id));
        return list.isEmpty() ? null : list.get(0);
    }

    public int insert(Customer c) throws SQLException {
        String sql = "INSERT INTO Customer(fullname, phone, email, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullname());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            return ps.executeUpdate();
        }
    }

    public int update(Customer c) throws SQLException {
        String sql = "UPDATE Customer SET fullname = ?, phone = ?, email = ?, address = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullname());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            ps.setInt(5, c.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM Customer WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    public int count() throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Customer");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Customer> query(String sql, SqlBinder binder) throws SQLException {
        List<Customer> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (binder != null) binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Customer(
                            rs.getInt("id"),
                            rs.getString("fullname"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("address")
                    ));
                }
            }
        }
        return list;
    }

    @FunctionalInterface
    private interface SqlBinder { void bind(PreparedStatement ps) throws SQLException; }
}

package dao;

import model.Product;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String SELECT_JOIN =
        "SELECT p.id, p.name, p.categoryId, c.name AS categoryName, p.price, p.quantity, " +
        "p.material, p.image, p.description, p.createdAt " +
        "FROM Product p LEFT JOIN Category c ON c.id = p.categoryId ";

    public List<Product> findAll() throws SQLException {
        return query(SELECT_JOIN + " ORDER BY p.id DESC", null);
    }

    public List<Product> searchByName(String keyword) throws SQLException {
        if (keyword == null || keyword.isBlank()) return findAll();
        return query(SELECT_JOIN + " WHERE p.name LIKE ? OR p.material LIKE ? ORDER BY p.id DESC", ps -> {
            String like = "%" + keyword.trim() + "%";
            ps.setString(1, like);
            ps.setString(2, like);
        });
    }

    public List<Product> findByCategory(int categoryId) throws SQLException {
        return query(SELECT_JOIN + " WHERE p.categoryId = ? ORDER BY p.id DESC", ps -> ps.setInt(1, categoryId));
    }

    public Product findById(int id) throws SQLException {
        List<Product> list = query(SELECT_JOIN + " WHERE p.id = ?", ps -> ps.setInt(1, id));
        return list.isEmpty() ? null : list.get(0);
    }

    public int insert(Product p) throws SQLException {
        String sql = "INSERT INTO Product(name, categoryId, price, quantity, material, image, description) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getCategoryId());
            ps.setBigDecimal(3, p.getPrice() == null ? BigDecimal.ZERO : p.getPrice());
            ps.setInt(4, p.getQuantity());
            ps.setString(5, p.getMaterial());
            ps.setString(6, p.getImage());
            ps.setString(7, p.getDescription());
            return ps.executeUpdate();
        }
    }

    public int update(Product p) throws SQLException {
        String sql = "UPDATE Product SET name = ?, categoryId = ?, price = ?, quantity = ?, " +
                "material = ?, image = ?, description = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getCategoryId());
            ps.setBigDecimal(3, p.getPrice() == null ? BigDecimal.ZERO : p.getPrice());
            ps.setInt(4, p.getQuantity());
            ps.setString(5, p.getMaterial());
            ps.setString(6, p.getImage());
            ps.setString(7, p.getDescription());
            ps.setInt(8, p.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM Product WHERE id = ?")) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    public int count() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM Product");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Product> query(String sql, SqlBinder binder) throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (binder != null) binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setCategoryId(rs.getInt("categoryId"));
                    p.setCategoryName(rs.getString("categoryName"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setQuantity(rs.getInt("quantity"));
                    p.setMaterial(rs.getString("material"));
                    p.setImage(rs.getString("image"));
                    p.setDescription(rs.getString("description"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    @FunctionalInterface
    private interface SqlBinder { void bind(PreparedStatement ps) throws SQLException; }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Account;
import util.DBConnection;

/**
 * Truy cập dữ liệu cho bảng Account. Tất cả câu lệnh dùng PreparedStatement.
 */
public class AccountDAO {

    /** Tìm tài khoản theo username + password (dùng cho chức năng đăng nhập). */
    public Account login(String username, String password) throws SQLException {
        final String sql = "SELECT id, username, password, fullname, role, active FROM Account " +
                "WHERE username = ? AND password = ? AND active = 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    /** Tìm tài khoản theo id. */
    public Account findById(int id) throws SQLException {
        final String sql = "SELECT id, username, password, fullname, role, active FROM Account WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    /** Lấy tất cả tài khoản (cho trang quản lý). */
    public List<Account> findAll() throws SQLException {
        final String sql = "SELECT id, username, password, fullname, role, active FROM Account ORDER BY id DESC";
        List<Account> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /** Thêm tài khoản mới. Trả về số dòng affected. */
    public int insert(Account a) throws SQLException {
        final String sql = "INSERT INTO Account(username, password, fullname, role, active) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getUsername());
            ps.setString(2, a.getPassword());
            ps.setString(3, a.getFullname());
            ps.setString(4, a.getRole());
            ps.setBoolean(5, a.isActive());
            return ps.executeUpdate();
        }
    }

    /** Cập nhật tài khoản (không đổi mật khẩu nếu password null/empty). */
    public int update(Account a) throws SQLException {
        final String sql = "UPDATE Account SET username = ?, fullname = ?, role = ?, active = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getUsername());
            ps.setString(2, a.getFullname());
            ps.setString(3, a.getRole());
            ps.setBoolean(4, a.isActive());
            ps.setInt(5, a.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        final String sql = "DELETE FROM Account WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    private Account map(ResultSet rs) throws SQLException {
        return new Account(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("fullname"),
                rs.getString("role"),
                rs.getBoolean("active")
        );
    }
}

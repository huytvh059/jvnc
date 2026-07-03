package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton cho kết nối SQL Server.
 * Cấu hình theo slide bài giảng: server=localhost, user=sa, password=123456, port=1433.
 */
public class DBConnection {

    private static final String URL =
        "jdbc:sqlserver://localhost:1433;databaseName=WoodFurnitureDB;encrypt=false;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASSWORD = "123456";

    private static volatile Connection shared;

    private DBConnection() {}

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Không tìm thấy mssql-jdbc driver. Kiểm tra file .jar đã có trong WEB-INF/lib hay chưa.", e);
        }
    }

    /** Trả về một Connection mới mỗi lần gọi (DAO sẽ tự đóng). Ưu tiên an toàn hơn Singleton. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /** (Tùy chọn) Reusable connection — chỉ dùng khi test nhanh. */
    public static Connection getShared() throws SQLException {
        if (shared == null || shared.isClosed()) {
            synchronized (DBConnection.class) {
                if (shared == null || shared.isClosed()) {
                    shared = DriverManager.getConnection(URL, USER, PASSWORD);
                }
            }
        }
        return shared;
    }

    public static void close(AutoCloseable... cs) {
        for (AutoCloseable c : cs) {
            if (c != null) {
                try { c.close(); } catch (Exception ignored) {}
            }
        }
    }

    /** Test connection, dùng cho init hoặc healthcheck. */
    public static boolean test() {
        try (Connection c = getConnection()) {
            return c != null && !c.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}

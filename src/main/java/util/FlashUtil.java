package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.sql.SQLException;

/**
 * Helper cho flash message (success/error) qua session.
 * Kèm mapper SQLException -> message thân thiện (FK constraint, v.v.).
 */
public final class FlashUtil {

    public static final String FLASH_OK = "flash";
    public static final String FLASH_ERR = "flashError";

    private FlashUtil() {}

    public static void success(HttpServletRequest req, String msg) {
        session(req).setAttribute(FLASH_OK, msg);
    }

    public static void error(HttpServletRequest req, String msg) {
        session(req).setAttribute(FLASH_ERR, msg);
    }

    /** Ghi log SQL exception server-side, trả message an toàn cho client. */
    public static String friendlyMessage(SQLException e) {
        String raw = e.getMessage() == null ? "" : e.getMessage();
        String low = raw.toLowerCase();
        if (low.contains("reference constraint")
                || low.contains("fk__")
                || low.contains("conflicted with the reference")) {
            return "Không thể xóa: bản ghi đang được tham chiếu bởi dữ liệu khác.";
        }
        if (low.contains("duplicate") || low.contains("unique") || low.contains("cannot insert duplicate")) {
            return "Dữ liệu đã tồn tại (trùng khóa duy nhất).";
        }
        if (low.contains("cannot insert null") || low.contains("null")) {
            return "Thiếu dữ liệu bắt buộc.";
        }
        if (low.contains("timeout") || low.contains("connection")) {
            return "Không kết nối được CSDL. Vui lòng thử lại.";
        }
        // Mặc định: che message, chỉ báo lỗi chung
        return "Thao tác thất bại. Vui lòng thử lại.";
    }

    public static String friendlyMessage(SQLException e, String fallbackWhenEmpty) {
        String m = friendlyMessage(e);
        return (m == null || m.isBlank()) ? fallbackWhenEmpty : m;
    }

    private static HttpSession session(HttpServletRequest req) {
        return req.getSession(true);
    }
}

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<aside class="sidebar">
    <h2>🪑 Wood Furniture</h2>
    <a href="${ctx}/dashboard" class="${active=='dashboard' ? 'active' : ''}">🏠 Tổng quan</a>
    <a href="${ctx}/products"   class="${active=='products'   ? 'active' : ''}">📦 Sản phẩm</a>
    <a href="${ctx}/categories" class="${active=='categories' ? 'active' : ''}">🗂️ Danh mục</a>
    <a href="${ctx}/customers"  class="${active=='customers'  ? 'active' : ''}">👥 Khách hàng</a>
    <a href="${ctx}/invoices"   class="${active=='invoices'   ? 'active' : ''}">🧾 Hóa đơn</a>
    <c:if test="${sessionScope.user.role == 'admin'}">
        <a href="${ctx}/accounts" class="${active=='accounts' ? 'active' : ''}">🔐 Tài khoản</a>
    </c:if>
    <a href="${ctx}/logout" style="margin-top:24px;color:#fca5a5;">🚪 Đăng xuất</a>
</aside>

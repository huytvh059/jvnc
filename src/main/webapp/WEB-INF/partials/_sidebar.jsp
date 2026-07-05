<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<aside class="sidebar" id="sidebar">
    <div class="sidebar__brand">
        <div class="sidebar__brand-mark">🪑</div>
        <div class="sidebar__brand-text">
            <div class="sidebar__brand-name">Woodera</div>
            <div class="sidebar__brand-tag">Furniture Admin</div>
        </div>
    </div>

    <nav class="sidebar__nav">
        <a href="${ctx}/dashboard" class="${active=='dashboard' ? 'active' : ''}">
            <span class="nav-icon">🏠</span> Tổng quan
        </a>
        <a href="${ctx}/products" class="${active=='products' ? 'active' : ''}">
            <span class="nav-icon">📦</span> Sản phẩm
        </a>
        <a href="${ctx}/categories" class="${active=='categories' ? 'active' : ''}">
            <span class="nav-icon">🗂️</span> Danh mục
        </a>
        <a href="${ctx}/customers" class="${active=='customers' ? 'active' : ''}">
            <span class="nav-icon">👥</span> Khách hàng
        </a>
        <a href="${ctx}/invoices" class="${active=='invoices' ? 'active' : ''}">
            <span class="nav-icon">🧾</span> Hóa đơn
        </a>
        <c:if test="${sessionScope.user.role == 'admin'}">
            <a href="${ctx}/accounts" class="${active=='accounts' ? 'active' : ''}">
                <span class="nav-icon">🔐</span> Tài khoản
            </a>
        </c:if>
    </nav>

    <div class="sidebar__footer">
        <a href="${ctx}/logout" class="sidebar__logout">
            <span class="nav-icon">🚪</span> Đăng xuất
        </a>
    </div>
</aside>
<script>
    // Mobile menu toggle
    (function () {
        var btn = document.querySelector('.menu-toggle');
        var sb  = document.getElementById('sidebar');
        if (!btn || !sb) return;
        btn.addEventListener('click', function () {
            sb.classList.toggle('is-open');
        });
        document.addEventListener('click', function (e) {
            if (window.innerWidth > 980) return;
            if (!sb.classList.contains('is-open')) return;
            if (sb.contains(e.target) || btn.contains(e.target)) return;
            sb.classList.remove('is-open');
        });
    })();
</script>

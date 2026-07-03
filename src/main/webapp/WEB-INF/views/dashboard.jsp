<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tổng quan" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="stat-grid">
    <a class="stat-card" href="${pageContext.request.contextPath}/products">
        <div class="label">Sản phẩm</div>
        <div class="value">${productCount != null ? productCount : 0}</div>
        <div class="more">Quản lý →</div>
    </a>
    <a class="stat-card" href="${pageContext.request.contextPath}/categories">
        <div class="label">Danh mục</div>
        <div class="value">${categoryCount != null ? categoryCount : 0}</div>
        <div class="more">Quản lý →</div>
    </a>
    <a class="stat-card" href="${pageContext.request.contextPath}/customers">
        <div class="label">Khách hàng</div>
        <div class="value">${customerCount != null ? customerCount : 0}</div>
        <div class="more">Quản lý →</div>
    </a>
    <a class="stat-card" href="${pageContext.request.contextPath}/invoices">
        <div class="label">Đơn hàng hôm nay</div>
        <div class="value">${todayInvoices != null ? todayInvoices : 0}</div>
        <div class="more">Quản lý →</div>
    </a>
</div>

<div class="card">
    <h3>Doanh thu hôm nay</h3>
    <div style="font-size:32px;font-weight:700;color:var(--primary);">
        <fmt:formatNumber value="${todayRevenue != null ? todayRevenue : 0}" pattern="#,##0"/> ₫
    </div>
    <p class="muted">Chỉ tính các hóa đơn đã hoàn thành (DONE).</p>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

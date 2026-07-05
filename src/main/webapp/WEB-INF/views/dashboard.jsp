<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tổng quan" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="stat-grid">
    <a class="stat-card stat-card--products" href="${pageContext.request.contextPath}/products">
        <div class="stat-card__icon" aria-hidden="true">📦</div>
        <div class="label">Sản phẩm</div>
        <div class="value">${productCount != null ? productCount : 0}</div>
        <div class="more">Quản lý sản phẩm</div>
    </a>
    <a class="stat-card stat-card--categories" href="${pageContext.request.contextPath}/categories">
        <div class="stat-card__icon" aria-hidden="true">🗂️</div>
        <div class="label">Danh mục</div>
        <div class="value">${categoryCount != null ? categoryCount : 0}</div>
        <div class="more">Quản lý danh mục</div>
    </a>
    <a class="stat-card stat-card--customers" href="${pageContext.request.contextPath}/customers">
        <div class="stat-card__icon" aria-hidden="true">👥</div>
        <div class="label">Khách hàng</div>
        <div class="value">${customerCount != null ? customerCount : 0}</div>
        <div class="more">Quản lý khách hàng</div>
    </a>
    <a class="stat-card stat-card--invoices" href="${pageContext.request.contextPath}/invoices">
        <div class="stat-card__icon" aria-hidden="true">🧾</div>
        <div class="label">Đơn hàng hôm nay</div>
        <div class="value">${todayInvoices != null ? todayInvoices : 0}</div>
        <div class="more">Xem hóa đơn</div>
    </a>
</div>

<div class="revenue-card">
    <div>
        <h3>Doanh thu hôm nay</h3>
        <div class="revenue-card__value">
            <fmt:formatNumber value="${todayRevenue != null ? todayRevenue : 0}" pattern="#,##0"/> ₫
        </div>
        <p>Chỉ tính các hóa đơn đã hoàn thành (DONE).</p>
    </div>
    <div class="revenue-card__icon" aria-hidden="true">💰</div>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

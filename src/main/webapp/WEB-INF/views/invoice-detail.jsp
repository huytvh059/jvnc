<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chi tiết hóa đơn ${inv.code}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Hóa đơn ${inv.code}</h2>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/invoices">← Danh sách</a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card" style="margin-top:0;">
    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:16px;">
        <div><label>Khách hàng</label><div>${inv.customerName}</div></div>
        <div><label>Người tạo</label><div>${inv.accountName}</div></div>
        <div><label>Trạng thái</label>
            <div>
                <c:choose>
                    <c:when test="${inv.status == 'DONE'}"><span style="color:#16a34a;font-weight:600;">Hoàn thành</span></c:when>
                    <c:when test="${inv.status == 'CANCEL'}"><span style="color:#dc2626;font-weight:600;">Đã hủy</span></c:when>
                    <c:otherwise><span style="color:#d97706;font-weight:600;">Chờ xử lý</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div><label>Tổng tiền</label>
            <div style="font-size:20px;font-weight:700;color:var(--primary);"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/> ₫</div>
        </div>
    </div>

    <c:if test="${sessionScope.user.role == 'admin'}">
        <div style="margin-top:18px;display:flex;gap:8px;">
            <a class="btn btn-sm" style="background:#16a34a;color:#fff;" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=DONE">Hoàn thành</a>
            <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=CANCEL">Hủy đơn</a>
            <a class="btn btn-sm" style="background:#0ea5e9;color:#fff;" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=PENDING">Đặt về chờ</a>
        </div>
    </c:if>
</div>

<div class="card">
    <h3>Sản phẩm trong đơn</h3>
    <table class="tbl">
        <thead>
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th>Đơn giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="d" items="${details}" varStatus="vs">
                <tr>
                    <td>${vs.count}</td>
                    <td>${d.productName}</td>
                    <td><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/> ₫</td>
                    <td>${d.quantity}</td>
                    <td><b><fmt:formatNumber value="${d.lineTotal}" pattern="#,##0"/> ₫</b></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

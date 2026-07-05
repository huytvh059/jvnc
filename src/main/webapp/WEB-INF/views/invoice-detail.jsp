<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chi tiết hóa đơn ${inv.code}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">Hóa đơn ${inv.code}</h2>
        <div class="page-header__sub">Chi tiết sản phẩm và trạng thái</div>
    </div>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/invoices">
        <span aria-hidden="true">←</span> Danh sách
    </a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card">
    <div class="info-grid">
        <div class="info-item">
            <label>Khách hàng</label>
            <div class="info-value">${inv.customerName}</div>
        </div>
        <div class="info-item">
            <label>Người tạo</label>
            <div class="info-value">${inv.accountName}</div>
        </div>
        <div class="info-item">
            <label>Trạng thái</label>
            <div class="info-value">
                <c:choose>
                    <c:when test="${inv.status == 'DONE'}"><span class="badge badge--done">Hoàn thành</span></c:when>
                    <c:when test="${inv.status == 'CANCEL'}"><span class="badge badge--cancel">Đã hủy</span></c:when>
                    <c:otherwise><span class="badge badge--pending">Chờ xử lý</span></c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="info-item">
            <label>Tổng tiền</label>
            <div class="info-value info-value--money"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/> ₫</div>
        </div>
    </div>

    <c:if test="${sessionScope.user.role == 'admin'}">
        <div class="btn-row" style="margin-top:20px;">
            <a class="btn btn-success btn-sm" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=DONE">Hoàn thành</a>
            <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=CANCEL">Hủy đơn</a>
            <a class="btn btn-info btn-sm" href="${pageContext.request.contextPath}/invoices?action=status&id=${inv.id}&status=PENDING">Đặt về chờ</a>
        </div>
    </c:if>
</div>

<div class="card card--flat" style="padding:0;">
    <div style="padding:18px 26px 8px;border-bottom:1px solid var(--line-soft);">
        <h3 style="margin:0;">Sản phẩm trong đơn</h3>
    </div>
    <div class="table-wrap">
        <table class="tbl">
            <thead>
                <tr>
                    <th style="width:60px;">#</th>
                    <th>Sản phẩm</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${details}" varStatus="vs">
                    <tr>
                        <td class="col-id">${vs.count}</td>
                        <td><b>${d.productName}</b></td>
                        <td class="col-money"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/> ₫</td>
                        <td>${d.quantity}</td>
                        <td class="col-money"><b><fmt:formatNumber value="${d.lineTotal}" pattern="#,##0"/> ₫</b></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

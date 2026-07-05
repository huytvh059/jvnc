<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Hóa đơn" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">Hóa đơn</h2>
        <div class="page-header__sub">Theo dõi và quản lý đơn hàng</div>
    </div>
    <a class="btn btn-primary btn--pill" href="${pageContext.request.contextPath}/invoices?action=new">
        <span aria-hidden="true">＋</span> Tạo hóa đơn
    </a>
</div>

<form method="get" action="${pageContext.request.contextPath}/invoices" class="filter-bar">
    <label>Từ</label>
    <input type="date" name="from" value="<c:out value='${from}'/>"/>
    <label>Đến</label>
    <input type="date" name="to" value="<c:out value='${to}'/>"/>
    <button type="submit" class="btn btn-primary btn--pill btn-sm">Lọc</button>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/invoices">Xóa lọc</a>
</form>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card card--flat" style="padding:0;">
    <div class="table-wrap">
        <table class="tbl">
            <thead>
                <tr>
                    <th>Mã HĐ</th>
                    <th>Khách hàng</th>
                    <th>Người tạo</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th style="width:200px;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td colspan="6">
                            <div class="empty-state">
                                <div class="empty-state__icon">🧾</div>
                                <p class="empty-state__title">Chưa có hóa đơn nào</p>
                                <p class="empty-state__sub">Bấm "Tạo hóa đơn" để bắt đầu.</p>
                            </div>
                        </td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="i" items="${list}">
                            <tr>
                                <td><b>${i.code}</b></td>
                                <td>${i.customerName}</td>
                                <td>${i.accountName}</td>
                                <td class="col-money"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/> ₫</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${i.status == 'DONE'}"><span class="badge badge--done">Hoàn thành</span></c:when>
                                        <c:when test="${i.status == 'CANCEL'}"><span class="badge badge--cancel">Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge badge--pending">Chờ xử lý</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-row">
                                        <a class="btn btn-xs btn-info" href="${pageContext.request.contextPath}/invoices?action=view&id=${i.id}">Xem</a>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                            <form method="post" style="display:inline;" onsubmit="return confirm('Xóa hóa đơn ${i.code}?');" action="${pageContext.request.contextPath}/invoices">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="id" value="${i.id}"/>
                                                <button type="submit" class="btn btn-xs btn-danger">Xóa</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

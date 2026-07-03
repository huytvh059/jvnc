<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Hóa đơn" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Hóa đơn</h2>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/invoices?action=new">+ Tạo hóa đơn</a>
</div>

<form method="get" action="${pageContext.request.contextPath}/invoices" class="filter-bar">
    <label style="margin:0;">Từ</label>
    <input type="date" name="from" value="<c:out value='${from}'/>"/>
    <label style="margin:0;">Đến</label>
    <input type="date" name="to" value="<c:out value='${to}'/>"/>
    <button type="submit" class="btn btn-primary">Lọc</button>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/invoices">Xóa lọc</a>
</form>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card" style="margin-top:0;">
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
                    <tr><td colspan="6" style="text-align:center;color:#64748b;padding:24px;">Chưa có hóa đơn nào.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="i" items="${list}">
                        <tr>
                            <td><b>${i.code}</b></td>
                            <td>${i.customerName}</td>
                            <td>${i.accountName}</td>
                            <td><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/> ₫</td>
                            <td>
                                <c:choose>
                                    <c:when test="${i.status == 'DONE'}"><span style="color:#16a34a;font-weight:600;">Hoàn thành</span></c:when>
                                    <c:when test="${i.status == 'CANCEL'}"><span style="color:#dc2626;font-weight:600;">Đã hủy</span></c:when>
                                    <c:otherwise><span style="color:#d97706;font-weight:600;">Chờ xử lý</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-edit" href="${pageContext.request.contextPath}/invoices?action=view&id=${i.id}">Xem</a>
                                <c:if test="${sessionScope.user.role == 'admin'}">
                                    <form method="post" style="display:inline;" onsubmit="return confirm('Xóa hóa đơn ${i.code}?');" action="${pageContext.request.contextPath}/invoices">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${i.id}"/>
                                        <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Khách hàng" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">Khách hàng</h2>
        <div class="page-header__sub">Danh sách khách hàng đã đăng ký</div>
    </div>
    <a class="btn btn-primary btn--pill" href="${pageContext.request.contextPath}/customers?action=new">
        <span aria-hidden="true">＋</span> Thêm khách hàng
    </a>
</div>

<form method="get" action="${pageContext.request.contextPath}/customers" class="filter-bar">
    <input type="text" name="q" value="<c:out value='${q}'/>" placeholder="🔍  Tìm theo tên / SĐT / email..."/>
    <button type="submit" class="btn btn-primary btn--pill btn-sm">Tìm kiếm</button>
</form>

<c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-danger">${sessionScope.flashError}</div>
    <c:remove var="flashError" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card card--flat" style="padding:0;">
    <div class="table-wrap">
        <table class="tbl">
            <thead>
                <tr>
                    <th style="width:70px;">ID</th>
                    <th>Họ tên</th>
                    <th>Số điện thoại</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
                    <th style="width:200px;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td colspan="6">
                            <div class="empty-state">
                                <div class="empty-state__icon">👥</div>
                                <p class="empty-state__title">Chưa có khách hàng nào</p>
                                <p class="empty-state__sub">Bấm "Thêm khách hàng" để tạo mới.</p>
                            </div>
                        </td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${list}">
                            <tr>
                                <td class="col-id">#${c.id}</td>
                                <td><b>${c.fullname}</b></td>
                                <td>${c.phone}</td>
                                <td>${c.email}</td>
                                <td>${c.address}</td>
                                <td>
                                    <div class="btn-row">
                                        <a class="btn btn-xs btn-info" href="${pageContext.request.contextPath}/customers?action=edit&id=${c.id}">Sửa</a>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                            <form method="post" style="display:inline;" onsubmit="return confirm('Xóa khách hàng ${c.fullname}?');" action="${pageContext.request.contextPath}/customers">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="id" value="${c.id}"/>
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

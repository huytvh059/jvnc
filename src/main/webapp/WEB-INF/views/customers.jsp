<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Khách hàng" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Khách hàng</h2>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/customers?action=new">+ Thêm khách hàng</a>
</div>

<form method="get" action="${pageContext.request.contextPath}/customers" class="filter-bar">
    <input type="text" name="q" value="<c:out value='${q}'/>" placeholder="Tìm theo tên / SĐT / email" style="flex:1;min-width:200px;"/>
    <button type="submit" class="btn btn-primary">Tìm</button>
</form>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card" style="margin-top:0;">
    <table class="tbl">
        <thead>
            <tr>
                <th style="width:60px;">ID</th>
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
                    <tr><td colspan="6" style="text-align:center;color:#64748b;padding:24px;">Chưa có khách hàng nào.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="c" items="${list}">
                        <tr>
                            <td>#${c.id}</td>
                            <td><b>${c.fullname}</b></td>
                            <td>${c.phone}</td>
                            <td>${c.email}</td>
                            <td>${c.address}</td>
                            <td>
                                <a class="btn btn-sm btn-edit" href="${pageContext.request.contextPath}/customers?action=edit&id=${c.id}">Sửa</a>
                                <c:if test="${sessionScope.user.role == 'admin'}">
                                    <form method="post" style="display:inline;" onsubmit="return confirm('Xóa khách hàng ${c.fullname}?');" action="${pageContext.request.contextPath}/customers">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${c.id}"/>
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

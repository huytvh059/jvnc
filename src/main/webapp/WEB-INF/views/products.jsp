<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Sản phẩm" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Sản phẩm</h2>
    <c:if test="${sessionScope.user.role == 'admin'}">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/products?action=new">+ Thêm sản phẩm</a>
    </c:if>
</div>

<c:if test="${sessionScope.user.role != 'admin'}">
    <div class="alert alert-warning">Bạn đang đăng nhập với quyền <b>staff</b> — chỉ xem.</div>
</c:if>

<form method="get" action="${pageContext.request.contextPath}/products" class="filter-bar">
    <input type="text" name="q" value="<c:out value='${q}'/>" placeholder="Tìm theo tên / chất liệu" style="flex:1;min-width:200px;"/>
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
                <th>Tên sản phẩm</th>
                <th>Danh mục</th>
                <th>Giá</th>
                <th>SL</th>
                <th>Chất liệu</th>
                <th style="width:200px;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr><td colspan="7" style="text-align:center;color:#64748b;padding:24px;">Chưa có sản phẩm nào.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${list}">
                        <tr>
                            <td>#${p.id}</td>
                            <td><b>${p.name}</b></td>
                            <td>${p.categoryName}</td>
                            <td><fmt:formatNumber value="${p.price}" pattern="#,##0"/> ₫</td>
                            <td>${p.quantity}</td>
                            <td>${p.material}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'admin'}">
                                        <a class="btn btn-sm btn-edit" href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}">Sửa</a>
                                        <form method="post" style="display:inline;" onsubmit="return confirm('Xóa sản phẩm ${p.name}?');" action="${pageContext.request.contextPath}/products">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="id" value="${p.id}"/>
                                            <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise><span class="muted">—</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

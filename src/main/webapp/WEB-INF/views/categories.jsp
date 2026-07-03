<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Danh mục" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Danh mục sản phẩm</h2>
    <c:if test="${sessionScope.user.role == 'admin'}">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/categories?action=new">+ Thêm danh mục</a>
    </c:if>
</div>

<c:if test="${sessionScope.user.role != 'admin'}">
    <div class="alert alert-warning">Bạn đang đăng nhập với quyền <b>staff</b> — chỉ xem.</div>
</c:if>
<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-success">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<div class="card" style="margin-top:0;">
    <table class="tbl">
        <thead>
            <tr>
                <th style="width:60px;">ID</th>
                <th>Tên danh mục</th>
                <th>Mô tả</th>
                <th style="width:200px;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr><td colspan="4" style="text-align:center;color:#64748b;padding:24px;">Chưa có danh mục nào.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="c" items="${list}">
                        <tr>
                            <td>#${c.id}</td>
                            <td><b>${c.name}</b></td>
                            <td>${c.description}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'admin'}">
                                        <a class="btn btn-sm btn-edit" href="${pageContext.request.contextPath}/categories?action=edit&id=${c.id}">Sửa</a>
                                        <form method="post" style="display:inline;" onsubmit="return confirm('Xóa danh mục ${c.name}?');" action="${pageContext.request.contextPath}/categories">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="id" value="${c.id}"/>
                                            <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="muted">—</span>
                                    </c:otherwise>
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

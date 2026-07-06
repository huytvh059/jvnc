<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Danh mục" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">Danh mục sản phẩm</h2>
        <div class="page-header__sub">Phân loại sản phẩm theo nhóm</div>
    </div>
    <c:if test="${sessionScope.user.role == 'admin'}">
        <a class="btn btn-primary btn--pill" href="${pageContext.request.contextPath}/categories?action=new">
            <span aria-hidden="true">＋</span> Thêm danh mục
        </a>
    </c:if>
</div>

<c:if test="${sessionScope.user.role != 'admin'}">
    <div class="alert alert-warning">Bạn đang đăng nhập với quyền <b>staff</b> — chỉ xem.</div>
</c:if>
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
                    <th>Tên danh mục</th>
                    <th>Mô tả</th>
                    <th style="width:200px;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td colspan="4">
                            <div class="empty-state">
                                <div class="empty-state__icon">🗂️</div>
                                <p class="empty-state__title">Chưa có danh mục nào</p>
                                <p class="empty-state__sub">Bấm "Thêm danh mục" để tạo mới.</p>
                            </div>
                        </td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${list}">
                            <tr>
                                <td class="col-id">#${c.id}</td>
                                <td><b>${c.name}</b></td>
                                <td>${c.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.role == 'admin'}">
                                            <div class="btn-row">
                                                <a class="btn btn-xs btn-info" href="${pageContext.request.contextPath}/categories?action=edit&id=${c.id}">Sửa</a>
                                                <form method="post" style="display:inline;" onsubmit="return confirm('Xóa danh mục ${c.name}?');" action="${pageContext.request.contextPath}/categories">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="id" value="${c.id}"/>
                                                    <button type="submit" class="btn btn-xs btn-danger">Xóa</button>
                                                </form>
                                            </div>
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
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

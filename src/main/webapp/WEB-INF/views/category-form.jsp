<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa danh mục' : 'Thêm danh mục'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">
            <c:choose>
                <c:when test="${mode=='update'}">Sửa danh mục #${formCategory.id}</c:when>
                <c:otherwise>Thêm danh mục mới</c:otherwise>
            </c:choose>
        </h2>
        <div class="page-header__sub">Phân loại sản phẩm theo nhóm</div>
    </div>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/categories">
        <span aria-hidden="true">←</span> Danh sách
    </a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card card--padded" style="max-width:620px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/categories">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}">
            <input type="hidden" name="id" value="${formCategory.id}"/>
        </c:if>

        <label>Tên danh mục *</label>
        <input type="text" name="name" required maxlength="100" value="<c:out value='${formCategory.name}'/>" placeholder="Bàn ghế, Tủ, Giường..."/>

        <label style="margin-top:14px;">Mô tả</label>
        <textarea name="description" rows="3" maxlength="500"><c:out value='${formCategory.description}'/></textarea>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">💾  Cập nhật</c:when><c:otherwise>✨  Thêm danh mục</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

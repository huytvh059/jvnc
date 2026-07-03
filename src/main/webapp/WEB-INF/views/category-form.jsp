<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa danh mục' : 'Thêm danh mục'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">
        <c:choose>
            <c:when test="${mode=='update'}">Sửa danh mục #${formCategory.id}</c:when>
            <c:otherwise>Thêm danh mục mới</c:otherwise>
        </c:choose>
    </h2>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/categories">← Danh sách</a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="card" style="max-width:560px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/categories">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}">
            <input type="hidden" name="id" value="${formCategory.id}"/>
        </c:if>

        <label>Tên danh mục *</label>
        <input type="text" name="name" required maxlength="100" value="<c:out value='${formCategory.name}'/>"/>

        <label style="margin-top:12px;">Mô tả</label>
        <textarea name="description" rows="3" maxlength="500"><c:out value='${formCategory.description}'/></textarea>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">Cập nhật</c:when><c:otherwise>Thêm mới</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

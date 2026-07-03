<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa khách hàng' : 'Thêm khách hàng'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">
        <c:choose><c:when test="${mode=='update'}">Sửa khách hàng #${form.id}</c:when><c:otherwise>Thêm khách hàng</c:otherwise></c:choose>
    </h2>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/customers">← Danh sách</a>
</div>

<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

<div class="card" style="max-width:560px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/customers">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}"><input type="hidden" name="id" value="${form.id}"/></c:if>

        <label>Họ tên *</label>
        <input type="text" name="fullname" required maxlength="100" value="<c:out value='${form.fullname}'/>"/>

        <label style="margin-top:12px;">Số điện thoại</label>
        <input type="text" name="phone" maxlength="20" value="<c:out value='${form.phone}'/>"/>

        <label style="margin-top:12px;">Email</label>
        <input type="email" name="email" maxlength="100" value="<c:out value='${form.email}'/>"/>

        <label style="margin-top:12px;">Địa chỉ</label>
        <textarea name="address" rows="2" maxlength="255"><c:out value='${form.address}'/></textarea>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">Cập nhật</c:when><c:otherwise>Thêm mới</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

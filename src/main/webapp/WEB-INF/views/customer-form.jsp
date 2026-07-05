<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa khách hàng' : 'Thêm khách hàng'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">
            <c:choose><c:when test="${mode=='update'}">Sửa khách hàng #${form.id}</c:when><c:otherwise>Thêm khách hàng mới</c:otherwise></c:choose>
        </h2>
        <div class="page-header__sub">Thông tin liên hệ của khách hàng</div>
    </div>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/customers">
        <span aria-hidden="true">←</span> Danh sách
    </a>
</div>

<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

<div class="card card--padded" style="max-width:620px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/customers">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}"><input type="hidden" name="id" value="${form.id}"/></c:if>

        <div class="form-grid">
            <div class="full">
                <label>Họ tên *</label>
                <input type="text" name="fullname" required maxlength="100" value="<c:out value='${form.fullname}'/>" placeholder="Nguyễn Văn A"/>
            </div>
            <div>
                <label>Số điện thoại</label>
                <input type="text" name="phone" maxlength="20" value="<c:out value='${form.phone}'/>" placeholder="0901 234 567"/>
            </div>
            <div>
                <label>Email</label>
                <input type="email" name="email" maxlength="100" value="<c:out value='${form.email}'/>" placeholder="email@example.com"/>
            </div>
            <div class="full">
                <label>Địa chỉ</label>
                <textarea name="address" rows="2" maxlength="255"><c:out value='${form.address}'/></textarea>
            </div>
        </div>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">💾  Cập nhật</c:when><c:otherwise>✨  Thêm khách hàng</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

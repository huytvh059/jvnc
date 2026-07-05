<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Đăng nhập" scope="request"/>

<%@include file="/WEB-INF/layout/auth-top.jsp"%>

<div class="auth-card__brand">
    <div class="auth-card__mark">🪑</div>
    <div>
        <h2 class="brand" style="margin-bottom:2px;">Woodera</h2>
        <div class="brand-sub" style="margin:0;">Furniture Admin System</div>
    </div>
</div>

<p class="brand-sub">Đăng nhập để tiếp tục quản trị cửa hàng</p>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<form class="auth-form" method="post" action="${ctx}/login" autocomplete="on">
    <label for="username">Tên đăng nhập</label>
    <input id="username" type="text" name="username" placeholder="admin hoặc staff" required autofocus autocomplete="username">

    <label for="password">Mật khẩu</label>
    <input id="password" type="password" name="password" placeholder="••••••" required autocomplete="current-password">

    <button type="submit" class="btn btn-primary btn-block btn--pill">
        🔐  Đăng nhập
    </button>
</form>

<div class="auth-card__divider">Tài khoản mẫu</div>

<p class="hint">
    <code>admin</code> / <code>123456</code> &nbsp;·&nbsp; quản trị viên<br/>
    <code>staff</code> / <code>123456</code> &nbsp;·&nbsp; nhân viên
</p>

<%@include file="/WEB-INF/layout/auth-bottom.jsp"%>

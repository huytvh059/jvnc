<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="Đăng nhập" scope="request"/>

<%@include file="/WEB-INF/layout/auth-top.jsp"%>

<h2 class="brand">🪑 Wood Furniture</h2>
<p style="color:#64748b;margin-top:0;">Đăng nhập vào hệ thống quản trị</p>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<form class="auth-form" method="post" action="${ctx}/login" style="margin-top:18px;">
    <label for="username">Tên đăng nhập</label>
    <input id="username" type="text" name="username" placeholder="admin" required autofocus>
    <label for="password" style="margin-top:14px;">Mật khẩu</label>
    <input id="password" type="password" name="password" placeholder="••••••" required>
    <button type="submit" class="btn btn-primary btn-block">Đăng nhập</button>
</form>

<p class="hint">
    Tài khoản mẫu: <code>admin</code> / <code>123456</code> (admin) — <code>staff</code> / <code>123456</code> (staff)
</p>

<%@include file="/WEB-INF/layout/auth-bottom.jsp"%>

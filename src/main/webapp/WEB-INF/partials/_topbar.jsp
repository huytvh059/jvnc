<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Topbar có thể dùng chung --%>
<div class="topbar">
    <div class="topbar__left">
        <button type="button" class="menu-toggle" aria-label="Mở menu">☰</button>
        <div>
            <div class="breadcrumb">Woodera <span aria-hidden="true">›</span> <strong>${not empty pageTitle ? pageTitle : 'Tổng quan'}</strong></div>
            <h1 style="margin-top:2px;">${not empty pageTitle ? pageTitle : 'Tổng quan'}</h1>
        </div>
    </div>

    <div class="topbar__right">
        <div class="topbar__search" role="search">
            <span class="icon" aria-hidden="true">🔍</span>
            <input type="text" placeholder="Tìm kiếm nhanh..." aria-label="Tìm kiếm"/>
        </div>
        <div class="user-chip">
            <div class="user-avatar" aria-hidden="true">
                <c:set var="fn" value="${sessionScope.user.fullname}"/>
                <c:out value="${fn != null && fn.length() > 0 ? fn.substring(0,1).toUpperCase() : 'U'}"/>
            </div>
            <span class="user-chip__name"><c:out value="${sessionScope.user.fullname}"/></span>
            <span class="role-badge ${sessionScope.user.role}"><c:out value="${sessionScope.user.role}"/></span>
            <span aria-hidden="true">·</span>
            <a href="${ctx}/logout">Đăng xuất</a>
        </div>
    </div>
</div>

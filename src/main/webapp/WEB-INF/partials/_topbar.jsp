<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%-- Topbar có thể dùng chung --%>
<div class="topbar">
    <h1>${not empty pageTitle ? pageTitle : 'Tổng quan'}</h1>
    <div class="user-chip">
        👤 <c:out value="${sessionScope.user.fullname}"/>
        <span class="role-badge ${sessionScope.user.role}"><c:out value="${sessionScope.user.role}"/></span>
        · <a href="${ctx}/logout" style="color:#dc2626; text-decoration:none;">Đăng xuất</a>
    </div>
</div>

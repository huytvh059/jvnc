<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${not empty pageTitle ? pageTitle : 'Wood Furniture Store'}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
    <jsp:include page="/WEB-INF/partials/_head.jsp" flush="true"/>
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/partials/_sidebar.jsp"/>
    <main class="main">
        <jsp:include page="/WEB-INF/partials/_topbar.jsp"/>

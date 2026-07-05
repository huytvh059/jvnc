<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${not empty pageTitle ? pageTitle : 'Đăng nhập'}"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Đăng nhập vào hệ thống quản trị Woodera - Cửa hàng nội thất gỗ">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css">
</head>
<body class="auth-body">
    <div class="auth-shell">
        <div class="auth-card">

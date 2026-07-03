<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${title} - Wood Furniture Store</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app">
    <jsp:include page="/WEB-INF/views/_sidebar.jsp"/>
    <main class="main">
        <div class="topbar">
            <h1>${title}</h1>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-sm">← Về Dashboard</a>
        </div>
        <div class="card">
            <h3 style="margin-top:0;">Module "${title}" đang được phát triển</h3>
            <p>Module <b>${title}</b> chưa được triển khai trong phiên bản hiện tại. Theo mô hình MVC, bạn sẽ thấy nội dung CRUD sau khi bạn yêu cầu mình dựng module này.</p>
            <p>Các thao tác sẽ có:</p>
            <ul style="line-height:1.9;padding-left:20px;">
                <li>Liệt kê (GET → DAO SELECT → JSP table)</li>
                <li>Thêm (GET form → POST → DAO INSERT)</li>
                <li>Sửa (GET form → POST → DAO UPDATE)</li>
                <li>Xóa (POST → DAO DELETE → redirect list)</li>
            </ul>
        </div>
    </main>
</div>
</body>
</html>

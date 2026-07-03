<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tạo hóa đơn" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">Tạo hóa đơn mới</h2>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/invoices">← Danh sách</a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-danger">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/invoices">
    <input type="hidden" name="action" value="create"/>

    <div class="card" style="max-width:520px;margin-top:0;">
        <label>Khách hàng *</label>
        <select name="customerId" required>
            <option value="">-- Chọn khách hàng --</option>
            <c:forEach var="c" items="${customers}">
                <option value="${c.id}">${c.fullname} <c:if test="${not empty c.phone}">— ${c.phone}</c:if></option>
            </c:forEach>
        </select>
        <a class="btn btn-sm" style="margin-top:8px;display:inline-block;background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/customers?action=new">+ Thêm khách hàng mới</a>
    </div>

    <div class="card">
        <h3>Sản phẩm</h3>
        <table class="tbl" id="productTable">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th style="width:120px;">Số lượng</th>
                    <th style="width:60px;"></th>
                </tr>
            </thead>
            <tbody id="rows">
                <tr class="row">
                    <td>
                        <select name="productId" required>
                            <option value="">-- Chọn sản phẩm --</option>
                        </select>
                    </td>
                    <td><input type="number" name="quantity" min="1" value="1" required/></td>
                    <td><button type="button" class="btn btn-sm btn-danger" data-remove>×</button></td>
                </tr>
            </tbody>
        </table>
        <button type="button" id="btnAdd" class="btn btn-sm btn-primary" style="margin-top:8px;">+ Thêm dòng</button>
    </div>

    <div style="margin-top:16px;text-align:right;">
        <button type="submit" class="btn btn-primary">Lưu hóa đơn</button>
    </div>
</form>

<script>
window.PRODUCTS = JSON.parse('<c:out value="${productJson}" escapeXml="false"/>');
</script>
<script src="${pageContext.request.contextPath}/js/products.js"></script>
<script>
document.getElementById('btnAdd').addEventListener('click', function () {
    const tbody = document.getElementById('rows');
    const tr = document.createElement('tr');
    tr.className = 'row';
    tr.innerHTML =
        '<td><select name="productId" required>' + window.PRODUCT_OPTIONS + '</select></td>' +
        '<td><input type="number" name="quantity" min="1" value="1" required/></td>' +
        '<td><button type="button" class="btn btn-sm btn-danger" data-remove>×</button></td>';
    tbody.appendChild(tr);
});
document.getElementById('rows').addEventListener('click', function (e) {
    if (e.target.matches('[data-remove]')) {
        if (document.querySelectorAll('#rows tr.row').length > 1) e.target.closest('tr').remove();
        else alert('Phải có ít nhất 1 dòng sản phẩm.');
    }
});
</script>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

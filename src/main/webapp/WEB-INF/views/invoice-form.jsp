<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Tạo hóa đơn" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">Tạo hóa đơn mới</h2>
        <div class="page-header__sub">Chọn khách hàng, thêm sản phẩm và số lượng</div>
    </div>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/invoices">
        <span aria-hidden="true">←</span> Danh sách
    </a>
</div>

<c:if test="${not empty sessionScope.flash}">
    <div class="alert alert-danger">${sessionScope.flash}</div>
    <c:remove var="flash" scope="session"/>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/invoices">
    <input type="hidden" name="action" value="create"/>

    <div class="card" style="max-width:560px;margin-top:0;">
        <h3>Khách hàng</h3>
        <label>Khách hàng *</label>
        <select name="customerId" required>
            <option value="">-- Chọn khách hàng --</option>
            <c:forEach var="c" items="${customers}">
                <option value="${c.id}">${c.fullname} <c:if test="${not empty c.phone}">— ${c.phone}</c:if></option>
            </c:forEach>
        </select>
        <a class="btn btn-secondary btn-sm" style="margin-top:10px;display:inline-block;" href="${pageContext.request.contextPath}/customers?action=new">+ Thêm khách hàng mới</a>
    </div>

    <div class="card">
        <h3>Sản phẩm</h3>
        <div class="table-wrap">
            <table class="tbl" id="productTable">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th style="width:140px;">Số lượng</th>
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
                        <td><button type="button" class="btn btn-xs btn-danger" data-remove>×</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <button type="button" id="btnAdd" class="btn btn-primary btn--pill btn-sm" style="margin-top:14px;">+ Thêm dòng</button>
    </div>

    <div style="margin-top:20px;text-align:right;">
        <button type="submit" class="btn btn-primary btn-lg">💾  Lưu hóa đơn</button>
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
        '<td><button type="button" class="btn btn-xs btn-danger" data-remove>×</button></td>';
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

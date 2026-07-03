<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
    <h2 style="margin:0;">
        <c:choose><c:when test="${mode=='update'}">Sửa sản phẩm #${form.id}</c:when><c:otherwise>Thêm sản phẩm mới</c:otherwise></c:choose>
    </h2>
    <a class="btn btn-sm" style="background:#e2e8f0;color:#0f172a;" href="${pageContext.request.contextPath}/products">← Danh sách</a>
</div>

<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

<div class="card" style="max-width:680px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/products">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}"><input type="hidden" name="id" value="${form.id}"/></c:if>

        <label>Tên sản phẩm *</label>
        <input type="text" name="name" required maxlength="200" value="<c:out value='${form.name}'/>"/>

        <label style="margin-top:12px;">Danh mục *</label>
        <select name="categoryId" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach var="c" items="${categories}">
                <option value="${c.id}" <c:if test="${form.categoryId == c.id}">selected</c:if>>${c.name}</option>
            </c:forEach>
        </select>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:12px;">
            <div>
                <label>Giá (₫) *</label>
                <input type="number" name="price" required min="0" step="1000" value="${form.price != null ? form.price : '0'}"/>
            </div>
            <div>
                <label>Số lượng</label>
                <input type="number" name="quantity" min="0" value="${form.quantity != null ? form.quantity : 0}"/>
            </div>
        </div>

        <label style="margin-top:12px;">Chất liệu</label>
        <input type="text" name="material" maxlength="100" value="<c:out value='${form.material}'/>"/>

        <label style="margin-top:12px;">Link hình ảnh (URL)</label>
        <input type="text" name="image" maxlength="500" value="<c:out value='${form.image}'/>"/>

        <label style="margin-top:12px;">Mô tả</label>
        <textarea name="description" rows="3" maxlength="1000"><c:out value='${form.description}'/></textarea>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">Cập nhật</c:when><c:otherwise>Thêm mới</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

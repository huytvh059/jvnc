<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${mode=='update' ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}" scope="request"/>

<%@include file="/WEB-INF/layout/main.jsp"%>

<div class="page-header">
    <div>
        <h2 class="page-header__title">
            <c:choose><c:when test="${mode=='update'}">Sửa sản phẩm #${form.id}</c:when><c:otherwise>Thêm sản phẩm mới</c:otherwise></c:choose>
        </h2>
        <div class="page-header__sub">Điền thông tin chi tiết cho sản phẩm</div>
    </div>
    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/products">
        <span aria-hidden="true">←</span> Danh sách
    </a>
</div>

<c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

<div class="card card--padded" style="max-width:760px;margin-top:0;">
    <form method="post" action="${pageContext.request.contextPath}/products">
        <input type="hidden" name="action" value="${mode}"/>
        <c:if test="${mode=='update'}"><input type="hidden" name="id" value="${form.id}"/></c:if>

        <label>Tên sản phẩm *</label>
        <input type="text" name="name" required maxlength="200" value="<c:out value='${form.name}'/>" placeholder="Bàn gỗ sồi tự nhiên..."/>

        <label style="margin-top:14px;">Danh mục *</label>
        <select name="categoryId" required>
            <option value="">-- Chọn danh mục --</option>
            <c:forEach var="c" items="${categories}">
                <option value="${c.id}" <c:if test="${form.categoryId == c.id}">selected</c:if>>${c.name}</option>
            </c:forEach>
        </select>

        <div class="form-grid" style="margin-top:14px;">
            <div>
                <label>Giá (₫) *</label>
                <input type="number" name="price" required min="0" step="1000" value="${form.price != null ? form.price : '0'}"/>
            </div>
            <div>
                <label>Số lượng</label>
                <input type="number" name="quantity" min="0" value="${form.quantity != null ? form.quantity : 0}"/>
            </div>
            <div class="full">
                <label>Chất liệu</label>
                <input type="text" name="material" maxlength="100" value="<c:out value='${form.material}'/>" placeholder="Gỗ sồi, MDF,..."/>
            </div>
            <div class="full">
                <label>Link hình ảnh (URL)</label>
                <input type="text" name="image" maxlength="500" value="<c:out value='${form.image}'/>" placeholder="https://..."/>
            </div>
            <div class="full">
                <label>Mô tả</label>
                <textarea name="description" rows="3" maxlength="1000"><c:out value='${form.description}'/></textarea>
            </div>
        </div>

        <button type="submit" class="btn btn-primary btn-block">
            <c:choose><c:when test="${mode=='update'}">💾  Cập nhật sản phẩm</c:when><c:otherwise>✨  Thêm sản phẩm mới</c:otherwise></c:choose>
        </button>
    </form>
</div>

<%@include file="/WEB-INF/layout/main-end.jsp"%>

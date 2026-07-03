/**
 * products.js - nhận dữ liệu sản phẩm từ biến toàn cục window.PRODUCTS
 * (được JSP inject qua JSON an toàn).
 *
 * Render lại các <select name="productId"> và lưu template option list
 * vào window.PRODUCT_OPTIONS.
 */
(function () {
    const products = window.PRODUCTS || [];
    let opts = '<option value="">-- Chọn sản phẩm --</option>';
    for (const p of products) {
        const name = String(p.name || '').replace(/[<&>]/g, c => ({'<':'&lt;','&':'&amp;','>':'&gt;'}[c]));
        const price = (p.price || 0).toLocaleString('vi-VN');
        opts += `<option value="${p.id}">${name} — ${price} ₫</option>`;
    }
    window.PRODUCT_OPTIONS = opts;
    document.querySelectorAll('select[name="productId"]').forEach(s => { s.innerHTML = opts; });
})();

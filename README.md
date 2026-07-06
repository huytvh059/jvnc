# WoodFurnitureWeb

Hệ thống quản lý cửa hàng nội thất gỗ — ứng dụng **Java Servlet/JSP** theo mô hình **MVC**, đóng gói **WAR** và triển khai trên **Apache Tomcat 10.1**, sử dụng **MS SQL Server** làm CSDL.

> Đồ án môn học *Java Nâng Cao* — Văn Hiến University (VHU).

---

## Mục lục

- [Tính năng](#tính-năng)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Sơ đồ cấu trúc](#sơ-đồ-cấu-trúc)
- [Luồng MVC](#luồng-mvc)
- [Cài đặt & Chạy](#cài-đặt--chạy)
- [Tài khoản demo](#tài-khoản-demo)
- [Đóng góp](#đóng-góp)

---

## Tính năng

- **Xác thực & phân quyền**: đăng nhập/đăng xuất, filter kiểm tra session + role (`admin`, `staff`).
- **Dashboard**: trang tổng quan sau đăng nhập.
- **Quản lý sản phẩm** (`/products`): CRUD, lọc theo từ khóa, hỗ trợ ảnh, phân loại theo category.
- **Quản lý danh mục** (`/categories`): CRUD danh mục sản phẩm.
- **Quản lý khách hàng** (`/customers`): CRUD thông tin khách hàng.
- **Quản lý hóa đơn** (`/invoices`):
  - Tạo hóa đơn bán hàng với nhiều sản phẩm (invoice details).
  - Xem chi tiết hóa đơn.
  - Lọc theo ngày.
  - Tự động giảm tồn kho khi lập hóa đơn.
- **Flash messaging**: thông báo success/error qua session — server-side log lỗi SQL, client hiển thị message thân thiện (xem [FlashUtil.java](file:///d:/VHU/Tai_Lieu_Hoc_Phan/JAVA_NANG_CAO/WoodFurnitureWeb/src/main/java/util/FlashUtil.java)).
- **UI/UX**:
  - Theme **Warm Crafted Wood** (nâu gỗ + amber + cream).
  - Sidebar + topbar layout dùng chung qua JSP include.
  - Trang login gradient + glass.
  - Micro-animation, hover effects, responsive.

---

## Công nghệ sử dụng

| Layer | Công nghệ |
|---|---|
| **Ngôn ngữ** | Java 17 |
| **Web framework** | Jakarta Servlet 6.0, JSP 3.1 (JSTL 3.0) |
| **Server** | Apache Tomcat 10.1 |
| **CSDL** | Microsoft SQL Server (JDBC 12.6.1) |
| **Build** | Maven (`maven-war-plugin`, `maven-compiler-plugin`) |
| **Frontend** | Vanilla JS + Vanilla CSS (không framework) |
| **Font** | Inter + Plus Jakarta Sans (Google Fonts) |
| **IDE** | Apache NetBeans |

---

## Sơ đồ cấu trúc

```text
WoodFurnitureWeb/
├── pom.xml                         ← Maven config
├── nb-configuration.xml            ← NetBeans project config
├── src/main/java/                  ⬅ BACKEND
│   ├── controller/                 ⬅ Servlet (Controller)
│   │   ├── AuthorizationFilter.java
│   │   ├── LoginServlet.java
│   │   ├── DashboardServlet.java
│   │   ├── ProductServlet.java
│   │   ├── CategoryServlet.java
│   │   ├── CustomerServlet.java
│   │   └── InvoiceServlet.java
│   ├── dao/                        ⬅ Data Access Object
│   │   ├── AccountDAO.java
│   │   ├── CategoryDAO.java
│   │   ├── CustomerDAO.java
│   │   ├── ProductDAO.java
│   │   └── InvoiceDAO.java
│   ├── model/                      ⬅ POJO / Entity
│   │   ├── Account.java
│   │   ├── Category.java
│   │   ├── Customer.java
│   │   ├── Product.java
│   │   ├── Invoice.java
│   │   └── InvoiceDetail.java
│   └── util/
│       ├── DBConnection.java       ← JDBC helper
│       └── FlashUtil.java          ← Flash message + SQL error mapper
│
└── src/main/webapp/                ⬅ FRONTEND
    ├── index.jsp
    ├── css/                        ← base, layout, components, auth, app
    ├── js/
    │   └── products.js
    ├── META-INF/context.xml
    └── WEB-INF/
        ├── web.xml                 ← Welcome file + session-config 30'
        ├── layout/                 ← master layout (main, main-end, auth-top, auth-bottom)
        ├── partials/               ← _head, _sidebar, _topbar
        └── views/                  ← login, dashboard, products, categories,
                                     ← customers, invoices, *-form, *-detail
```

Chi tiết thống kê:

| Layer | Count |
|---|---|
| Servlet + Filter | 7 |
| DAO | 5 |
| Model | 6 |
| Util | 2 |
| JSP view | 12 |
| CSS | 5 |
| JS | 1 |

---

## Luồng MVC

```text
   Browser            Tomcat                App (Servlet Container)
     │                  │                              │
     │ GET /products    │                              │
     │─────────────────▶│  match web.xml / servlet     │
     │                  │─────────────────────────────▶│
     │                  │                              │
     │                  │  AuthorizationFilter         │
     │                  │  (check session + role)      │
     │                  │◀─────────────────────────────│
     │                  │                              │
     │                  │  ProductServlet.doGet()      │
     │                  │  ──▶ ProductDAO.findAll()    │
     │                  │  ──▶ setAttribute("list")    │
     │                  │  ──▶ forward → products.jsp  │
     │                  │◀─────────────────────────────│
     │ HTML (JSTL)      │                              │
     │◀─────────────────│                              │
```

| URL | Servlet | View |
|---|---|---|
| `/login`, `/logout` | LoginServlet | login.jsp |
| `/dashboard` | DashboardServlet | dashboard.jsp |
| `/products` | ProductServlet | products.jsp / product-form.jsp |
| `/categories` | CategoryServlet | categories.jsp / category-form.jsp |
| `/customers` | CustomerServlet | customers.jsp / customer-form.jsp |
| `/invoices` | InvoiceServlet | invoices.jsp / invoice-form.jsp / invoice-detail.jsp |

---

## Cài đặt & Chạy

### Yêu cầu môi trường

- **JDK 17** trở lên
- **Apache Maven 3.8+**
- **Apache Tomcat 10.1**
- **MS SQL Server** (bản Developer / Express đều được)
- **NetBeans IDE** (khuyến nghị) — hoặc IDE bất kỳ hỗ trợ Maven

### Bước 1 — Clone source

```bash
git clone https://github.com/huytvh059/jvnc.git
cd jvnc/WoodFurnitureWeb
```

### Bước 2 — Tạo CSDL

Tạo database trong MS SQL Server (ví dụ `WoodFurnitureDB`), sau đó cập nhật thông tin kết nối trong [DBConnection.java](file:///d:/VHU/Tai_Lieu_Hoc_Phan/JAVA_NANG_CAO/WoodFurnitureWeb/src/main/java/util/DBConnection.java) và [context.xml](file:///d:/VHU/Tai_Lieu_Hoc_Phan/JAVA_NANG_CAO/WoodFurnitureWeb/src/main/webapp/META-INF/context.xml):

```text
URL:      jdbc:sqlserver://localhost:1433;databaseName=WoodFurnitureDB;...
User:     sa (hoặc user của bạn)
Password: ***
```

### Bước 3 — Build & Deploy

```bash
mvn clean package
```

Sau khi build, file `target/WoodFurnitureWeb-1.0-SNAPSHOT.war` được tạo. Copy file này vào thư mục `webapps/` của Tomcat:

```bash
# Windows
copy target\WoodFurnitureWeb-1.0-SNAPSHOT.war %CATALINA_HOME%\webapps\

# hoặc chạy trực tiếp từ NetBeans: Run Project (F6)
```

### Bước 4 — Truy cập

Mở trình duyệt:

```text
http://localhost:8080/WoodFurnitureWeb/
```

→ Tự động redirect tới trang `/login`.

---

## Tài khoản demo

Sau khi tạo CSDL và seed dữ liệu mẫu (xem script SQL đi kèm — `database/` nếu có):

| Username | Password | Role |
|---|---|---|
| `admin` | `admin123` | admin |
| `staff` | `staff123` | staff |

---

## Đóng góp

1. Fork repository.
2. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`.
3. Commit thay đổi: `git commit -m "feat: mo ta ngan"`.
4. Push lên branch: `git push origin feature/ten-tinh-nang`.
5. Tạo Pull Request.

---

## License

Đồ án học tập — Văn Hiến University. Vui lòng liên hệ tác giả trước khi sử dụng cho mục đích thương mại.

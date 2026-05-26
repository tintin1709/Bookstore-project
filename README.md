# Bookstore Management Web Application

A full-stack bookstore management system for the Web Application Development final project. The application follows a clean MVC/layered architecture using Spring Boot, Thymeleaf, Spring Security, JDBC, and MySQL/H2.

## Main features

- User registration, login, logout, profile update, password change.
- Role-based access control: `ADMIN`, `MANAGER`, `STAFF`, `CUSTOMER`.
- CRUD for books, categories, authors, coupons, reservations, orders, and users.
- Advanced search, filtering, sorting, and pagination for book management and catalog browsing.
- Business logic: stock validation, reservation when stock is unavailable, coupon calculation, order workflow, shipment/payment status tracking, and audit logging.
- Advanced features: dashboard charts, notification center, CSV export, audit trail, and inventory transaction history.
- Responsive UI with client-side validation and server-side validation.

## Test accounts

| Role | Email | Password |
|---|---|---|
| Admin | admin@test.com | Admin123! |
| Manager | manager@test.com | Manager123! |
| Staff | staff@test.com | Staff123! |
| Customer | customer@test.com | Customer123! |

## Technology stack

- Java 17
- Spring Boot 3.3.5
- Spring Security + BCrypt
- Thymeleaf
- JDBC Template
- H2 for quick demo, MySQL 8 for production-like running
- Bootstrap-free custom CSS and Chart.js CDN for dashboard charts

## Run quickly with H2

```bash
cd backend
./mvnw spring-boot:run
```

If your machine does not have Maven Wrapper execution permission:

```bash
chmod +x mvnw
./mvnw spring-boot:run
```

Open:

```text
http://localhost:8080
```

## Run with MySQL using Docker Compose

```bash
docker compose up -d db
cd backend
SPRING_PROFILES_ACTIVE=mysql ./mvnw spring-boot:run
```

Default MySQL config:

```text
Database: bookstore_management
User: bookstore_user
Password: bookstore_pass
Port: 3307
```

## Project structure

```text
project-root/
├── README.md
├── docker-compose.yml
├── database/
│   ├── schema.sql
│   ├── seed-data.sql
│   └── ERD1.svg
├── backend/
│   ├── pom.xml
│   └── src/main/...
├── frontend/
│   └── src/README.md
└── docs/
    ├── API.md
    ├── DEPLOYMENT.md
    └── DESIGN_NOTES.md
```

## Notes for presentation

This project intentionally uses server-rendered Thymeleaf pages because the course focuses on Web fundamentals, HTTP, MVC, form handling, session authentication, validation, database design, and full-stack integration. The UI still uses modern responsive CSS and JavaScript for validation, charts, and interactive confirmation dialogs.

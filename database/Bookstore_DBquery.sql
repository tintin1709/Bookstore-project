-- Database
-- Mandatory Requirements:
    -- • Complex, Well-Designed Schema
        -- – Minimum 6-8 tables (not including pure junction tables)
        -- – At least 2 junction tables for many-to-many relationships
        -- – 50+ total columns across all tables
        -- – Proper primary keys (prefer surrogate keys, UUID, or auto-increment)
        -- – Foreign key constraints enforced at database level
        -- – NOT NULL constraints where appropriate
        -- – Unique constraints for natural keys
        -- – Check constraints for business rules (where supported)
    -- • Normalization
        -- – Minimum 3NF (Third Normal Form)
        -- – No redundant data (except justified denormalization)
        -- – If denormalized, explain why in documentation
        -- – Document all functional dependencies
    -- • Indexes
        -- – Index all foreign keys
        -- – Index frequently queried columns
        -- – Composite indexes for multi-column queries
        -- – Explain index strategy in report
    -- • Data Integrity
        -- – Cascading deletes/updates configured appropriately
        -- – Default values where sensible
        -- – Triggers for complex business rules (if needed)
        -- – Audit columns (created_at, updated_at, created_by, updated_by)
CREATE DATABASE bookstore_management;
USE bookstore_management;

CREATE TABLE address (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    address_type VARCHAR(50) NOT NULL,
    recipient_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    line1 VARCHAR(255) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
);

CREATE TABLE role (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    code VARCHAR(255) NOT NULL UNIQUE, -- UK
    name VARCHAR(255) NOT NULL,
);

CREATE TABLE user_role (
    user_id INT NOT NULL, -- FK
    role_id INT NOT NULL, -- FK
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE permission (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    code VARCHAR(255) NOT NULL UNIQUE, -- UK
    name VARCHAR(255) NOT NULL,
);

CREATE TABLE role_permission (
    role_id INT NOT NULL, -- FK
    permission_id INT NOT NULL, -- FK
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE author (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    name VARCHAR(255) NOT NULL, -- need review
    slug VARCHAR(255) NOT NULL UNIQUE, -- UK
    status VARCHAR(50) NOT NULL,
);

CREATE TABLE book_author (
    book_id INT NOT NULL, -- FK
    author_id INT NOT NULL, -- FK
    author_order INT NOT NULL,
);

CREATE TABLE promotion (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    book_id INT NOT NULL, -- FK
    promotion_type VARCHAR(50) NOT NULL,
    discount_value NUMERIC(10, 2) NOT NULL -- need review
    starts_at TIMESTAMP NOT NULL,
    ends_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
);

CREATE TABLE cart (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    status varchar(50) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- need review
);

CREATE TABLE cart_item (
    cart_id INT NOT NULL, -- FK
    book_id INT NOT NULL, -- FK
    quantity INT NOT NULL,
    unit_price_snapshot NUMERIC(10, 2) NOT NULL, -- need review
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE wishlist (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    name VARCHAR(255) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
);

CREATE TABLE wishlist_item (
    wishlist_id INT NOT NULL, -- FK
    book_id INT NOT NULL, -- FK
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    category_id INT NOT NULL, -- FK
    sku VARCHAR(255) NOT NULL,
    isbn13 VARCHAR(13) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    stock_on_hand INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE category (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    name VARCHAR(255) NOT NULL UNIQUE,
    slug VARCHAR(255) NOT NULL UNIQUE, -- UK
    status VARCHAR(50) NOT NULL,
);

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    email VARCHAR(255) NOT NULL UNIQUE, -- UK
    password_hash TEXT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE review (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    book_id INT NOT NULL, -- FK
    user_id INT NOT NULL, -- FK
    rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE audit_log (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    actor_user_id INT NOT NULL, -- FK       -- need review
    entity_type VARCHAR(255) NOT NULL,
    entity_id INT NOT NULL,
    action VARCHAR(255) NOT NULL,
    old_data JSON,
    new_data JSON,
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE order_item (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    order_id INT NOT NULL, -- FK
    book_id INT NOT NULL, -- FK
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL, -- need review
    final_line_total NUMERIC(10, 2) NOT NULL, -- need review
    title_snapshot VARCHAR(255) NOT NULL,
);

CREATE TABLE order (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    order_no VARCHAR(255) NOT NULL UNIQUE, -- UK
    user_id INT NOT NULL, -- FK
    coupon_id INT, -- FK
    status VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL,
    shipment_status VARCHAR(50) NOT NULL,
    grand_total NUMERIC(10, 2) NOT NULL, -- need review
    shipping_address_snapshot JSON NOT NULL,
    placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE payment (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    order_id INT NOT NULL, -- FK
    provider VARCHAR(255) NOT NULL,
    method VARCHAR(255) NOT NULL,
    provider_txn_id VARCHAR(255) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL, -- need review
    status VARCHAR(50) NOT NULL,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE inventory_transaction (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    book_id INT NOT NULL, -- FK
    order_item_id INT, -- FK
    reservation_id INT, -- FK
    tx_type VARCHAR(50) NOT NULL,
    quantity_delta INT NOT NULL,
    balance_after INT NOT NULL,
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE shipment (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    order_id INT NOT NULL, -- FK
    carrier VARCHAR(255) NOT NULL,
    tracking_no VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    shipped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP,
);

CREATE TABLE reservation (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    book_id INT NOT NULL, -- FK
    quantity INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notified_at TIMESTAMP,
);

CREATE TABLE coupon (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    code VARCHAR(255) NOT NULL UNIQUE, -- UK
    discount_type VARCHAR(50) NOT NULL,
    discount_value NUMERIC(10, 2) NOT NULL, -- need review
    starts_at TIMESTAMP NOT NULL,
    ends_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
);

CREATE TABLE notification (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    reservation_id INT, -- FK
    channel VARCHAR(50) NOT NULL,
    notification_type VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
);
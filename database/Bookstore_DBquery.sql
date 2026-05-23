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
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    category_id INT NOT NULL, -- FK
    sku VARCHAR(255) NOT NULL,
    isbn13 VARCHAR(13) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    stock_on_hand INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE category (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    name VARCHAR(255) NOT NULL UNIQUE,
    slug VARCHAR(255) NOT NULL UNIQUE, -- UK
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
);

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    email VARCHAR(255) NOT NULL UNIQUE, -- UK
    password_hash TEXT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE review (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    book_id INT NOT NULL, -- FK
    user_id INT NOT NULL, -- FK
    rating SMALLINT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE address (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PK
    user_id INT NOT NULL, -- FK
    address_type VARCHAR(50) NOT NULL,
    recipient_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    line1 VARCHAR(255) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
);
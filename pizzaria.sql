-- Drop tables in the correct order
DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.order_items CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.product CASCADE;
DROP TABLE IF EXISTS public.flavor CASCADE;
DROP TABLE IF EXISTS public.delivery_people CASCADE;
DROP TABLE IF EXISTS public.client CASCADE;
DROP TABLE IF EXISTS public.employ CASCADE;
DROP TABLE IF EXISTS public.address CASCADE;
DROP TABLE IF EXISTS public.register_user CASCADE;
DROP TABLE IF EXISTS public.report CASCADE;

-- Drop types
DROP TYPE IF EXISTS public.permision;
DROP TYPE IF EXISTS public.payment;
DROP TYPE IF EXISTS public.order_size;
DROP TYPE IF EXISTS public.order_state;

-- Create ENUM types
CREATE TYPE public.permision AS ENUM (
    'administrator',
    'manager',
    'employee'
);

CREATE TYPE public.payment AS ENUM (
    'pix',
    'card',
    'money',
    'check'
);

CREATE TYPE public.order_size AS ENUM (
    'p',
    'm',
    'g',
    'gg'
);

CREATE TYPE public.order_state AS ENUM (
    'open',
    'making',
    'finished',
    'canceled'
);

-- Create tables
CREATE TABLE public.register_user (
    user_id serial PRIMARY KEY NOT NULL,
    name varchar(90) NOT NULL,
    email varchar(255) UNIQUE NOT NULL, 
    password varchar(255) NOT NULL,
    salt varchar(255) NOT NULL,
    is_active boolean DEFAULT TRUE,
    last_login timestamp,
    CONSTRAINT uk_email UNIQUE(email)
);

CREATE TABLE public.address (
    id serial PRIMARY KEY NOT NULL,
    streetName varchar(90) NOT NULL,
    streetNum int NOT NULL,
    addressReference varchar(90),
    city varchar(60) NOT NULL,
    state varchar(60),
    postal_code varchar(10)
);

CREATE TABLE public.employ (
    id serial PRIMARY KEY NOT NULL,
    user_id int,
    cpf varchar(16) NOT NULL,
    name varchar(90) NOT NULL,
    phone varchar(15) NOT NULL,
    permission public.permision,
    salary int NOT NULL
);

CREATE TABLE public.client (
    id serial PRIMARY KEY NOT NULL,
    user_id int,
    address_id int,
    cpf varchar(16) NOT NULL,
    name varchar(90) NOT NULL,
    phone varchar(15) NOT NULL, 
    CONSTRAINT fk_register_user
        FOREIGN KEY (user_id) REFERENCES public.register_user(user_id),
    CONSTRAINT fk_address
        FOREIGN KEY (address_id) REFERENCES public.address(id)
);

CREATE TABLE public.delivery_people (
    id serial PRIMARY KEY NOT NULL,
    employ_id int,
    cpf varchar(16) NOT NULL,
    name varchar(90) NOT NULL,
    phone varchar(15) NOT NULL, 
    FOREIGN KEY (employ_id) REFERENCES public.employ(id)
);

CREATE TABLE public.flavor (
    id serial PRIMARY KEY NOT NULL,
    flavor_name varchar(90) NOT NULL,
    flavor_price numeric(10, 2) NOT NULL,
    flavor_ingredients varchar(255)
);

CREATE TABLE public.product (
    id serial PRIMARY KEY NOT NULL,
    product_name varchar(90) NOT NULL,
    product_description varchar(255),
    price numeric(10, 2) NOT NULL,
    quantity int,
    product_flavor int,
    FOREIGN KEY (product_flavor) REFERENCES public.flavor(id)
);

CREATE TABLE public.orders (  
    id serial PRIMARY KEY NOT NULL,
    payment public.payment,
    order_size public.order_size,
    order_state public.order_state,
    must_deliver boolean NOT NULL,
    order_time timestamp NOT NULL,
    delivery_time timestamp,
    priceTotal numeric(10, 2) NOT NULL,
    delivery_people int,
    client int,
    employ int,
    FOREIGN KEY (delivery_people) REFERENCES public.delivery_people(id),
    FOREIGN KEY (client) REFERENCES public.client(id),
    FOREIGN KEY (employ) REFERENCES public.employ(id)
);

CREATE TABLE public.order_items (
    order_id int NOT NULL,
    product_id int NOT NULL,
    quantity int NOT NULL,
    FOREIGN KEY (order_id) REFERENCES public.orders(id),
    FOREIGN KEY (product_id) REFERENCES public.product(id),
    PRIMARY KEY(order_id, product_id)
);

CREATE TABLE public.reviews (
    id serial PRIMARY KEY NOT NULL,
    client_id int NOT NULL,
    product_id int,
    order_id int,
    rating int CHECK(rating BETWEEN 1 AND 5),
    comment varchar(255),
    review_time timestamp NOT NULL DEFAULT NOW(),
    FOREIGN KEY (client_id) REFERENCES public.client(id),
    FOREIGN KEY (product_id) REFERENCES public.product(id),
    FOREIGN KEY (order_id) REFERENCES public.orders(id)
);

CREATE TABLE public.report (
    id serial PRIMARY KEY NOT NULL,
    report_time timestamp NOT NULL,
    report_text varchar(255) NOT NULL
);

-- Clear all values from tables
TRUNCATE TABLE public.report, public.order, public.product, public.flavor, public.delivery_people, public.address, public.client, public.employ, public.register_user RESTART IDENTITY;

-- users
INSERT INTO public.register_user (name, email, password)
VALUES 
    ('John Doe', 'john@example.com', 'hashed_password_123'),
    ('Jane Smith', 'jane@example.com', 'hashed_password_456'),
    ('Michael Brown', 'michael@example.com', 'hashed_password_789');

-- employee
INSERT INTO public.employ (user_id, cpf, name, phone, permission, salary)
VALUES
    (1, '1234567890', 'Employee 1', 123456790, 'employee', 25000),
    (2, '9876543210', 'Employee 2', 987654210, 'manager', 40000);

-- client
INSERT INTO public.client (user_id, address_id, cpf, name, phone)
VALUES
    (7, 1, '11111111111', 'Client 1', 111111111),
    (8, 2, '22222222222', 'Client 2', 222222222);

--addresses
INSERT INTO public.address (streetName, streetNum, addressReference)
VALUES
    ('Main Street', 123, 'Apartment 1A'),
    ('Second Avenue', 456, 'House 2');

-- people
INSERT INTO public.delivery_people (employ_id, cpf, name, phone)
VALUES
    (1, '33333333333', 'Delivery Person 1', 333333333),
    (2, '44444444444', 'Delivery Person 2', 444444444);

-- flavor
INSERT INTO public.flavor (flavor_name, flavor_price, flavor_ingredients)
VALUES
    ('Margherita', 9.99, 'Tomato sauce, mozzarella cheese, basil'),
    ('Pepperoni', 11.99, 'Tomato sauce, mozzarella cheese, pepperoni'),
    ('Vegetarian', 10.49, 'Tomato sauce, mozzarella cheese, mushrooms, onions, bell peppers');

--  product 
INSERT INTO public.product (product_name, product_description, price, quantity, product_flavor)
VALUES
    ('Classic Margherita', 'Traditional Italian Margherita pizza', 9.99, 50, 1),
    ('Spicy Pepperoni', 'Delicious pepperoni pizza with a spicy kick', 11.99, 40, 2),
    ('Veggie Delight', 'Healthy and flavorful vegetarian pizza', 10.49, 30, 3);

-- order 
INSERT INTO public.orders (payment, order_size, order_state, must_deliver, order_time, priceTotal, delivery_people, client, employ)
VALUES
    ('card', 'm', 'open', true, NOW(), 20, 1, 1, 1),
    ('pix', 'g', 'making', false, NOW(), 50, 2, 2, 2),
    ('money', 'p', 'finished', false, NOW(), 30, 1, 1, 1);

-- order_items
INSERT INTO public.order_items (order_id, product_id, quantity)
VALUES
    (1, 1, 2), 
    (2, 2, 5), 
    (3, 2, 3);

-- Select Statments
SELECT * FROM public.register_user;
SELECT * FROM public.employ;
SELECT * FROM public.client;
SELECT * FROM public.address;
SELECT * FROM public.delivery_people;
SELECT * FROM public.flavor;
SELECT * FROM public.product;
SELECT * FROM public.orders;
SELECT * FROM public.order_items;
SELECT * FROM public.reviews;
SELECT * FROM public.report;


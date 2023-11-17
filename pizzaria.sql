-- Enumerators
CREATE TYPE PaymentMethodEnum AS ENUM ('PIX', 'CARD', 'MONEY');
CREATE TYPE PaymentStatusEnum AS ENUM ('PENDING', 'COMPLETED', 'FAILED');
CREATE TYPE RoleEnum AS ENUM ('ADMIN', 'USER', 'RESTAURANT');
CREATE TYPE ProductSize AS ENUM ('P', 'M', 'G', 'GG');
CREATE TYPE VehicleType AS ENUM ('BIKE', 'CAR', 'MOTORBIKE');
CREATE TYPE OrderStatusEnum AS ENUM ('Confirmed', 'Prepared', 'Ready_for_Delivery', 'Completed', 'Cancelled');
CREATE TYPE DeliveryStatusEnum AS ENUM ('PROCESSING', 'EN_ROUTE', 'DELIVERED');
CREATE TYPE ProductCategoryEnum AS ENUM ('BRASILEIRA', 'ITALIANA', 'JAPONESA', 'CHINESA', 'FAST_FOOD', 'VEGETARIANA', 'VEGANA', 'SOBREMESAS', 'LANCHES', 'PIZZA', 'MARISQUEIRA', 'PADARIA', 'CAFETERIA', 'MEXICANA', 'BEBIDA');
CREATE TYPE DayOfWeekEnum AS ENUM ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY');

-- Tables
CREATE TABLE "Role" (
  role_id SERIAL PRIMARY KEY,
  role_name RoleEnum
);

CREATE TABLE "User" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  phone VARCHAR(20),
  profile_picture VARCHAR(255),
  date_of_birth DATE,
  cpf VARCHAR(20),
  role_id INT REFERENCES "Role" (role_id)
);

CREATE TABLE "Address" (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "User" (id),
  streetName VARCHAR(255),
  streetNum INT,
  city VARCHAR(255),
  state VARCHAR(255),
  country VARCHAR(255),
  zipcode VARCHAR(20),
  additional_info TEXT,
  is_default BOOLEAN
);

CREATE TABLE "PaymentMethod" (
  id SERIAL PRIMARY KEY,
  method_name PaymentMethodEnum
);

CREATE TABLE "Card" (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "User" (id),
  card_number VARCHAR(255),
  cardholder_name VARCHAR(255),
  expiry_date DATE,
  cvv VARCHAR(4)
);

CREATE TABLE "Payment" (
  id SERIAL PRIMARY KEY,
  order_id INT, -- FK Set later due to dependency
  amount FLOAT,
  payment_method_id INT REFERENCES "PaymentMethod" (id),
  card_id INT REFERENCES "Card" (id),
  status PaymentStatusEnum
);

CREATE TABLE "ProductCategory" (
  id SERIAL PRIMARY KEY,
  name ProductCategoryEnum
);

CREATE TABLE "Product" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  description VARCHAR(255),
  price FLOAT,
  category_id INT REFERENCES "ProductCategory" (id),
  available BOOLEAN,
  discount BOOLEAN,
  discount_price FLOAT,
  size ProductSize
);

CREATE TABLE "ProductImage" (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES "Product" (id),
  image_url VARCHAR(255)
);

CREATE TABLE "Order" (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "User" (id),
  payment_id INT REFERENCES "Payment" (id),
  delivery_address_id INT REFERENCES "Address" (id),
  order_date DATE,
  order_time TIMESTAMP,
  total_price FLOAT,
  requires_delivery BOOLEAN,
  status OrderStatusEnum
);

CREATE TABLE "OrderStatus" (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES "Order" (id),
  status OrderStatusEnum,
  status_time TIMESTAMP
);

CREATE TABLE "OrderItem" (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES "Order" (id),
  product_id INT REFERENCES "Product" (id),
  quantity INT
);

CREATE TABLE "Restaurant" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  address_id INT REFERENCES "Address" (id),
  email VARCHAR(255),
  phone VARCHAR(20),
  description TEXT,
  rating_average FLOAT
);

CREATE TABLE "RestaurantCategory" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE "Restaurant_RestaurantCategory" (
  restaurant_id INT REFERENCES "Restaurant" (id),
  category_id INT REFERENCES "RestaurantCategory" (id),
  PRIMARY KEY (restaurant_id, category_id)
);

CREATE TABLE "RestaurantImage" (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES "Restaurant" (id),
  image_url VARCHAR(255)
);

CREATE TABLE "RestaurantHours" (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES "Restaurant" (id),
  day_of_week DayOfWeekEnum,
  open_time TIME,
  close_time TIME
);

CREATE TABLE "Review" (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "User" (id),
  restaurant_id INT REFERENCES "Restaurant" (id),
  rating INT,
  comment TEXT
);

CREATE TABLE "DeliveryPerson" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  phone VARCHAR(20),
  vehicle_type VehicleType,
  latitude FLOAT,
  longitude FLOAT
);

CREATE TABLE "Delivery" (
  id SERIAL PRIMARY KEY,
  delivery_person_id INT REFERENCES "DeliveryPerson" (id),
  order_id INT REFERENCES "Order" (id),
  delivery_time TIMESTAMP,
  status DeliveryStatusEnum
);

CREATE TABLE "Voucher" (
  id SERIAL PRIMARY KEY,
  description TEXT,
  discount_rate FLOAT,
  start_date DATE,
  end_date DATE
);

CREATE TABLE "Order_Voucher" (
  order_id INT REFERENCES "Order" (id),
  voucher_id INT REFERENCES "Voucher" (id),
  PRIMARY KEY (order_id, voucher_id)
);

CREATE TABLE "BankAccount" (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES "Restaurant" (id),
  bank_name VARCHAR(255),
  account_number VARCHAR(255),
  agency_number VARCHAR(255)
);

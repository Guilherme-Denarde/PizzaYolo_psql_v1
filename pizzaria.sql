-- Enumerators
CREATE TYPE payment_method_enum AS ENUM ('PIX', 'CARD', 'MONEY');
CREATE TYPE payment_status_enum AS ENUM ('PENDING', 'COMPLETED', 'FAILED');
CREATE TYPE role_enum AS ENUM ('ADMIN', 'USER', 'RESTAURANT');
CREATE TYPE product_size AS ENUM ('P', 'M', 'G', 'GG');
CREATE TYPE vehicle_type AS ENUM ('BIKE', 'CAR', 'MOTORBIKE');
CREATE TYPE order_status_enum AS ENUM ('Confirmed', 'Prepared', 'Ready_for_Delivery', 'Completed', 'Cancelled');
CREATE TYPE delivery_status_enum AS ENUM ('PROCESSING', 'EN_ROUTE', 'DELIVERED');
CREATE TYPE restaurant_category_enum AS ENUM ('BRASILEIRA', 'ITALIANA', 'JAPONESA', 'CHINESA', 'FAST_FOOD', 'VEGETARIANA', 'VEGANA', 'SOBREMESAS', 'LANCHES', 'PIZZA', 'MARISQUEIRA', 'PADARIA', 'CAFETERIA', 'MEXICANA', 'BEBIDA');
CREATE TYPE day_of_week_enum AS ENUM ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY');
CREATE TYPE product_category_enum AS ENUM ('DRINKS', 'COMBOS', 'FAST_FOOD', 'DESSERTS', 'APPETIZERS', 'SALADS', 'PIZZA', 'PASTA', 'SEAFOOD', 'VEGAN');

-- Role Table
CREATE TABLE role (
  role_id BIGINT PRIMARY KEY,
  role_name role_enum
);

-- User Table
CREATE TABLE "user" (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255),
  phone VARCHAR(20),
  profile_picture VARCHAR(255),
  date_of_birth DATE,
  cpf VARCHAR(20),
  role_id BIGINT REFERENCES role (role_id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Address Table
CREATE TABLE address (
  id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES "user" (id),
  street_name VARCHAR(255),
  street_num INT,
  city VARCHAR(255),
  state VARCHAR(255),
  country VARCHAR(255),
  postal_code VARCHAR(20),
  additional_info TEXT,
  is_default BOOLEAN,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Payment Method Table
CREATE TABLE payment_method (
  id BIGINT PRIMARY KEY,
  method_name payment_method_enum,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Card Table
CREATE TABLE card (
  id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES "user" (id),
  card_number VARCHAR(255),
  cardholder_name VARCHAR(255),
  expiry_date DATE,
  cvv VARCHAR(4),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Payment Table
CREATE TABLE payment (
  id BIGINT PRIMARY KEY,
  order_id BIGINT REFERENCES "order" (id),
  amount FLOAT,
  payment_method_id BIGINT REFERENCES payment_method (id),
  card_id BIGINT REFERENCES card (id),
  payment_status payment_status_enum,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Product Category Table
CREATE TABLE product_category (
  id BIGINT PRIMARY KEY,
  name product_category_enum,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Restaurant Table
CREATE TABLE restaurant (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  address_id BIGINT REFERENCES address (id),
  email VARCHAR(255),
  phone VARCHAR(20),
  description TEXT,
  rating_average FLOAT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Product Table
CREATE TABLE product (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  description VARCHAR(255),
  price FLOAT,
  category_id BIGINT REFERENCES product_category (id),
  restaurant_id BIGINT REFERENCES restaurant (id),
  available BOOLEAN,
  discount BOOLEAN,
  discount_price FLOAT,
  size product_size,
  "like" INT,
  size product_size,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Product Image Table
CREATE TABLE product_image (
  id BIGINT PRIMARY KEY,
  product_id BIGINT REFERENCES product (id),
  image_url VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Order Table
CREATE TABLE "order" (
  id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES "user" (id),
  payment_id BIGINT REFERENCES payment (id),
  delivery_address_id BIGINT REFERENCES address (id),
  order_date DATE,
  order_time TIMESTAMP,
  total_price FLOAT,
  requires_delivery BOOLEAN,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Order Status Table
CREATE TABLE order_status (
  id BIGINT PRIMARY KEY,
  order_id BIGINT REFERENCES "order" (id),
  order_status order_status_enum,
  status_time TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Order Item Table
CREATE TABLE order_item (
  id BIGINT PRIMARY KEY,
  order_id BIGINT REFERENCES "order" (id),
  product_id BIGINT REFERENCES product (id),
  quantity INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Restaurant Category Table
CREATE TABLE restaurant_category (
  id BIGINT PRIMARY KEY,
  name restaurant_category_enum,  
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Restaurant Restaurant Category Table
CREATE TABLE restaurant_restaurant_category (
  restaurant_id BIGINT REFERENCES restaurant (id),
  category_id BIGINT REFERENCES restaurant_category (id),
  PRIMARY KEY (restaurant_id, category_id)
);

-- Restaurant Image Table
CREATE TABLE restaurant_image (
  id BIGINT PRIMARY KEY,
  restaurant_id BIGINT REFERENCES restaurant (id),
  image_url VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Restaurant Hours Table
CREATE TABLE restaurant_hours (
  id BIGINT PRIMARY KEY,
  restaurant_id BIGINT REFERENCES restaurant (id),
  day_of_week day_of_week_enum,
  open_time TIME,
  close_time TIME,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Review Table
CREATE TABLE review (
  id BIGINT PRIMARY KEY,
  user_id BIGINT REFERENCES "user" (id),
  restaurant_id BIGINT REFERENCES restaurant (id),
  rating INT,
  comment TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Delivery Person Table
CREATE TABLE delivery_person (
  id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  phone VARCHAR(20),
  vehicle_type vehicle_type,
  latitude FLOAT,
  longitude FLOAT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Delivery Table
CREATE TABLE delivery (
  id BIGINT PRIMARY KEY,
  delivery_person_id BIGINT REFERENCES delivery_person (id),
  order_id BIGINT REFERENCES "order" (id),
  delivery_time TIMESTAMP,
  status_delivery delivery_status_enum,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Voucher Table
CREATE TABLE voucher (
  id BIGINT PRIMARY KEY,
  description TEXT,
  discount_rate FLOAT,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Order Voucher Table
CREATE TABLE order_voucher (
  order_id BIGINT REFERENCES "order" (id),
  voucher_id BIGINT REFERENCES voucher (id),
  PRIMARY KEY (order_id, voucher_id)
);

-- Bank Account Table
CREATE TABLE bank_account (
  id BIGINT PRIMARY KEY,
  restaurant_id BIGINT REFERENCES restaurant (id),
  bank_name VARCHAR(255),
  account_number VARCHAR(255),
  agency_number VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status BOOLEAN DEFAULT TRUE
);

-- Flyway Schema History Table
CREATE TABLE flyway_schema_history (
  installed_rank INT NOT NULL,
  version VARCHAR(50),
  description VARCHAR(200),
  type VARCHAR(20),
  script VARCHAR(1000) NOT NULL,
  checksum INT,
  installed_by VARCHAR(100) NOT NULL,
  installed_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  execution_time INT NOT NULL,
  success BOOLEAN NOT NULL
);

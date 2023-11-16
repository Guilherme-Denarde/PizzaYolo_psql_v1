CREATE TYPE payment_method_type AS ENUM ('PIX', 'CARD', 'MONEY');
CREATE TYPE roles AS ENUM ('ADMIN', 'USER', 'RESTAURANT');
CREATE TYPE processing_status AS ENUM ('PROCESSANDO', 'A_CAMINHO', 'ENTREGUE', 'ERRO');
CREATE TYPE status_type AS ENUM ('ATIVO', 'INATIVO');
CREATE TYPE vehicle_type AS ENUM ('BICICLETA', 'MOTO', 'CARRO');
CREATE TYPE day_of_week AS ENUM ('DOMINGO', 'SEGUNDA', 'TERÇA', 'QUARTA', 'QUINTA', 'SEXTA', 'SÁBADO');
CREATE TYPE reviewable_type AS ENUM ('PRODUTO', 'RESTAURANTE');
CREATE TYPE category_type AS ENUM (
    'BRASILEIRA', 
    'ITALIANA', 
    'JAPONESA', 
    'CHINESA', 
    'FAST_FOOD', 
    'VEGETARIANA', 
    'VEGANA', 
    'SOBREMESAS', 
    'LANCHES', 
    'PIZZA', 
    'MARISQUEIRA', 
    'PADARIA', 
    'CAFETERIA', 
    'MEXICANA',
	'BEBIDA'
);


CREATE TABLE Role (
  role_id SERIAL PRIMARY KEY,
  role_name roles NOT NULL
);

CREATE TABLE Product_Category (
  id SERIAL PRIMARY KEY,
  name category_type NOT NULL,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Payment_Method (
  id SERIAL PRIMARY KEY,
  method_name payment_method_type NOT NULL,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Promotion (
  id SERIAL PRIMARY KEY,
  description TEXT,
  discount_rate FLOAT,
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  profile_picture VARCHAR(255),
  date_of_birth DATE,
  cpf VARCHAR(20),
  role_id INT REFERENCES Role(role_id),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Address (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "user"(id),
  streetName VARCHAR(255) NOT NULL,
  streetNum INT NOT NULL,
  city VARCHAR(255) NOT NULL,
  state VARCHAR(255) NOT NULL,
  country VARCHAR(255) NOT NULL,
  zipcode VARCHAR(20),
  additional_info TEXT,
  is_default BOOLEAN,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Card (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "user"(id),
  card_number VARCHAR(255) NOT NULL,
  cardholder_name VARCHAR(255) NOT NULL,
  expiry_date DATE,
  cvv VARCHAR(4),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address_id INT REFERENCES Address(id),
  email VARCHAR(255),
  phone VARCHAR(20),
  description TEXT,
  rating_average FLOAT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant_Category (
  id SERIAL PRIMARY KEY,
  name category_type NOT NULL,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant_RestaurantCategory (
  restaurant_id INT REFERENCES Restaurant(id),
  category_id INT REFERENCES Restaurant_Category(id),
  PRIMARY KEY (restaurant_id, category_id),
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant_Hours (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES Restaurant(id),
  day_of_week day_of_week NOT NULL,
  open_time TIME,
  close_time TIME,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant_Image (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES Restaurant(id),
  image_url VARCHAR(255) NOT NULL,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Product (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  price FLOAT NOT NULL,
  category_id INT REFERENCES Product_Category(id),
  available BOOLEAN,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Product_Image (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES Product(id),
  image_url VARCHAR(255) NOT NULL,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE "order" (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "user"(id),
  payment_id INT,
  delivery_address_id INT REFERENCES Address(id),
  order_time TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Order_Status (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES "order"(id),
  processing_status processing_status,
  status_time TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Order_Item (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES "order"(id),
  product_id INT REFERENCES Product(id),
  quantity INT,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Review (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES "user"(id),
  rating INT,
  comment TEXT,
  reviewable_id INT,
  reviewable_type reviewable_type,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Delivery_Person (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  vehicle_type vehicle_type,
  latitude FLOAT,
  longitude FLOAT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Delivery (
  id SERIAL PRIMARY KEY,
  delivery_person_id INT REFERENCES Delivery_Person(id),
  order_id INT REFERENCES "order"(id),
  delivery_time TIMESTAMP,
  processing_status processing_status,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Payment (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES "order"(id),
  amount FLOAT NOT NULL,
  payment_method_id INT REFERENCES Payment_Method(id),
  card_id INT REFERENCES Card(id),
  processing_status processing_status,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Order_Promotion (
  order_id INT REFERENCES "order"(id),
  promotion_id INT REFERENCES Promotion(id),
  PRIMARY KEY (order_id, promotion_id),
  status status_type NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE Restaurant_BankAccount (
  id SERIAL PRIMARY KEY,
  restaurant_id INT REFERENCES Restaurant(id),
  bank_name VARCHAR(255) NOT NULL,
  account_number VARCHAR(255) NOT NULL,
  agency_number VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status status_type NOT NULL DEFAULT 'ATIVO'
);

-- Atualizar a tabela Order para adicionar a FK de Payment
ALTER TABLE "order" ADD FOREIGN KEY (payment_id) REFERENCES Payment(id);

#!/usr/bin/env bash

set -e
export POSTGRES_USER="postgres-user"
export POSTGRES_DB="customers"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
   CREATE TABLE IF NOT EXISTS customers ( CUSTOMER_ID INT NOT NULL PRIMARY KEY, FIRST_NAME VARCHAR(26), LAST_NAME VARCHAR(26), EMAIL VARCHAR(26), GENDER VARCHAR(26), INCOME INT, FICO INT	);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (1,'Waylen','Tubble','wtubble0@hc360.com','Male',403646, 465);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (2,'Joell','Wilshin','jwilshin1@yellowpages.com','Female',109825, 705);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (3,'Ilaire','Latus','ilatus2@baidu.com','Male',407964, 750);
   CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT, age INT);
   INSERT INTO users (id, name, age) VALUES ('1', 'fred', 34); 
   INSERT INTO users (id, name, age) VALUES ('2', 'sue', 25); 
   INSERT INTO users (id, name, age) VALUES ('3', 'bill', 51); 
   INSERT INTO users (id, name, age) VALUES ('4', 'ramon', 36); 
   INSERT INTO users (id, name, age) VALUES ('5', 'juan', 28); 
   INSERT INTO users (id, name, age) VALUES ('6', 'federico', 56); 
   INSERT INTO users (id, name, age) VALUES ('7', 'luis', 37);
   INSERT INTO users (id, name, age) VALUES ('8', 'pedro', 27);
   INSERT INTO users (id, name, age) VALUES ('9', 'pablo', 59);
   INSERT INTO users (id, name, age) VALUES ('10', 'peter', 59);
EOSQL

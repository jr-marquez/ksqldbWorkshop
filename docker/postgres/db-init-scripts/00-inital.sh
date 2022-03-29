#!/usr/bin/env bash

set -e
export POSTGRES_USER="postgres-user"
export POSTGRES_DB="customers"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  <<-EOSQL
   CREATE TABLE IF NOT EXISTS customers ( CUSTOMER_ID INT NOT NULL PRIMARY KEY, FIRST_NAME VARCHAR(26), LAST_NAME VARCHAR(26), EMAIL VARCHAR(26), GENDER VARCHAR(26), INCOME INT, FICO INT	);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (1,'Waylen','Tubble','wtubble0@hc360.com','Male',403646, 465);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (2,'Joell','Wilshin','jwilshin1@yellowpages.com','Female',109825, 705);
   INSERT INTO customers (customer_id, first_name, last_name, email, gender, income, fico) VALUES  (3,'Ilaire','Latus','ilatus2@baidu.com','Male',407964, 750);
EOSQL

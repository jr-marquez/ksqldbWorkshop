# importing pymongo
from pymongo import MongoClient
import random
import time
import datetime
# establing connection
try:
    connect = MongoClient('localhost', 27017, username='mongo-user', password='mongo-pw',)
    print("Connected successfully!!!")
except:
    print("Could not connect to MongoDB")

customer = ["1","2","3","4","5","6","7","8","9","10"]
currency = ["usd","eur"]
cities = ["Madrid","Barcelona","Paris","Montevideo","Florida","Montreal","Berlin","Colonia"]

# connecting or switching to the database
db = connect.logistics

# creating or switching to demoCollection

i=0

while True:
    i=i+1
    #insert in orders
    collection = db.orders
    order_id = str(random.randrange(50))
    ts= str(datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S"))
    document = {
    "customer_id": random.choice(customer), 
    "order_id": (order_id), 
    "price": round(random.uniform(10, 400),2),
    "currency": random.choice(customer),  
    "ts": ts
    }
    print(document)
    collection.insert_one(document)
    #sleep para simulacion
    time.sleep(random.randrange(4))
    collection = db.shipments
    document_ship = {
    "order_id": (order_id),
    "shipment_id": str(random.randrange(50)),
    "origin": random.choice(cities),
    "ts": str(datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S"))
    }
    print(document_ship)
    collection.insert_one(document_ship)
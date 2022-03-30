mongo -u mongo-user -p mongo-pw admin <<EOF
  rs.initiate();
  use config;
  db.createRole({ role: "dbz-role", privileges: [{resource: { db: "config", collection: "system.sessions" }, actions: [ "find", "update", "insert", "remove" ]}], roles: [ { role: "dbOwner", db: "config" },{ role: "dbAdmin", db: "config" }, { role: "readWrite", db: "config" }]});
  use admin;
  db.createUser({"user" : "dbz-user","pwd": "dbz-pw","roles" : [{ "role" : "root","db" : "admin" },{"role" : "readWrite", "db" : "logistics" }, { "role" : "dbz-role", "db" : "config"}]});
  use logistics;
  db.createCollection("orders");
  db.createCollection("shipments");
EOF
conn = new Mongo();
db = conn.getDB('cook');
db.dropDatabase();

## MongoDB

* MongoDB is a NoSQL document oriented database. MongoDB works on concept of collection and document. There is no concept of relationship as in RDBMS.

* Collection is a group of MongoDB documents. It is the equivalent of an RDBMS table. A collection exists within a single database. Collections do not enforce a schema.

* Document: A document is a set of key-value pairs. Documents have dynamic schema. Dynamic schema means that documents in the same collection do not need to have the same set of fields or structure, and common fields in a collection's documents may hold different types of data.

* _id is the primary key in a document. User can provide value for it while insertion or MongoDB doe it. _id is a 12 bytes hexadecimal number which assures the uniqueness of every document.
    4 bytes - current timestamp
    3 bytes - machine id
    3 bytes - process id of mongo server
    2 bytes - incremental value

* Advantages of MongoDB over RDBMS

        Schema less
        NO Complex joins
        Deep query as powerful as SQL
        Ease of scale out

* MongoDB Features

        Auto-sharding
        Replication and High availability
        Rich Queries
        Index on any attribute

* MongoDB can be used for Big Data, User management

* Considerations while designing Schema in MongoDB
        Design your schema according to user requirements.

        Combine objects into one document if you will use them together. Otherwise separate them (but make sure there should not be need of joins).

        Duplicate the data (but limited) because disk space is cheap as compare to compute time.

        Do joins while write, not on read.

        Optimize your schema for most frequent use cases.

        Do complex aggregation in the schema.

## MongoDB Commands

> Create database: _use database_name_

> To check current selected database: _db_

> List all dbs: _show dbs_, Insert atleast one document to show the created database. In MongoDB default database is test.

> Insert a document: db.collection_name.insert({"name":"Shivaganesh"})

> Drop a database: db.dropDatabase() to delete selected database

> Create collection: db.createCollection("name", options); or MongoDB creates collection automatically, when you insert some document.
* options is a document with fields- capped(boolean) for capped collection, autoIndexId(boolean) for index on _id field, size(max size in bytes for capped collection, mandaotory for capped collection), max(number) - max no. of documents in capped collection.
* db.createCollection("mycol", { capped : true, autoIndexID : true, size : 6142800, max : 10000 } )

> Show collections: show collections

> Drop a collection: db.collection_name.drop() returns true for successful deletion

> MongoDB supports many data types like String, Integer, Double, Object, BInary data, Arrays, Timestamp, Boolean, Date, Code(Javascript code), Null etc.

> Insert a document: ```db.collection_name.insert(document)```

* db.users.insert({_id : ObjectId("507f191e810c19729de860ea"), title: "MongoDB Overview",description: "MongoDB is no sql database",dateCreated: new Date(2013,11,10,2,35),url: "http://www.tutorialspoint.com",tags: ['mongodb', 'database', 'NoSQL'],likes: 100})
* To insert the document you can use db.collection_name.save(document) also. If you don't specify _id in the document then save() method will work same as insert() method. If you specify _id then it will replace whole data of document containing _id as specified in save() method.
* Insert one document: db.collection_name.insertOne(document)
* Insert many documents: db.collection_name.insertMany(documents) - returns acknoledge status(Boolean), _ids

> To query data from mongodb collection: db.collection_name.find()
* To pretty(formatted data) print: db.collection_name.find().pretty()
* To find one document with specified field: db.collection_name.findOne({fieldName: "value"})
* Equality: db.collection_name.find({"fieldName":"value"})
* Less than: db.collection_name.find({"fieldName":{$lt:50}}) - lt, lte, gt, gte, ne
* Values: ```db.collection_name.find({"v":{$in:["Raj", "Ram", "Raghu"]}})``` - in, nin
* and condition: ```db.collection_name.find({$and: [{"key":"value"}, {"key":"value"}]}).pretty()``` - and, or, not, nor
* and & or together - db.mycol.find({"likes": {$gt:10}, $or: [{"by": "tutorials point"}, {"title": "MongoDB Overview"}]}).pretty()
* db.inventory.find( { item: { $not: { $regex: "^p.*" } } } )

> Update Document: db.collection_name.update(selection_criteria, updated_data).
* MongoDB's update() and save() methods are used to update document into a collection. The update() method updates the values in the existing document while the save() method replaces the existing document with the document passed in save() method.
* db.mycol.update({'title':'MongoDB Overview'},{$set:{'title':'New MongoDB Tutorial'}}, {multi:true}). By default, MongoDB will update only a single document. To update multiple documents, you need to set a parameter 'multi' to true.
* There are other methods like findOneAndUpdate(), updateOne(), updateMany()


## MongoDB

* MongoDB is a NoSQL document oriented database. MongoDB works on concept of collection and document. There is no concept of relationship as in RDBMS.

* Collection is a group of MongoDB documents. It is the equivalent of an RDBMS table. A collection exists within a single database. Collections do not enforce a schema.

* Document: A document is a set of key-value pairs. Documents have dynamic schema. Dynamic schema means that documents in the same collection do not need to have the same set of fields or structure, and common fields in a collection's documents may hold different types of data.

* _id is the primary key in a document. User can provide value for it while insertion or MongoDB does it. _id is a 12 bytes hexadecimal number which assures the uniqueness of every document.
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
* To retrieve selective fields(projection), db.collection_name.find({}, {Key1:1, key2:0}) where 1 - show field data, 0 - hide it.  Projection means selecting only the necessary data rather than selecting whole of the data of a document.
* To limit the no. of documents: db.collection_name.find().limit(NUMBER)
* To skip first n elements: db.collection_name.find().limit(NUMBER).skip(NUMBER). Default value of skip is 0.
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

> Remove Document: db.collection_name.remove(deletion_criteria, [justOne(Boolean)])
* If no deletion criteria, all documents will be deleted.
* db.mycol.remove({'title':'MongoDB Overview'}, 1)

> Sort the documents based on field: db.collection_name.find().sort({Key1: 1}), 1 - ascending order, (-1) - descending order

> Create an Index: db.collection_name.createIndex({Key1: 1/-1}), , 1 - ascending order, (-1) - descending order. It also takes optional parameter list for expireAfterSeconds, background etc.
* Drop Index: db.collection_name.dropIndex({key:1/-1})
* Get indexes: db.collection_name.getIndexes()

> Aggregation:  Aggregation operations group values from multiple documents together, and can perform a variety of operations on the grouped data to return a single result.
* db.collection_name.aggregate([{$group : {_id : "$by_user", num_of_tutorial : {$sum : 1}}}]). sum, avg, min, max, push, addToSet, first, last

        Pipelining: Execute an operation on some input and use the output as the input for the next command and so on.

        Following are the possible stages in aggregation framework −

        * $project − Used to select some specific fields from a collection.

        * $match − This is a filtering operation and thus this can reduce the amount of documents that are given as input to the next stage.

        * $group − This does the actual aggregation as discussed above.

        * $sort − Sorts the documents.

        * $skip − With this, it is possible to skip forward in the list of documents for a given amount of documents.

        * $limit − This limits the amount of documents to look at, by the given number starting from the current positions.

        * $unwind − This is used to unwind document that are using arrays. When using an array, the data is kind of pre-joined and this operation will be undone with this to have individual documents again. Thus with this stage we will increase the amount of documents for the next stage.

## Replication

Replication is the process of synchronizing data across multiple servers. Replication provides redundancy and increases data availability with multiple copies of data on different database servers.

Why Replication?

        To keep your data safe
        High (24*7) availability of data
        Disaster recovery
        No downtime for maintenance (like backups, index rebuilds, compaction)
        Read scaling (extra copies to read from)
        Replica set is transparent to the application

Replica Set Features

        A cluster of N nodes
        Any one node can be primary
        All write operations go to primary
        Automatic failover
        Automatic recovery
        Consensus election of primary

> To create a replication set: mongod --port "PORT" --dbpath "YOUR_DB_DATA_PATH" --replSet "REPLICA_SET_INSTANCE_NAME"
* mongod --port 27017 --dbpath "D:\set up\mongodb\data" --replSet rs0
> To initiate new replica set: rs.initiate()

> To check replica set configuration: rs.conf()

> Status of replica set: rs.status()

> Add members to replica set: To add members to replica set, start mongod instances on multiple machines. Now start a mongo client and issue a command rs.add(HOST_NAME:PORT).

> To check connected to primary: db.isMaster()

## Sharding
Sharding is the process of storing data records across multiple machines and it is MongoDB's approach to meeting the demands of data growth.

Why Sharding?

        In replication, all writes go to master node

        Latency sensitive queries still go to master

        Single replica set has limitation of 12 nodes

        Memory can't be large enough when active dataset is big

        Local disk is not big enough

        Vertical scaling is too expensive

> Sharded Cluster has shards, config-servers and query routers.

## Backup & Resotre

> mongodump for backup and mongorestore for restoring the data.
* mongodump --host HOST_NAME --port PORT_NUMBER
* mongodump --dbpath DB_PATH --out BACKUP_DIRECTORY_NAME
* mongodump --collection COLLECTION --db DB_NAME

## Monitoring

> mongostat : This command checks the status of all running mongod instances and return counters of database operations. These counters include inserts, queries, updates, deletes, and cursors. Also some performance metrics.

> mongotop [number]: This command tracks and reports the read and write activity of MongoDB instance on a collection basis. Optional number signifies return information less frequently(30 secs instead of 1 sec).


## Relationships
> 2 Types of relationships: Embedded, Referenced
* In Embedded relationship, related arrays are kept in the same document

* In Referenced relationship, one document references other by _id field(normalised data)

## Database References
> Referenced Relationships also referred to as Manual References in which we manually store the referenced document's id inside other document. However, in cases where a document contains references from different collections, we can use MongoDB DBRefs.

```
There are three fields in DBRefs −

$ref − This field specifies the collection of the referenced document

$id − This field specifies the _id field of the referenced document

$db − This is an optional field and contains the name of the database in which the referenced document lies
```
```json
{
   "_id":ObjectId("53402597d852426020000002"),
   "address": {
   "$ref": "address_home",
   "$id": ObjectId("534009e4d852427820000002"),
   "$db": "tutorialspoint"},
   "contact": "987654321",
   "dob": "01-01-1991",
   "name": "Tom Benzamin"
}
>var user = db.users.findOne({"name":"Tom Benzamin"})
>var dbRef = user.address
>db[dbRef.$ref].findOne({"_id":(dbRef.$id)})
```

## MongoDB Covered Queries
> Covered Query is one in which all fields in the query are part of an index also all the fields returned in the query are in the same index.
> Since indexes present in the RAM, fetching will be faster. Query will not scan document database.

* Eg: db.users.createIndex({gender:1,user_name:1})    db.users.find({gender:"M"},{user_name:1,_id:0}). Explicitly _id:0 must be done as by default _id field will be returned.

* Quries can be analyzed using explain() and hint() method. explain() method gives detail of index is used or not etc., hint() method forces the query optimizer to use the specified index to run a query so that we can analyze various indices performance.

* MongoDB does not support multi-document atomic transactions. However, it does provide atomic operations on a single document. In cases where there are frequent updates, use embedded document approach.

* Indexing an array field in turn creates seperate index on each of its field. >db.users.find({tags:"cricket"}).explain(). Indexing sub-document field is as follows: >db.users.createIndex({"address.city":1,"address.state":1,"address.pincode":1})

* Creation time of a document using getTimestamp ObjectId("5349b4ddd2781d08c09890f4").getTimestamp()  objectIdVal.str - to get ObjectId in string format.

### Limitation of Indexing

* Every index occupies some space as well as causes an overhead on each insert, update and delete. 

* Since indexes are stored in RAM, you should make sure that the total size of the index does not exceed the RAM limit. If the total size increases the RAM size, it will start deleting some indexes, causing performance loss.

* Indexing cant be used in queries which use regular expressions or negation operations, arithmetic operations, where clause.

* A collection cannot have > 64 indexes.
  
* Length of the  index name cannot be longer that 125 characters.
  
* Compount index can have maximum 31 fields indexed.


### Notes
* db.posts.find({post_text:{$regex:"tutorialspoint"}}).pretty()

* db.posts.find({post_text:{$regex:"tutorialspoint",$options:"$i"}}) - Case insensitive search

* RockMongo is a MongoDB administration tool using which you can manage your server, databases, collections, documents, indexes, and a lot more.

* GridFS is the MongoDB specification for storing and retrieving large files such as images, audio files, video files, etc. It is kind of a file system to store files but its data is stored within MongoDB collections. GridFS has the capability to store files even greater than its document size limit of 16MB. GridFS divides a file into chunks and stores each chunk of data in a separate document, each of maximum size 255k. GridFS by default uses two collections fs.files and fs.chunks to store the file's metadata and the chunks.

* Capped collections are best for storing log information, cache data, or any other high volume data.

* To check a collection is capped or not, db.collection_name.isCapped()

* db.runCommand({"convertToCapped":"posts",size:10000}) - Here posts collection is converted to capped collection.

* By default, a find query on a capped collection will display results in insertion order. But if you want the documents to be retrieved in reverse order - db.cappedLogCollection.find().sort({$natural:-1})

* We cannot delete documents from a capped collection.

* There are no default indexes present in a capped collection, not even on _id field.





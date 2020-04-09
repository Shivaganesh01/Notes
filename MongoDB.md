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
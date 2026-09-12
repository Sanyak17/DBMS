E-R Model:
The Entity-Relationship Model, commonly called the E-R Model, is used to design the structure of a database before creating actual tables.

It helps us answer:
What objects exist in the system?
What information should we store about them?
How are those objects related?
What rules apply to those relationships?

The E-R Model is a high-level conceptual data model that represents:

Entities
Attributes
Relationships
Constraints
It is generally represented using an E-R Diagram.

Main Components:
Entity
Real world object
Entity Type
Collection/category of similar entities
Entity Set
Collection of entity instances
Attribute
Property of an entity
Relationship
Association between entities
Relationship Set
Collection of similar relationships
Key Attribute
Attribute that uniquely identifies an entity
Weak Entity
Entity that depends on another entity for identification
Constraints
Rules controlling relationships

An entity type defines the common structure of similar objects, an entity instance is one specific object of that type, and an entity set is the collection of such instances.
An attribute is a property or characteristic of an entity.
Types of Attributes
Simple Attribute: A simple attribute cannot be meaningfully divided into smaller components. eg:age,salary,gender
Composite Attribute:A composite attribute can be divided into smaller meaningful attributes. eg:name, address
Single-Valued Attribute:An attribute that has one value for each entity. eg:date_of_birth
Multivalued Attribute: An attribute that can have multiple values for one entity.eg:phone no, email
Derived Attribute: A derived attribute is calculated from another attribute. eg:date_of_birth → age
Stored Attribute:A stored attribute is physically stored in the database and may be used to derive another attribute. eg:date_of_birth is stored, while:age is derived.
Key Attribute: A key attribute uniquely identifies an entity.eg: student_id
Null-Valued Attribute: An attribute may have no applicable or known value. eg:middle_name = NULL


 Relationship
A relationship is an association between two or more entities.
A Relationship describes how two (or more) entities are associated with each other. Relationships are classified by cardinality — how many instances of one entity relate to how many instances of another.
Examples:
Student enrolls in Course.

Relationship Type
A relationship type describes the common structure of relationships between entity types.
Relationship Instance
A relationship instance is one specific association between entities.
Relationship Set
A relationship set is a collection of relationship instances of the same relationship type.

Degree of Relationship
The degree of a relationship is the number of participating entity types.

Unary Relationship
A unary relationship involves only one entity type.
Example: Employee manages Employee

Binary Relationship
A binary relationship involves two entity types.
STUDENT ─── ENROLLS ─── COURSE

Ternary Relationship
A ternary relationship involves three entity types.
Supplier S1 supplies Part P1 to Project J1

N-ary Relationship
A relationship involving more than three entity types is called an n-ary relationship.

Cardinality Ratio
Cardinality describes how many entities of one entity type can be associated with entities of another type.

The four major types are:
One-to-One
One-to-Many
Many-to-One
Many-to-Many

One-to-One Relationship — 1:1
Each entity in Entity A is related to at most one entity in Entity B, and vice versa.
PERSON ─── HAS ─── PASSPORT

One-to-Many Relationship — 1:N
One entity in Entity A can be related to many entities in Entity B, but each entity in B is related to only one entity in A.
DEPARTMENT 1 ───── N EMPLOYEE

Many-to-One -N:1
Just the reverse framing of One-to-Many — many entities in A relate to one entity in B. Same underlying structure, different perspective.

Many-to-Many-M:N
Multiple entities in Set A can relate to multiple entities in Set B, and vice versa.
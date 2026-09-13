Data Abstraction:
Data Abstraction is the process of hiding the complex internal details of how data is physically stored, and exposing only what's necessary to the user at each level.

It exists because different people interacting with a database need different levels of detail — a DBA cares about physical storage, a developer cares about tables and relationships, an end user just sees a filtered view of a few fields.

This is implemented as three levels, known as the Three-Schema Architecture (ANSI-SPARC).

Three Levels of Abstraction:

External Level (View Level)

Highest level
Describes how individual users/applications see the data
A partial, simplified view of the full schema
Different user groups can have different external views of the same data
Implemented in practice via Views
Example: accounts dept sees student_id, name, fees_due; academics dept sees student_id, name, cgpa

Conceptual Level (Logical Level)

Middle level
Describes what data is stored and the relationships among it, without physical storage detail
Essentially "the schema" — tables, columns, data types, constraints, relationships
Example: students table has student_id, name, dept_id; departments table has dept_id, dept_name; related via FK

Internal Level (Physical Level)

Lowest level
Describes how data is physically stored — file structures, indexing method, block size, storage allocation
DBA's domain
Example: whether the index on student_id is a B-Tree or Hash index

Data Independence:
The ability to change one level without affecting the levels above it.

Physical Data Independence

Changing the internal level (e.g., switching index type, changing storage format) doesn't require changes to the conceptual or external level
Example: DBA adds an index on email for faster lookup — no query anywhere needs to change

Logical Data Independence

Changing the conceptual level (e.g., adding a column, splitting a table) shouldn't break the external level
Example: splitting students into students + student_contact_info — the student_view can be redefined internally to JOIN both, while SELECT * FROM student_view still works the same for the user
Considered harder to achieve than physical data independence, since schema-level changes are more likely to ripple upward

Intension vs Extension:

Intension (Schema)

The fixed, structural description of the database — table names, column names, data types, constraints
Defined once, changes rarely (only via ALTER/migrations)
Example: CREATE TABLE students (student_id INT PRIMARY KEY, name VARCHAR(50), cgpa DECIMAL(3,2));

Extension (Instance/State)

The actual data present in the database at a given moment
Changes constantly with every INSERT/UPDATE/DELETE
Example: the actual rows sitting in students right now

Analogy: Intension is like a class definition. Extension is like the list of actual objects existing right now.
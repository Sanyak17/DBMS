# Day 5: Indexing in DBMS

## What is Indexing?
An Index is a separate data structure maintained alongside a table, designed to speed up data retrieval by letting the database engine locate rows without scanning the entire table.

Without an index: DBMS performs a full table scan — reads every row to check for a match.
With an index: DBMS can jump almost directly to matching rows.

Real-world analogy: A phone book sorted by last name — you don't read every entry, you jump straight to the relevant section.

## Why Indexing Matters — the Tradeoff

| Benefit | Cost |
|---|---|
| Much faster SELECT with WHERE/JOIN/ORDER BY/GROUP BY | Extra disk space |
| Faster sorting if indexed column matches ORDER BY | Every INSERT/UPDATE/DELETE must update the index too |
| Enforces uniqueness (unique/primary indexes) | Too many indexes hurt write-heavy workloads |

Should you index every column? No — index only frequently searched/filtered/joined columns, since each index adds write overhead and storage cost.

## Syntax
```sql
CREATE INDEX idx_student_name ON students(name);
CREATE UNIQUE INDEX idx_student_email ON students(email);
CREATE INDEX idx_dept_name ON students(dept_id, name);
DROP INDEX idx_student_name ON students;
```

## Types of Indexes

### Primary Index
Automatically created on the primary key column. Inherently unique since PK is unique/non-null.

### Secondary Index
Created explicitly on a non-key column to speed up searches on that column.
Eg: index on dept_id for `WHERE dept_id = 5`.

### Unique Index
Ensures all values in the indexed column are distinct.
Eg: `CREATE UNIQUE INDEX idx_email ON students(email);`

### Composite Index (Multi-column)
Built on two or more columns together.
Eg: `CREATE INDEX idx_dept_name ON students(dept_id, name);`

Leftmost prefix rule: an index on (dept_id, name) helps queries filtering on dept_id alone, or dept_id + name together — but NOT name alone.

### Clustered Index
Determines the physical order of rows on disk. Only one per table. Often the primary key by default.
Eg: if student_id is clustered, rows are physically stored in student_id order — fast range queries.

### Non-Clustered Index
A separate structure holding pointers back to actual rows. Multiple allowed per table. Requires an extra lookup step (bookmark lookup).
Eg: an index on email is non-clustered — table itself stays sorted by student_id.

Clustered vs Non-Clustered:
| Clustered | Non-Clustered |
|---|---|
| Physically reorders table data | Separate structure with pointers |
| Only 1 per table | Multiple per table |
| Faster for range queries | Slightly slower (extra pointer lookup) |
| Usually the PK by default | Created explicitly on other columns |

### Dense Index
Index entry for every row/search key value. Fast lookups, more storage.

### Sparse Index
Index entries for only some values (usually one per data block). Less storage, may need to scan within the block once located.

### Multilevel Index
An index on an index — used when the primary index itself is too large for memory. Reduces disk I/O by narrowing down block, then row. This is conceptually how B-Tree/B+ Tree indexes work.

## B-Tree and B+ Tree Indexes

B-Tree: balanced, self-sorting tree; each node can have multiple children. Search/insert/delete stay O(log n) even as the table grows.

B+ Tree (more commonly used): all actual data lives at leaf level; internal nodes hold only keys for navigation. Leaf nodes are linked together — makes range queries (BETWEEN, >, <, ORDER BY) very efficient.

## Hash Index
Uses a hash function to map a key directly to a storage location.
- Extremely fast for exact-match lookups: `WHERE student_id = 5`
- Useless for range queries: `WHERE student_id > 5` — hashed values aren't stored in sorted order.

B+ Tree vs Hash Index:
| B+ Tree | Hash Index |
|---|---|
| Good for exact match AND range queries | Good only for exact match |
| Data stays sorted | Data is scattered (hashed) |
| Slightly slower for pure exact-match than hash | Extremely fast for exact-match |
| Default in most RDBMSs | Used in specific cases (in-memory DBs, hash joins) |

## When NOT to Use an Index
- Tables with frequent writes and few reads
- Columns with low cardinality (few distinct values, e.g. gender)
- Very small tables where a full scan is already fast enough
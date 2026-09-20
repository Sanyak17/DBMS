# Day 11: Concurrency Control Protocols, Shared vs Exclusive Lock

## Why Concurrency Control Exists
Multiple transactions run simultaneously on a real database (many users, many requests). Without control, this causes:
- Lost updates (one transaction's write overwrites another's, silently)
- Dirty reads (reading another transaction's uncommitted data)
- Inconsistent analysis (aggregates computed from a mix of pre- and post-update data)

Concurrency Control Protocols (CCPs) are mechanisms the DBMS uses to let transactions run in parallel while still guaranteeing correctness (this is exactly the "I" — Isolation — in ACID).

## What is a Lock?
A lock is a mechanism that prevents multiple transactions from accessing the same data item in conflicting ways at the same time. Before reading or writing a data item, a transaction must acquire the appropriate lock on it.

## Shared Lock (S-Lock / Read Lock)
- Acquired when a transaction wants to READ a data item.
- Multiple transactions can hold a shared lock on the same item simultaneously — reads don't conflict with other reads.
- Cannot be acquired if another transaction already holds an exclusive lock on that item.

Eg: Two users both want to check the current balance of an account — both can hold a shared lock and read simultaneously without issue.

## Exclusive Lock (X-Lock / Write Lock)
- Acquired when a transaction wants to WRITE (insert/update/delete) a data item.
- Only ONE transaction can hold an exclusive lock on a data item at a time.
- Cannot be acquired if any other transaction holds a shared OR exclusive lock on that item.

Eg: A transaction transferring money out of an account needs an exclusive lock on that account's balance — no other transaction can read or write it until this one finishes.

## Shared vs Exclusive Lock — Consolidated Table

| Aspect | Shared Lock (S) | Exclusive Lock (X) |
|---|---|---|
| Purpose | Read | Write |
| Multiple holders allowed? | Yes (multiple S locks coexist) | No (only one X lock at a time) |
| Compatible with | Other S locks | Nothing else |
| Blocks | X locks from others | Both S and X locks from others |

Lock Compatibility Matrix:
|       | S     | X     |
|-------|-------|-------|
| **S** | Yes   | No    |
| **X** | No    | No    |

## Concurrency Control Protocols

### 1. Lock-Based Protocols
Transactions must acquire locks before accessing data, release them afterward, following rules that guarantee correctness.

**Two-Phase Locking (2PL)** — the most important lock-based protocol, split into two phases:
- **Growing Phase:** Transaction can acquire locks, but cannot release any.
- **Shrinking Phase:** Transaction can release locks, but cannot acquire any new ones.

Once a transaction releases its first lock, it enters the shrinking phase and can never acquire another lock again.

Eg: A transaction reads Account A (acquire S-lock), writes to Account B (acquire X-lock) — both acquisitions happen in growing phase. Once it starts releasing locks (say, releases lock on A), it cannot go back and acquire a new lock on Account C.

**Why 2PL matters:** 2PL guarantees **conflict serializability** (Day 12 topic) — schedules following 2PL are guaranteed to be equivalent to some serial execution order.

**Strict 2PL (commonly used in practice):** All exclusive locks are held until the transaction COMMITs or ROLLBACKs (not released early in the shrinking phase). This prevents cascading rollbacks — where one transaction's failure forces other transactions (that read its uncommitted data) to also roll back.

### 2. Timestamp Ordering Protocol
Instead of locks, each transaction is assigned a unique timestamp when it starts. The DBMS ensures transactions execute in an order consistent with their timestamps — older transactions get priority over younger ones for conflicting operations.

- Every data item tracks the timestamp of the last transaction that read it and the last one that wrote it.
- If a transaction tries to read/write a data item in a way that violates timestamp order (e.g., tries to write over data already read by a "newer" transaction), it's rolled back and restarted with a new timestamp.

Eg: Transaction T1 (timestamp 5) and T2 (timestamp 10) both want to write to the same row. If T2 already wrote to it, and T1 (older) tries to write after, the DBMS detects T1 is "too late" relative to timestamp order and rolls T1 back.

**Advantage over locking:** No deadlocks possible (nothing is "waiting" — conflicting transactions are just rolled back and retried).
**Disadvantage:** More rollbacks/restarts under high contention, compared to locking.

### 3. Validation-Based (Optimistic) Protocol
Assumes conflicts are rare. Transactions execute freely without locks during a "read" and "compute" phase, and are only checked for conflicts at the very end, right before commit ("validation phase").

- If validation passes (no conflicting transaction interfered), the transaction commits.
- If validation fails, the transaction is rolled back and restarted.

Eg: Good for read-heavy systems where write conflicts are genuinely rare — avoids the overhead of locking for every read, at the cost of occasional rollback if a real conflict is detected late.

## Concurrency Control Protocols — Consolidated Table

| Protocol | Approach | Best for | Downside |
|---|---|---|---|
| Lock-based (2PL) | Acquire/release locks in phases | General-purpose, write-heavy | Can cause deadlocks |
| Timestamp ordering | Order by transaction timestamp | Avoiding deadlocks | More rollbacks under contention |
| Validation-based (Optimistic) | Check for conflicts only at commit time | Read-heavy, low-conflict systems | Rollback cost if conflict found late |
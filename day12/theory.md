# Day 12: Conflict Serializability

## Recap: What is a Schedule?
A schedule is the order in which operations (reads/writes) from multiple concurrent transactions are executed. A schedule can be:
- **Serial:** transactions execute one completely after another, no interleaving (safe, but no concurrency benefit)
- **Concurrent/Interleaved:** operations from different transactions are mixed together (needed for performance, but risks incorrectness)

## What is Serializability?
Serializability is the property that guarantees a concurrent (interleaved) schedule produces the SAME result as SOME serial execution of the same transactions. If a schedule is serializable, it's considered "correct" even though it ran concurrently — because the end result is indistinguishable from running the transactions one after another.

Interview one-liner: "Serializability is the gold standard for correctness under concurrency — a schedule is serializable if its outcome matches some serial (non-interleaved) order of the same transactions."

## What is Conflict Serializability?
A schedule is Conflict Serializable if it can be transformed into a serial schedule by swapping non-conflicting (independent) operations, without changing the overall effect.

### What counts as a "Conflict"?
Two operations conflict if ALL of these are true:
1. They belong to DIFFERENT transactions
2. They operate on the SAME data item
3. At least ONE of them is a WRITE

Conflict pairs:
- Read-Write (RW) conflict — one transaction reads, another writes the same item
- Write-Read (WR) conflict — one transaction writes, another reads the same item
- Write-Write (WW) conflict — both transactions write the same item

Non-conflicting: Read-Read (RR) — two transactions reading the same item never conflicts, since reads don't change anything.

## How to Check Conflict Serializability — Precedence Graph Method

1. Draw a node for each transaction in the schedule.
2. Draw a directed edge from Ti to Tj if Ti has an operation that conflicts with, and occurs BEFORE, a corresponding operation in Tj (on the same data item).
3. If the resulting graph has NO CYCLES, the schedule is Conflict Serializable.
4. If the graph HAS a cycle, the schedule is NOT Conflict Serializable.

Example:
Schedule S: 
T1: Read(A), Write(A)
T2: Read(A), Write(A)

If T1 reads A before T2 writes A, and T2 reads A before T1 writes A — this creates:
T1 -> T2 (T1's read before T2's write, conflict)
T2 -> T1 (T2's read before T1's write, conflict)
This forms a cycle (T1 -> T2 -> T1), so this schedule is NOT conflict serializable.

## Real-World Eg (to explain in interview)
Two transactions both reading and updating an account balance concurrently:
T1: Read(balance), balance = balance + 100, Write(balance)
T2: Read(balance), balance = balance - 50, Write(balance)

If T1 reads balance BEFORE T2 writes it, and T2 reads balance BEFORE T1 writes it, both transactions computed their update based on stale data — this is a lost-update scenario, and checking the precedence graph would reveal a cycle, confirming the schedule is not conflict serializable (i.e., not safe).

## Why This Matters Practically
Conflict Serializability is the theoretical foundation that Two-Phase Locking (2PL, from Day 11) is built to guarantee. If a DBMS enforces 2PL correctly, every resulting schedule is guaranteed to be conflict serializable — this is precisely why 2PL is trusted as a correctness mechanism.

Interview-ready line: "Conflict serializability is checked using a precedence graph — if there's no cycle among transactions based on their conflicting operations, the schedule is safe and equivalent to some serial order. Two-Phase Locking is specifically designed to always produce conflict-serializable schedules."

## Conflict Serializability vs View Serializability (brief, sometimes asked)
- Conflict Serializability: based on the ORDER of conflicting operations (stricter, easier to test via precedence graph)
- View Serializability: based on the overall READ/WRITE VALUES being equivalent to a serial schedule (broader, harder to test computationally — NP-complete in general)

Every conflict serializable schedule is also view serializable, but not vice versa.
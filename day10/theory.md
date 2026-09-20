# Day 10: Vertical vs Horizontal Scaling, Sharding

## What is Scaling?
Scaling refers to a system's ability to handle increased load — more data, more users, more requests — by adding resources. Critical once a single machine can't keep up with read/write demand.

## Vertical Scaling (Scaling Up)
Increasing the capacity of a single machine — more CPU, RAM, or faster disks on the existing server.

Eg: upgrading a struggling DB server from 16GB to 64GB RAM, 4 cores to 16 cores.

Advantages:
- Simple — no application-level changes, no data distribution logic
- No consistency issues, since there's still just one database instance

Disadvantages:
- Hardware ceiling — physical/practical limit to how much one machine can be upgraded
- Single point of failure — if that one machine goes down, everything goes down
- Gets progressively more expensive — high-end hardware costs disproportionately more

## Horizontal Scaling (Scaling Out)
Adding more machines to distribute the load, instead of upgrading one machine's capacity.

Eg: splitting data across 4 smaller servers instead of one massive server.

Advantages:
- No hardware ceiling — scales by adding more machines
- Better fault tolerance — if one machine fails, others keep serving (with replication)
- Often more cost-effective at scale — commodity hardware in parallel vs one expensive machine

Disadvantages:
- More complex — requires distributing data logically (sharding), handling consistency across nodes, network overhead
- Traditional RDBMS often need extra tooling; NoSQL databases (MongoDB, Cassandra) built with this in mind from the start

## Vertical vs Horizontal Scaling

| Aspect | Vertical Scaling | Horizontal Scaling |
|---|---|---|
| Approach | Upgrade one machine | Add more machines |
| Complexity | Simple | Complex (data distribution, consistency) |
| Cost pattern | Expensive at high-end | More cost-effective at scale |
| Fault tolerance | Single point of failure | Better (if one node fails, others continue) |
| Ceiling | Hardware-limited | Practically limitless |
| Eg | Upgrading RAM/CPU on one DB server | Splitting data across multiple DB servers |

## What is Sharding?
Sharding is a specific technique for horizontal scaling — splits a large database into smaller, independent pieces called shards, each stored on a separate server, holding a subset of the total data.

Eg: a social media platform shards the users table by user_id range — users 1-100M on Server A, 100M-200M on Server B, etc.

### Sharding Strategies

**Range-based Sharding**
Data split based on a value range.
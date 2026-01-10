# Sunbeat Festival Database – System Overview & Design Philosophy

This repository demonstrates a systematic, SQL-first approach to building
and validating a relational database using a real-world case study.

The focus is not only on schema design, but on establishing *data trust*
through structured testing: integrity, business logic, completeness,
relationship consistency, and performance.

---

## Why This Project Exists

In software engineering, application bugs often fail loudly. Database failures, however, tend to fail **silently** — corrupting reports, breaking financial logic, or degrading performance only when systems scale.

Common issues such as:
- orphaned records,
- broken aggregates,
- invalid schedules,
- or missing indexes,

are not edge cases — they are routine failures when databases are not systematically tested.

This project demonstrates how to prevent those failures using **plain SQL**, disciplined thinking, and a repeatable validation framework.


---

## The Database Testing Pyramid

This project adopts a **Database Testing Pyramid**, adapted from the classic software testing pyramid, to prioritise effort where it provides the most stability.

### Layer 1: Data Integrity Tests (Foundation)
Ensures the structural soundness of the schema by validating:
- foreign key relationships,
- UNIQUE constraints,
- NOT NULL rules.

These tests confirm that the relational “links” are intact before any higher-level logic is trusted.

---

### Layer 2: Business Logic & Completeness Tests (Middle)
Encodes real-world rules and expectations, including:
- valid festival dates and performance times,
- correct ticket logic,
- populated critical fields,
- expected and minimum data volumes.

At this layer, the database begins to reflect **how the system actually operates**.

---

### Layer 3: Performance & Integration Tests (Apex)
Validates that:
- complex multi-table queries behave correctly,
- reports and schedules are consistent,
- indexes are actually used,
- performance remains predictable as data scales.

This is where `EXPLAIN QUERY PLAN` is used to prevent future performance cliffs.

---

## Case Study: Sunbeat Music Festival

The Sunbeat Festival is a fictional multi-day music event designed to introduce realistic complexity:

- **Event structure**: Three days, five stages  
- **Actors**: Attendees, organisers, and artists  
- **Ticketing**: Day passes, multi-day passes, VIP access, camping add-ons  
- **Core functions**:
  - performance scheduling,
  - ticket booking,
  - personalised schedules,
  - sales and attendance reporting  

The schema includes entities such as `Artist`, `Stage`, `Performance`, `Attendee`, `Booking`, and `Ticket_Type`.

---

## Implementation Methodology

The database was developed using a disciplined, six-step process that maps directly onto the testing pyramid.

### Step 1: Requirements & Entity Analysis
Business rules were decomposed into entities, attributes, and relationships, resulting in a clear ERD.

---

### Step 2: Schema Creation & Constraints
The logical model was implemented using constrained DDL:
- foreign keys enforced via `PRAGMA foreign_keys = ON`,
- `CHECK` constraints for domain rules,
- `UNIQUE` constraints for natural keys.

---

### Step 3: Strategic Indexing
Indexes were designed *before* performance problems appeared:
- foreign key indexes for joins,
- composite unique indexes to enforce business rules,
- covering indexes for high-value reports.

---

### Step 4: Realistic Data Population
Data was populated to mirror real usage:
- artists with multiple performances,
- varying booking patterns,
- coherent scheduling across days and stages.

This enabled meaningful validation and performance testing.

---

### Step 5: Requirement Validation
Queries were written to prove that:
- attendees can view line-ups and schedules,
- organisers can monitor ticket sales,
- Artists can view performance schedules.

---

### Step 6: Systematic Database Testing
The completed system was validated using a **five-phase test suite**:

- **Phase 1** – Referential Integrity  
- **Phase 2** – Business Logic  
- **Phase 3** – Data Completeness  
- **Phase 4** – Relationship Consistency  
- **Phase 5** – Indexing & Performance  

Each test returns a measurable pass/fail result, converting assumptions into verified guarantees.

---

## What This Repository Demonstrates

- Validation-first database design
- SQL-based testing without external tooling
- Detection of silent data failures
- Scalable performance thinking
- Professional documentation and reasoning

This is not a code dump — it is a **designed system**.

---

## Repository Structure

All schema definitions, data population scripts, and validation tests are
compiled into a **single, fully documented SQL file**.

The file is organised into clearly marked sections corresponding to the
five validation phases:

- Phase 1 – Referential Integrity Tests
- Phase 2 – Business Logic Tests
- Phase 3 – Data Completeness Tests
- Phase 4 – Relationship Validation Tests
- Phase 5 – Indexing & Performance Tests

This structure allows the entire system to be reviewed, executed, and
understood from a single entry point, while preserving logical separation
between validation concerns.

---

## Technologies

- SQLite 3
- Standard SQL
- No ORM
- No external testing frameworks

---

## Final Note

Systematic database testing is not an optional extra — it is a core engineering responsibility. By applying the testing pyramid, you build **Data Trust** incrementally and deliberately.

The result is not just a database that works, but one that can be **trusted**.

---

### Full Implementation

The complete codebase — including schema definitions, indexes, data population, and all validation tests — is available in this repository:

👉 `https://github.com/Vee-maker363/Sunbeam_Festival`

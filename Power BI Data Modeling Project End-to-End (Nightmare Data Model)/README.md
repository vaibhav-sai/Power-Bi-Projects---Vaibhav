# Power BI Data Modeling Project – From Chaos Dataset to Star Schema

## Project Short Info
An end-to-end Power BI data modeling project that transforms a messy, unstructured "nightmare" dataset (23 raw tables) into a clean, standardized star schema. Covers dimension/fact design, junk and accumulating snapshot facts, DAX measures, date intelligence, and row-level security.

## Project Description
This project takes a real-world "chaos" dataset — duplicate tables, cryptic codes, inconsistent naming, and no clear structure — and rebuilds it into a professional, high-performance Power BI semantic model. Work started with exploring and classifying every source table as a dimension or a fact, then organizing Power Query into staged folders. Customer, product, and other entity tables were consolidated into clean dimensions, while order header/detail tables were merged into a single grain-correct fact table. Additional fact types were built, including inventory, factless, and accumulating snapshot facts. The model was finished with a dynamic date dimension, centralized DAX measures, standardized formatting, and row-level security — with totals validated against source numbers at every stage to protect data accuracy.

---

## Table of Contents
- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Tools Used](#tools-used)
- [Project Workflow](#project-workflow)
- [Data Modeling Principles Followed](#data-modeling-principles-followed)
- [Naming Standards](#naming-standards)
- [Phase-by-Phase Breakdown](#phase-by-phase-breakdown)
- [Fact Table Types Built](#fact-table-types-built)
- [DAX Measures & Calculated Columns](#dax-measures--calculated-columns)
- [Row-Level Security](#row-level-security)
- [Key Learnings](#key-learnings)
- [Author](#author)

---

## Overview
Most incorrect numbers on a dashboard are not caused by wrong data or wrong DAX — they are caused by a broken data model underneath. This project focuses entirely on fixing that root cause: building a **star schema** data model in Power BI from a disorganized set of source tables, with an emphasis on structure, grain, standardization, and validation over "fancy visuals."

## Problem Statement
The source dataset arrived as **23 raw tables** with:
- Duplicate/near-duplicate tables (e.g., "Sheet1" vs "Shipments")
- Inconsistent naming and mixed languages
- Cryptic source codes with no business context
- No clear separation between dimensions and facts
- Header and detail tables that needed to be reconciled into a single fact

The goal was to turn this into a clean, documented, star-schema-based model ("Galaxy schema" once multiple fact tables share dimensions) that business users and other developers could trust and extend.

## Tools Used
- **Power BI Desktop** – data modeling, relationships, DAX
- **Power Query (M)** – data cleaning, shaping, merging, unpivoting
- **DAX** – measures, calculated columns, row-level security expressions

## Project Workflow
The project followed a four-stage process:

```
Prepare & Explore  →  Set Dimensions  →  Set Facts  →  Polish (Secure & Validate)
```

**Prepare & Explore**
- Opened and reviewed all 23 source tables
- Understood the business context behind the data
- Classified each table as a dimension or a fact
- Identified "garbage": duplicate tables and junk columns

**Set Dimensions**
- Grouped tables belonging to the same entity
- Reshaped and merged them into a single clean dimension
- Applied naming and formatting standards
- Repeated for every entity (customer, product, etc.)

**Set Facts**
- Picked each business event and identified its grain
- Built fact tables from the most granular (detail) data
- Connected every fact to its shared dimensions
- Validated totals before vs. after every join

**Polish**
- Rechecked all naming/formatting standards
- Added a dynamic date dimension
- Built centralized DAX measures
- Implemented row-level security
- Performed final number validation

## Data Modeling Principles Followed
- **Build a Star Schema** – a central fact table surrounded by descriptive dimensions.
- **Facts never connect directly to facts** – they only relate through shared dimensions.
- **Understand the grain first** – always know what one row represents before transforming a table.
- **Columns must earn their place** – remove anything that doesn't support analysis.
- **Protect the numbers** – know your key totals (like total sales) and re-verify them after every merge or transformation.
- **One column, one place** – eliminate duplicate/redundant descriptive data across tables (single source of truth).

## Naming Standards
| Rule | Example |
|---|---|
| Single language (English) | `customer_name` |
| snake_case for all tables/columns | `dim_customer`, `fact_orders` |
| `dim_` prefix for dimensions | `dim_product`, `dim_date` |
| `fact_` prefix for fact tables | `fact_sales`, `fact_inventory` |
| `_key` suffix for surrogate keys (created in-model) | `product_key` |
| `_id` suffix for source system identifiers | `product_id` |
| Text values capitalized (each word) | `Online Store` |
| Friendly, business-readable names | No cryptic source codes exposed to end users |

## Phase-by-Phase Breakdown

### Phase 1 – Preparation & Investigation
- Reviewed each of the 23 tables to classify it as a dimension or fact
- Identified duplicate/junk tables and columns
- Organized Power Query into numbered folders:
  - `01_Stage` – raw source queries
  - `02_Dimensions` – cleaned dimension tables
  - `03_Facts` – cleaned fact tables
  - `04_Support` – security/configuration tables

### Phase 2 – Building Dimensions
- **Customer dimension**: consolidated `CUST_MASTER`, `customer_contacts`, `user_details`, `addresses`, `cities`, and `regions` into a single `dim_customer`, being careful not to "fan out" the grain when merging one-to-many contact data
- **Product dimension**: merged `products` and `subcategories` into `dim_product`
- Used techniques such as filtering, merging (joins), removing duplicates, grouping, splitting (by row/column), transforming (capitalize, pivot, unpivot, trim), and renaming to standard
- Created surrogate keys via index columns where the source lacked a unique identifier

### Phase 3 – Building Fact Tables
- Source order data (`orders_2025`, `orders_2026`, `order_line_items`, `sales_targets`) was split into **Header** (order-level: company, order date, status, bill-to, ship-to, payment type) and **Details** (line-item level: products ordered)
- Built the fact table from the **Details**, since detail data can always be rolled up to header level but not the reverse
- Combined `orders_2025` and `orders_2026` into a single orders table and removed unnecessary columns
- Extracted low-level, unrelated flags from the orders table into a **junk dimension**
- Removed pre-aggregated totals from the header in favor of the true line-item total in the fact table
- Removed descriptive fields (e.g., ship city, bill city) from the fact table where they belonged in a dimension instead
- Validated that totals before and after every join with a dimension matched exactly

### Phase 4 – Polishing & Finalizing
- Standardized all date columns to a single format (`YYYY-MM-DD`)
- Built a dynamic `dim_date` using `CALENDARAUTO()` to bridge all fact tables for time intelligence
- Disabled default summarization on non-additive columns (e.g., Budget, Year) — set to "Don't Summarize" or "Average"
- Centralized all DAX measures into a dedicated `_Measures` table to avoid conflicting logic across developers
- Implemented Row-Level Security (RLS) using a security table and `USERPRINCIPALNAME()`
- Performed a final validation pass against source numbers

## Fact Table Types Built
| Fact Type | Description |
|---|---|
| **Fact Sales** | Core transactional table built from order line-item details |
| **Fact Inventory** | Built by unpivoting monthly inventory columns into a date-based structure |
| **Factless Fact** | A mapping table (e.g., campaign → product) that tracks occurrences/relationships without any numeric measures |
| **Accumulating Snapshot Fact** (`fact_orders_processes`) | One row per order, capturing every milestone date (Order → Ship → Deliver → Pay) to analyze process duration |

Other supporting tables: `fact_campaign_spend` and `dim_campaign`, built from `campaign_log` and `campaign_sku`.

## DAX Measures & Calculated Columns
```DAX
base_total_customers   = COUNT(dim_customer[customer_id])
total_active_customers = DISTINCTCOUNT(fact_sales[customer_id])
total_orders            = DISTINCTCOUNT(fact_sales[order_id])
total_sales              = SUM(fact_sales[line_total])
order_to_pay            = DATEDIFF(fact_orders_processes[order_date], fact_orders_processes[pay_date], DAY)
average_order_to_pay    = AVERAGE(fact_orders_processes[order_to_pay])

region_name = LOOKUPVALUE(security[region], security[user_email], USERPRINCIPALNAME())
```
**Note:** Dimension counts use `COUNT`; fact table counts on text/categorical columns use `DISTINCTCOUNT` to avoid over-counting across repeated keys.

## Row-Level Security
A dedicated `security` support table maps each user's email to a region. The `region_name` measure uses `LOOKUPVALUE` with `USERPRINCIPALNAME()` to dynamically filter the model so each user only sees data relevant to their assigned region.

## Key Learnings
- Data modeling is often skipped in favor of visuals, but a weak model produces wrong numbers and poor performance regardless of how good the dashboard looks.
- Turning a chaotic, disconnected dataset into a clean star-schema (or "Galaxy" schema, when multiple facts share dimensions) is a rare and highly valued skill.
- Spend more time in analysis and exploration up front — it prevents far more costly errors during the build phase.
- Protecting the core model matters: build only the essential shared facts and dimensions in the main model, and handle special/edge cases in a separate model rather than complicating the core.

---

## Author
Project based on personal hands-on work following the "Data with Baraa" Power BI data modeling project methodology.

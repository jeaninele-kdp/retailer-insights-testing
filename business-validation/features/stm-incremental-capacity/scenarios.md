# Scenarios — STM incremental capacity

Derived from **STM Business Scenarios** workshop document. Confirmed rules in [business-rules.md](business-rules.md).

| ID | Section | Theme | Status |
|----|---------|-------|--------|
| STM-IC-01 | §2 Ex.1 | One STM, multiple promotions — **closest IC wins** | Ready to test |
| STM-IC-02 | §2 Ex.2 | One STM, multiple promotions — **FIFO tie** | Ready to test |
| STM-IC-03 | §3 Ex.1 | Multiple STMs, one promotion — quantity selection | **Blocked** (open rule) |
| STM-IC-04 | §3 Ex.2 | Multiple STMs, one promotion — 40 vs 0 | **Blocked** |
| STM-IC-05 | §3 Ex.3 | Long-period STM vs short campaign STM | **Blocked** |
| STM-IC-06 | §4 Ex.1 | Multiple STMs + multiple promotions | **Blocked** |
| STM-IC-07 | §5 | Business decisions / tie-breakers | Discovery |

---

## STM-IC-01 — Closest promotion wins

**Rules:** BR-STM-003, BR-STM-005, BR-STM-006

| Field | Value |
|-------|--------|
| Customer | `0012509760` |
| Material | `000000000010000852` |
| Bus date | `2026-09-08` |
| STM | STMID **3392**, quantity **4** |

| Promotion | IC before | \|IC − STM\| | IC after | Result |
|-----------|-----------|--------------|----------|--------|
| A&W Root Beer Float - Transition to Gondola | 3 | **1** (closest) | **4** | Replaced |
| A&W Root Beer Float - LTO Shipper | 10 | 6 | 10 | Unchanged |
| 2026 Halloween Gondola | 30 | 26 | 30 | Unchanged |
| Load the Lobby 12PK | 32 | 28 | 32 | Unchanged |

**Expected:** Only the promotion with IC **3** changes to **4**; all others unchanged.

---

## STM-IC-02 — Equal-distance tie (FIFO)

**Rules:** BR-STM-004, BR-STM-003, BR-STM-005

| Field | Value |
|-------|--------|
| Customer | `0012326182` |
| Material | `000000000010174282` |
| Bus date | `2026-07-14` |
| STM | STMID **3141**, quantity **48** |

| Promotion | Start | End | IC before | IC after | Result |
|-----------|-------|-----|-----------|----------|--------|
| 7UP Endless Summer LTO | 2026-05-04 | 2026-07-14 | 52 | 48 | **Changed** (FIFO winner among ties) |
| CSD 12PK B3G3F | 2026-07-08 | 2026-07-14 | 44 | 44 | Unchanged |
| Texas Truck Load Sale | 2026-07-08 | 2026-07-14 | 52 | 52 | Unchanged |
| Mexican National Team Partnership | 2026-04-06 | 2026-07-14 | 54 | 54 | Unchanged |

**Business explanation:** Among promotions equally close to STM quantity **48**, FIFO selects **7UP Endless Summer** (earliest start among tied). Only that promotion moves **52 → 48**.

**Note:** Workshop title mentions “smallest IC” tie-break; narrative confirms **FIFO by start date**. Align implementation with signed business rule BR-STM-004.

**Open:** Same start date on tied promotions → REQ-STM-011.

---

## STM-IC-03 — Multiple STMs, one promotion (Example 1)

**Status:** Blocked — rule not defined.

| Field | Value |
|-------|--------|
| Customer | `0011318780` |
| Material | `000000000010156397` |
| Promotion dates | 2025-04-16 – 2025-04-19 |
| Promotion | MANDATORY CSD 12PK B2G3F |
| IC | 10 → **2 + 64** (ambiguous) |

| STMID | Start | End | Total ordered |
|-------|-------|-----|---------------|
| 2419 | 2025-04-05 | 2025-04-19 | **2** |
| 2423 | 2025-04-03 | 2025-04-19 | **64** |

**Question:** Should STM quantity be **2** or **64**? Does later STMID replace earlier?

---

## STM-IC-04 — Multiple STMs, one promotion (Example 2)

| Customer | `0011315060` |
| Material | `000000000010174169` |
| Promotion | MANDATORY Ghost Energy Launch |
| Dates | 2025-03-11 – 2025-03-21 |
| IC | 12 → **0 + 40** |

| STMID | Total ordered |
|-------|---------------|
| 2292 | 40 |
| 2350 | **0** |

**Question:** STM quantity **40** or **0**? Zero override rule? (REQ-STM-010)

---

## STM-IC-05 — Multiple STMs, one promotion (Example 3)

| Customer | `0011197040` |
| Material | `000000000010156395` |
| Promotion | MANDATORY CSD 12PK B2G3F |
| IC | 20 |

| STMID | Period | Total ordered |
|-------|--------|---------------|
| 2224 | 2024-12-26 – 2025-12-29 | 3 |
| 2242 | 2025-04-07 – 2025-04-19 | **0** |

**Question:** Year-long STM vs short campaign during same promotion days.

---

## STM-IC-06 — Multiple STMs + multiple promotions

**Customer:** `0011199662` · **Material:** `000000000010001096` · **Bus date:** `2025-08-18`

| STMID | Period | STM qty |
|-------|--------|---------|
| 2224 (A) | 2024-12-26 – 2025-12-29 | 7 |
| 2597 (B) | 2025-08-01 – 2025-08-26 | 2 |

Promotions include CSD A&W 20OZ 2/$3, A&W Ice Cream Sundae LTO, Texas Truck Load Sale — full IC matrix in source document.

**Status:** Blocked until multi-STM selection rule (REQ-STM-008) and STM quantity field (REQ-STM-009) are confirmed.

---

## STM-IC-07 — Business decisions needed

| Question | Requirement |
|----------|-------------|
| Which STMID when multiple active for same customer, material, bus date? | REQ-STM-008 |
| Final tie-breaker when FIFO ties share start date? | REQ-STM-011 |
| Which STM quantity field drives replacement? | REQ-STM-009 |
| TotalOrderedQty = 0 — still override promotion IC? | REQ-STM-010 |

Track answers in `requirements.md` and promote scenarios from **Blocked** to **Ready** when approved.

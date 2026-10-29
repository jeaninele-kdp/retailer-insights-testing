# Business rules — NDT POG shelf capacity

## BR-SOC-001 — POG capacity drives Perfect Order shelf capacity

For the **10 in-scope chains**, `Max_ShelfCapacityQty` in the applicable Perfect Order prediction fact must equal:

```text
ExpectedMaxShelf = AdjustedPOGCapacity × ConvFactorToBase
```

Where `ConvFactorToBase` comes from SAP alternate units (SU, then PC, then EA, else 1) for the material tied to POG `EAN11`.

Tolerance used in validation SQL: **±0.0001**.

---

## BR-SOC-002 — Zero POG capacity adjustment

When POG **`Capacity = 0`**, use **3** as the adjusted capacity **before** case conversion:

```text
AdjustedPOGCapacity = IFF(Capacity = 0, 3, Capacity)
```

This rule applies **only** to the 10 approved chains (negative testing confirms no leakage to out-of-scope retailers).

---

## BR-SOC-003 — Scope containment

POG-derived shelf capacity logic must **not** change `Max_ShelfCapacityQty` for national chains **outside** the approved list (except documented negative-control POG retailers used for leakage tests).

---

## BR-SOC-004 — Model routing

| Retailer pattern | Primary prediction fact |
|----------------|-------------------------|
| Shipment chains (e.g. AMPM/BP OIL, Circle K, Racetrac, Wawa, CVS) | `Fact_CustItemOrderShpmntPredicted` |
| Maverik | `Fact_CustItemOrderUDSPredicted` |
| Casey's, Murphy, Pilot, Yesway (account-level POG) | `Fact_CustItemOrderNPSalesPredicted_SF` |

Population SQL splits accordingly (`population-results-*.sql`).

---

## BR-SOC-005 — Late delivery / ranking (open)

Some non-pass rows may reflect **late delivery** ranking: a row with correct capacity is ranked then filtered, leaving a visible delivery with `Max_ShelfCapacityQty = 0`. Under review per validation report — not a confirmed capacity formula defect.

---

## Related — Walmart suggested order selection (BR-WMT-SOQ)

Documented with [Walmart PO validation](../walmart-purchase-order-data-validation/business-rules.md):

| Condition | Selected quantity |
|-----------|-------------------|
| Walmart suggested order **>** PO suggested | Walmart |
| Walmart suggested order **≤** PO suggested | PO suggested |

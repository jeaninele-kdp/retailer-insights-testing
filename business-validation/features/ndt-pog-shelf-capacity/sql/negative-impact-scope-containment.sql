-- Test 1: population containment by chain and model
WITH inscope AS (SELECT column1 n FROM VALUES ('BP OIL'),('CASEY''S GENERAL STORE'),('CIRCLE K'),('CVS/PHARMACY'),
        ('MAVERIK COUNTRY STORE'),('MURPHY USA INC'),('PILOT FLYING J'),('RACETRAC'),('WAWA'),('YESWAY')),
acc AS (SELECT LTRIM("AccountID",'0') a, MAX("NationalChainName") chain, MAX("NationalChainID") chain_id
        FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Account" GROUP BY 1),
cc AS (SELECT DISTINCT LTRIM(E."SAPMaterialID",'0') mat, LTRIM(E.EAN11,'0') ean,
              COALESCE(SU."ConvFactorToBase",PC."ConvFactorToBase",EA."ConvFactorToBase",1) conv
       FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod" E
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" SU ON SU.MDM_ID=E.MDM_ID AND SU."AltUnitID"='SU'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" PC ON PC.MDM_ID=E.MDM_ID AND PC."AltUnitID"='PC'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" EA ON EA.MDM_ID=E.MDM_ID AND EA."AltUnitID"='EA'
       WHERE E."SAPMaterialID" IS NOT NULL),
-- ALL POG retailers (not just the 10), so leakage would be detectable
pm AS (SELECT LTRIM(p."AccountID",'0') acct, cc.mat, p."EffectiveStartDate" sd, COALESCE(p."EffectiveEndDate",'9999-12-31') ed,
              MAX(p."Retailer") pog_ret, MAX(IFF(p."Capacity"=0,3,p."Capacity")) adj, MIN(p."Capacity") min_cap, MAX(cc.conv) conv
       FROM RETAILER_PROD.POG."V_Fact_POG" p JOIN cc ON cc.ean=LTRIM(p.EAN11,'0')
       WHERE p."AccountID" IS NOT NULL GROUP BY 1,2,3,4),
tgt AS (
  SELECT 'Shipment' m, LTRIM("CustomerNumber",'0') c, LTRIM("MaterialNumber",'0') mat, "DeliveryDate" dd, MAX("Max_ShelfCapacityQty") msc
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderShpmntPredicted" WHERE "DeliveryDate" IS NOT NULL GROUP BY 1,2,3,4
  UNION ALL SELECT 'UDS', LTRIM("CustomerNumber",'0'), LTRIM("MaterialNumber",'0'), "DeliveryDate", MAX("Max_ShelfCapacityQty")
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderUDSPredicted" WHERE "DeliveryDate" IS NOT NULL GROUP BY 1,2,3,4
  UNION ALL SELECT 'NP Sales', LTRIM("CustomerNumber",'0'), LTRIM("MaterialNumber",'0'), "DeliveryDate", MAX("Max_ShelfCapacityQty")
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderNPSalesPredicted_SF" WHERE "DeliveryDate" IS NOT NULL GROUP BY 1,2,3,4),
j AS (SELECT t.m, COALESCE(a.chain,'(no V_Dim_Account match)') chain, a.chain_id, t.c, t.msc, pm.pog_ret, pm.adj, pm.min_cap, pm.conv
      FROM tgt t LEFT JOIN acc a ON a.a=t.c
      LEFT JOIN pm ON pm.acct=t.c AND pm.mat=t.mat AND t.dd BETWEEN pm.sd AND pm.ed)
SELECT chain, chain_id, m, IFF(chain IN (SELECT n FROM inscope),'Yes','No') in_scope,
       COUNT(*) rows_, COUNT(DISTINCT c) customers, COUNT_IF(msc>0) rows_msc_gt0,
       COUNT_IF(pog_ret IS NOT NULL) rows_traceable_to_pog, MAX(pog_ret) pog_retailer,
       COUNT_IF(pog_ret IS NOT NULL AND msc>0 AND ABS(msc-adj*conv)<=0.0001) rows_match_formula,
       COUNT_IF(pog_ret IS NOT NULL AND min_cap=0 AND msc>0 AND ABS(msc-3*conv)<=0.0001) rows_match_zero_to_3
FROM j GROUP BY 1,2,3,4 ORDER BY in_scope DESC, m, rows_ DESC;

-- Tests 3 & 4: zero-rule leakage and negative-control examples for out-of-scope chains with POG data
WITH inscope AS (SELECT column1 n FROM VALUES ('BP OIL'),('CASEY''S GENERAL STORE'),('CIRCLE K'),('CVS/PHARMACY'),
        ('MAVERIK COUNTRY STORE'),('MURPHY USA INC'),('PILOT FLYING J'),('RACETRAC'),('WAWA'),('YESWAY')),
acc AS (SELECT LTRIM("AccountID",'0') a, MAX("NationalChainName") chain, MAX("NationalChainID") chain_id
        FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Account" GROUP BY 1),
cc AS (SELECT LTRIM(E."SAPMaterialID",'0') mat, LTRIM(E.EAN11,'0') ean,
              MAX(COALESCE(SU."ConvFactorToBase",PC."ConvFactorToBase",EA."ConvFactorToBase",1)) conv
       FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod" E
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" SU ON SU.MDM_ID=E.MDM_ID AND SU."AltUnitID"='SU'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" PC ON PC.MDM_ID=E.MDM_ID AND PC."AltUnitID"='PC'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" EA ON EA.MDM_ID=E.MDM_ID AND EA."AltUnitID"='EA'
       WHERE E."SAPMaterialID" IS NOT NULL GROUP BY 1,2),
-- out-of-scope POG retailers that map to Perfect Order customers
pm AS (SELECT LTRIM(p."AccountID",'0') acct, cc.mat, p."EffectiveStartDate" sd, COALESCE(p."EffectiveEndDate",'9999-12-31') ed,
              MAX(p."Retailer") pog_ret, MAX(p."Store") store, MAX(p."Capacity") cap,
              MAX(IFF(p."Capacity"=0,3,p."Capacity")) adj, MAX(cc.conv) conv
       FROM RETAILER_PROD.POG."V_Fact_POG" p JOIN cc ON cc.ean=LTRIM(p.EAN11,'0')
       WHERE p."AccountID" IS NOT NULL AND p."Retailer" IN ('EG GROUP','UDS','SPARTAN NASH','LOVES')
       GROUP BY 1,2,3,4),
tgt AS (
  SELECT 'Shipment' m, "CustomerNumber" cust, "MaterialNumber" matraw, LTRIM("CustomerNumber",'0') c, LTRIM("MaterialNumber",'0') mat,
         "DeliveryDate" dd, "Max_ShelfCapacityQty" msc
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderShpmntPredicted" WHERE "DeliveryDate" > CURRENT_DATE
  UNION ALL SELECT 'UDS', "CustomerNumber", "MaterialNumber", LTRIM("CustomerNumber",'0'), LTRIM("MaterialNumber",'0'), "DeliveryDate", "Max_ShelfCapacityQty"
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderUDSPredicted" WHERE "DeliveryDate" > CURRENT_DATE
  UNION ALL SELECT 'NP Sales', "CustomerNumber", "MaterialNumber", LTRIM("CustomerNumber",'0'), LTRIM("MaterialNumber",'0'), "DeliveryDate", "Max_ShelfCapacityQty"
    FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderNPSalesPredicted_SF" WHERE "DeliveryDate" > CURRENT_DATE),
j AS (SELECT t.*, a.chain, a.chain_id, pm.pog_ret, pm.store, pm.cap, pm.adj, pm.conv, pm.adj*pm.conv value_if_leaked
      FROM tgt t JOIN acc a ON a.a=t.c
      JOIN pm ON pm.acct=t.c AND pm.mat=t.mat AND t.dd BETWEEN pm.sd AND pm.ed
      WHERE a.chain NOT IN (SELECT n FROM inscope))
SELECT 'SUMMARY' kind, chain, chain_id, m, pog_ret,
       NULL cust, NULL matraw, NULL dd, NULL store, NULL cap, NULL conv, NULL value_if_leaked, NULL msc,
       COUNT(*) traced_rows, COUNT_IF(cap=0) traced_cap0_rows, COUNT_IF(msc<>0) nonzero_msc,
       COUNT_IF(cap=0 AND ABS(msc-3*conv)<=0.0001) zero_to_3_matches,
       COUNT_IF(ABS(msc-value_if_leaked)<=0.0001) formula_matches
FROM j GROUP BY 2,3,4,5
UNION ALL
-- one example per chain / model / capacity group (0 vs positive)
SELECT 'EXAMPLE', chain, chain_id, m, pog_ret, cust, matraw, dd, store, cap, conv, value_if_leaked, msc, NULL, NULL, NULL, NULL, NULL
FROM j
QUALIFY ROW_NUMBER() OVER (PARTITION BY chain, m, IFF(cap=0,0,1) ORDER BY dd, HASH(c,mat)) = 1
ORDER BY 1 DESC, 2, 4;
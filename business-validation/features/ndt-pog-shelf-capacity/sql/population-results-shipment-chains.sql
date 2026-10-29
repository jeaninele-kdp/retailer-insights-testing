-- Funnel + PASS/FAIL (first upcoming delivery per customer/material)
WITH xw AS (SELECT * FROM VALUES ('AMPM','BP OIL'),('CIRCLE K','CIRCLE K'),('RACETRAC','RACETRAC'),
            ('WAWA','WAWA'),('CVS','CVS/PHARMACY') v(r,n)),
pog AS (SELECT "Retailer" r, LTRIM(TRIM("Store"),'0') st, LTRIM(EAN11,'0') ean, IFF("Capacity"=0,3,"Capacity") adj,
               "EffectiveStartDate" sd, COALESCE("EffectiveEndDate",'9999-12-31') ed
        FROM RETAILER_PROD.POG."V_Fact_POG" WHERE "Retailer" IN (SELECT r FROM xw)),
acc AS (SELECT DISTINCT "NationalChainName" n, LTRIM(TRIM("StoreNbr"),'0') st, LTRIM("AccountID",'0') acct
        FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Account" WHERE TRIM("StoreNbr")<>''),
rs AS (SELECT DISTINCT r, st FROM pog),
m AS (SELECT rs.r, rs.st, a.acct FROM rs JOIN xw ON xw.r=rs.r JOIN acc a ON a.n=xw.n AND a.st=rs.st),
tgt AS (SELECT LTRIM("CustomerNumber",'0') c, LTRIM("MaterialNumber",'0') mat, "DeliveryDate" dd, "Max_ShelfCapacityQty" msc,
               MIN(IFF("DeliveryDate">=CURRENT_DATE,"DeliveryDate",NULL)) OVER (PARTITION BY c, mat) first_dd
        FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderShpmntPredicted"
        WHERE LTRIM("CustomerNumber",'0') IN (SELECT acct FROM m)),
cc AS (SELECT DISTINCT LTRIM(E."SAPMaterialID",'0') mat, LTRIM(E.EAN11,'0') ean,
              COALESCE(SU."ConvFactorToBase",PC."ConvFactorToBase",EA."ConvFactorToBase",1) conv
       FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod" E
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" SU ON SU.MDM_ID=E.MDM_ID AND SU."AltUnitID"='SU'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" PC ON PC.MDM_ID=E.MDM_ID AND PC."AltUnitID"='PC'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" EA ON EA.MDM_ID=E.MDM_ID AND EA."AltUnitID"='EA'
       WHERE E."SAPMaterialID" IS NOT NULL),
pm AS (SELECT p.r, m.acct, cc.mat, p.sd, p.ed, MAX(p.adj) adj, MAX(cc.conv) conv   -- pipeline takes MAX capacity
       FROM pog p JOIN m ON m.r=p.r AND m.st=p.st JOIN cc ON cc.ean=p.ean GROUP BY 1,2,3,4,5),
j AS (SELECT pm.*, t.dd, t.msc, t.first_dd, ABS(t.msc - pm.adj*pm.conv) <= 0.0001 ok
      FROM pm JOIN tgt t ON t.c=pm.acct AND t.mat=pm.mat AND t.dd BETWEEN pm.sd AND pm.ed),
f1 AS (SELECT r, COUNT(*) pog_stores FROM rs GROUP BY 1),
f2 AS (SELECT r, COUNT(DISTINCT st) store_match, COUNT(DISTINCT acct) accts_found,
              COUNT(DISTINCT IFF(acct IN (SELECT c FROM tgt),acct,NULL)) accts_in_target FROM m GROUP BY 1),
f3 AS (SELECT r, COUNT(DISTINCT acct||'|'||mat) pairs, COUNT_IF(dd=first_dd) first_rows,
              COUNT_IF(dd=first_dd AND ok) first_pass, COUNT_IF(dd=first_dd AND NOT ok) first_fail FROM j GROUP BY 1)
SELECT xw.r, xw.n, f1.pog_stores, f2.store_match, f2.accts_found, f2.accts_in_target,
       f3.pairs, f3.first_rows, f3.first_pass, f3.first_fail
FROM xw LEFT JOIN f1 ON f1.r=xw.r LEFT JOIN f2 ON f2.r=xw.r LEFT JOIN f3 ON f3.r=xw.r ORDER BY 1;

-- Detail / examples: same CTEs (xw without CVS), keeping only the POG record's own account
--   JOIN acc a ON a.n = xw.n AND a.st = p.st AND LTRIM(a.acct,'0') = p.pacct
-- and returning store, EAN11, ProductName, Capacity, adjusted capacity, StoreNbr, AccountID, CustomerNumber,
-- SAPMaterialID, MaterialNumber, conversion type (SU/PC/EA/DEFAULT), ConvFactorToBase, expected = adj * conv,
-- DeliveryDate, actual, difference, and PASS/FAIL at ±0.0001.
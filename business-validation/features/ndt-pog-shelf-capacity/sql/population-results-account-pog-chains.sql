WITH pog AS (SELECT "Retailer" r, LTRIM("AccountID",'0') acct, LTRIM(EAN11,'0') ean, IFF("Capacity"=0,3,"Capacity") adj,
                    "EffectiveStartDate" sd, COALESCE("EffectiveEndDate",'9999-12-31') ed
             FROM RETAILER_PROD.POG."V_Fact_POG"
             WHERE "Retailer" IN ('CASEYS','MAVERIK','MURPHY OIL USA','PILOT FLYING J','YESWAY') AND "AccountID" IS NOT NULL),
cc AS (SELECT DISTINCT LTRIM(E."SAPMaterialID",'0') mat, LTRIM(E.EAN11,'0') ean,
              COALESCE(SU."ConvFactorToBase",PC."ConvFactorToBase",EA."ConvFactorToBase",1) conv
       FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod" E
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" SU ON SU.MDM_ID=E.MDM_ID AND SU."AltUnitID"='SU'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" PC ON PC.MDM_ID=E.MDM_ID AND PC."AltUnitID"='PC'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" EA ON EA.MDM_ID=E.MDM_ID AND EA."AltUnitID"='EA'
       WHERE E."SAPMaterialID" IS NOT NULL),
tgt AS (SELECT 'UDS' m, LTRIM("CustomerNumber",'0') c, LTRIM("MaterialNumber",'0') mat, "DeliveryDate" dd, "Max_ShelfCapacityQty" msc
        FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderUDSPredicted"
        WHERE LTRIM("CustomerNumber",'0') IN (SELECT acct FROM pog WHERE r='MAVERIK')
        UNION ALL
        SELECT 'NPS', LTRIM("CustomerNumber",'0'), LTRIM("MaterialNumber",'0'), "DeliveryDate", "Max_ShelfCapacityQty"
        FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderNPSalesPredicted_SF"
        WHERE LTRIM("CustomerNumber",'0') IN (SELECT acct FROM pog WHERE r<>'MAVERIK')),
-- deliveries that already have an order (rnk = NULL in the pipeline)
ord AS (SELECT 'UDS' m, LTRIM("CustomerNumber",'0') c, LTRIM("MaterialNumber",'0') mat, "DeliveryDate" dd
        FROM SOLUTIONS_QA.COMML_SALES."Fact_PerfectOrderShpmnt_ML_Inbound" WHERE "OrderDate" IS NOT NULL AND "DeliveryDate" >= '2026-10-15'
        UNION
        SELECT 'NPS', LTRIM("CustomerNumber",'0'), LTRIM("ItemNumber",'0'), "DeliveryDate"
        FROM SALES_PROD."ORDER"."V_Fact_DSD_OriginalOrder"
        WHERE "Type"='O' AND "OrderStatus" NOT IN (-1,-2,99) AND "DeliveryDate" >= '2026-10-15'),
pm AS (SELECT p.r, p.acct, cc.mat, p.sd, p.ed, MAX(p.adj) adj, MAX(cc.conv) conv
       FROM pog p JOIN cc ON cc.ean=p.ean GROUP BY 1,2,3,4,5),
j0 AS (SELECT DISTINCT pm.r, t.m, pm.acct, pm.mat, pm.adj*pm.conv exp, t.dd, t.msc, (o.c IS NOT NULL) ordered
       FROM pm JOIN tgt t ON t.c=pm.acct AND t.mat=pm.mat AND t.m=IFF(pm.r='MAVERIK','UDS','NPS')
                         AND t.dd BETWEEN pm.sd AND pm.ed
       LEFT JOIN ord o ON o.m=t.m AND o.c=t.c AND o.mat=t.mat AND o.dd=t.dd),
j AS (SELECT *, IFF(NOT ordered AND dd > '2026-10-23',
                    ROW_NUMBER() OVER (PARTITION BY r, acct, mat, (NOT ordered AND dd > '2026-10-23') ORDER BY dd), NULL) rnk
      FROM j0),
k AS (SELECT *, ABS(msc - IFF(rnk > 1, 0, exp)) <= 0.0001 ok, IFF(rnk > 1, 'zero', 'capacity') bucket FROM j)
SELECT r, MAX(m) tbl, COUNT(DISTINCT acct||'|'||mat) pairs,
       COUNT_IF(bucket='capacity') capacity_rows, COUNT_IF(bucket='capacity' AND ok) cap_pass,
       COUNT_IF(bucket='capacity' AND NOT ok) cap_fail,
       COUNT_IF(bucket='zero' AND ok) zero_pass, COUNT_IF(bucket='zero' AND NOT ok) zero_fail
FROM k GROUP BY 1 ORDER BY 1;
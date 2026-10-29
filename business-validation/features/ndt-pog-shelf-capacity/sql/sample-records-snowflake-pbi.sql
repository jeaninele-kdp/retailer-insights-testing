WITH pick AS (SELECT column1 ex, column2 r, column3 m, column4 acct, column5 ean11, column6 dd FROM VALUES
   (1,'MAVERIK','UDS','12098470','88772500065','2026-11-03'),
   (2,'YESWAY','NPS','12860156','07800003877','2026-10-27'),
   (3,'RACETRAC','SHP','12003848','07800002036','2026-10-27'),
   (4,'CASEYS','NPS','13032630','84259513509','2026-10-27'),
   (5,'CVS','SHP','11333906','07153700365','2026-11-06'),
   (6,'AMPM','SHP','11977343','07800003767','2026-10-27')),
pog AS (SELECT k.ex, k.m, k.dd::DATE dd, p."Retailer", p."Store", p."AccountID", p.EAN11, p."ProductName", p."Capacity",
               IFF(p."Capacity"=0,3,p."Capacity") adj, p."EffectiveStartDate", COALESCE(p."EffectiveEndDate",'9999-12-31') ed
        FROM pick k JOIN RETAILER_PROD.POG."V_Fact_POG" p
          ON p."Retailer"=k.r AND LTRIM(p."AccountID",'0')=k.acct AND p.EAN11=k.ean11
        WHERE k.dd::DATE BETWEEN p."EffectiveStartDate" AND COALESCE(p."EffectiveEndDate",'9999-12-31')),
cc AS (SELECT E."SAPMaterialID", LTRIM(E.EAN11,'0') ean, E."MaterialDesc",
              COALESCE(SU."ConvFactorToBase",PC."ConvFactorToBase",EA."ConvFactorToBase",1) conv,
              CASE WHEN SU."ConvFactorToBase" IS NOT NULL THEN 'SU' WHEN PC."ConvFactorToBase" IS NOT NULL THEN 'PC'
                   WHEN EA."ConvFactorToBase" IS NOT NULL THEN 'EA' ELSE 'DEFAULT' END ctype
       FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Prod" E
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" SU ON SU.MDM_ID=E.MDM_ID AND SU."AltUnitID"='SU'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" PC ON PC.MDM_ID=E.MDM_ID AND PC."AltUnitID"='PC'
       LEFT JOIN MD_PROD.SAP."Dim_AltUnit" EA ON EA.MDM_ID=E.MDM_ID AND EA."AltUnitID"='EA'
       WHERE E."SAPMaterialID" IS NOT NULL),
tgt AS (SELECT 'SHP' m, 'Fact_CustItemOrderShpmntPredicted' tbl, "CustomerNumber", "DSD_CustomerNumber", "MaterialNumber", "DeliveryDate", "Max_ShelfCapacityQty"
          FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderShpmntPredicted"
        UNION ALL SELECT 'UDS', 'Fact_CustItemOrderUDSPredicted', "CustomerNumber", "DSD_CustomerNumber", "MaterialNumber", "DeliveryDate", "Max_ShelfCapacityQty"
          FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderUDSPredicted"
        UNION ALL SELECT 'NPS', 'Fact_CustItemOrderNPSalesPredicted_SF', "CustomerNumber", "DSD_CustomerNumber", "MaterialNumber", "DeliveryDate", "Max_ShelfCapacityQty"
          FROM DATA_PRODUCT_QA.RETAILER_INSIGHTS."Fact_CustItemOrderNPSalesPredicted_SF"),
acc AS (SELECT LTRIM("AccountID",'0') a, MAX("NationalChainName") chain FROM SOLUTIONS_PROD.COMMERCIALS."V_Dim_Account" GROUP BY 1)
SELECT p.ex,
       IFF(p."Capacity"=0,'POG Capacity = 0','POG Capacity > 0') grp,
       -- Power BI lookup columns
       acc.chain               AS "RetailerName",
       t."DSD_CustomerNumber"  AS "AccountNumber",
       t."CustomerNumber"      AS "AccountID",
       t."DeliveryDate",
       cc."MaterialDesc"       AS "SKUDescription",
       p."Capacity"            AS "POGCapacity",
       t."Max_ShelfCapacityQty",
       -- Evidence columns
       p."Retailer", p."Store" AS "POG_Store", p.EAN11, cc."SAPMaterialID", t."MaterialNumber", p."ProductName",
       p.adj AS "AdjustedCapacity", cc.ctype AS "ConversionType", cc.conv AS "ConvFactorToBase",
       p.adj*cc.conv AS "ExpectedMaxShelf",
       t."Max_ShelfCapacityQty" - p.adj*cc.conv AS "Difference",
       IFF(ABS(t."Max_ShelfCapacityQty" - p.adj*cc.conv) <= 0.0001,'PASS','FAIL') AS "Result",
       t.tbl AS "TargetTable"
FROM pog p
JOIN cc  ON cc.ean = LTRIM(p.EAN11,'0')
JOIN tgt t ON t.m = p.m
          AND LTRIM(t."CustomerNumber",'0') = LTRIM(p."AccountID",'0')
          AND LTRIM(t."MaterialNumber",'0') = LTRIM(cc."SAPMaterialID",'0')
          AND t."DeliveryDate" = p.dd
LEFT JOIN acc ON acc.a = LTRIM(t."CustomerNumber",'0')
ORDER BY p.ex;
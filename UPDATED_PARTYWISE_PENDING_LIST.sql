SELECT 
       OOH.ORDER_NUMBER DO_NUMBER,
       --OOL.REQUEST_DATE ORDER_DATE,
       TRUNC(OOH.ORDERED_DATE) ORDER_DATE,
       OOL.ORDERED_ITEM,
        MSIB.DESCRIPTION,
       OOL.ORDER_QUANTITY_UOM UNIT,
       SUM(OOL.ORDERED_QUANTITY) ORDERED_QUANTITY,
       SUM(OOL.SHIPPED_QUANTITY) SHIPPED_QUANTITY,
       SUM(OOL.ORDERED_QUANTITY)-SUM(OOL.SHIPPED_QUANTITY) BALANCE_QTY,
       OOL.UNIT_SELLING_PRICE,
       SUM(OOL.ORDERED_QUANTITY)*OOL.UNIT_SELLING_PRICE AS TOTAL_AMOUNT,
       OOH.ORG_ID,
       HOU.NAME,
       OOH.SOLD_TO_ORG_ID CUSTOMER_ID,
       AC.CUSTOMER_NAME PARTY_NAME
FROM APPS.OE_ORDER_HEADERS_ALL OOH,
     APPS.OE_ORDER_LINES_ALL OOL,
     APPS.XX_AR_CUSTOMERS_ALL_V AC,
     APPS.MTL_SYSTEM_ITEMS_B MSIB,
     APPS.HR_OPERATING_UNITS HOU
WHERE OOH.HEADER_ID = OOL.HEADER_ID
AND   OOH.SOLD_TO_ORG_ID =AC.CUSTOMER_ID
   AND MSIB.SEGMENT1=OOL.ORDERED_ITEM
   AND MSIB.ORGANIZATION_ID=OOH.ORG_ID
   AND OOH.ORG_ID=HOU.ORGANIZATION_ID
AND TRUNC (OOH.ORDERED_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE
AND (:P_ORG_ID IS NULL OR OOH.ORG_ID = :P_ORG_ID)
AND (:P_ORDER_NUMBER IS NULL OR OOH.ORDER_NUMBER = :P_ORDER_NUMBER)
AND (:P_CUSTOMER_ID IS NULL OR OOH.SOLD_TO_ORG_ID = :P_CUSTOMER_ID)
GROUP  BY
       OOH.ORDER_NUMBER,
       OOH.ORDERED_DATE ,
       OOL.ORDERED_ITEM,
        MSIB.DESCRIPTION,
       OOL.ORDER_QUANTITY_UOM ,
       OOL.UNIT_SELLING_PRICE,
       OOH.ORG_ID,
       HOU.NAME,
       OOH.SOLD_TO_ORG_ID,
       AC.CUSTOMER_NAME;
UPDATE PART
SET BARCODE = STRCAT('688367',
STRIND(
RSTRIND(
STRCAT('0000000',ITOA(PART.PART))
,1,7)
,1,13)
)
WHERE PART > 0
;








/*
SELECT SUPORDNUM, ORDNAME          
FROM PORDERS , PORDSTATS, SUPPLIERS 
WHERE SUPPLIERS.SUP = PORDERS.SUP
AND PORDERS.PORDSTAT  = PORDSTATS.PORDSTAT 
AND PORDERS.CLOSED <> 'Y' 
AND PORDSTATS.APPROVED = 'Y' 
AND SUPORDNUM  <> '' 
AND PORDERS.SUP = (SELECT SUP FROM SUPPLIERS WHERE SUPNAME='DAN50')
FORMAT;
*/

:ordname = 'APO0004730';

SELECT STRCAT(ORDNAME, '!*', SUPORDNUM, '*!')
FROM PORDERS WHERE ORDNAME = :ordname FORMAT;


SELECT STRCAT(PARTNAME, '!*', BARCODE, '*!', ITOA(TQUANT/1000)) 
FROM PORDERITEMS, PART 
WHERE PART.PART = PORDERITEMS.PART 
AND ORD = (SELECT ORD FROM PORDERS WHERE ORDNAME = :ordname)
FORMAT;
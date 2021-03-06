echo Begin of Upgrade 7.0.3
DBI <<\EOF
CREATE TABLE ZPDA_ANSWERS_LOAD 'ZPDA_ANSWERS_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
CURDATE (DATE,8,'CURDATE')
DOCNO (CHAR,20,'DOCNO')
QUESTF (CHAR,20,'QUESTF')
QUESTNUM (INT,13,'QUESTNUM')
ANSNUM (INT,13,'ANSNUM')
ANSTEXT (CHAR,255,'ANSTEXT')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_CALLCANCEL 'ZPDA_CALLCANCEL' 0
DOCNO (CHAR,20,'DOCNO')
USERNAME (CHAR,255,'USER')
UNIQUE (DOCNO,USERNAME)
;
CREATE TABLE ZPDA_CLEANTABLE 'PDA Loading Clean Up' 0
LOADID (INT,17,'Load ID')
LINE (INT,17,'Ln')
UNIQUE (LOADID,LINE)
;
CREATE TABLE ZPDA_DAYEND_LOAD 'ZPDA_DAYEND_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
USERNAME (CHAR,255,'USER')
CURDATE (DATE,8,'CURDATE')
DAYEND (TIME,5,'DAYEND')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_FLAGS_LOAD 'ZPDA_FLAGS_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
MALFCODE (CHAR,255,'MALFCODE')
RESCODE (CHAR,255,'RESCODE')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_IMP_TIME 'Load PDA time data' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,32,'DOCNO')
CURDATE (CHAR,32,'CURDATE')
STIME (CHAR,32,'STIME')
ETIME (CHAR,32,'ETIME')
PARTNAME (CHAR,32,'PARTNAME')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_KANBAN_PART 'Kanban parts for PDA' 1
PART (INT,13,'Part (ID)')
UNIQUE (PART)
;
CREATE TABLE ZPDA_PART_LOAD 'ZPDA_PART_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
CURDATE (DATE,8,'CURDATE')
WARHS (CHAR,255,'WARHS')
PARTNAME (CHAR,255,'PARTNAME')
QTY (INT,13,'QTY')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_REPAIR_LOAD 'ZPDA_REPAIR_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
REPAIRTEXT (CHAR,255,'REPAIRTEXT')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_SFDAYEND 'ZPDA_SFDAYEND' 0
USERID (INT,13,'USER')
CURDATE (DATE,8,'CURDATE')
DAYEND (TIME,5,'DAYEND')
UNIQUE (USERID,CURDATE)
;
CREATE TABLE ZPDA_SIG_LOAD 'ZPDA_SIG_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
SIGNAME (CHAR,255,'SIGNAME')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_STATUS_LOAD 'ZPDA_STATUS_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
STATDES (CHAR,255,'STATDES')
UNIQUE (LINE)
;
CREATE TABLE ZPDA_SURVEYSIGN 'ZPDA_SURVEYSIGN' 0
DOCNO (CHAR,20,'DOCNO')
QUESTF (CHAR,20,'QUESTF')
SIGNAME (CHAR,255,'SIGNAME')
UNIQUE (DOCNO,QUESTF)
;
CREATE TABLE ZPDA_TIME_LOAD 'ZPDA_TIME_LOAD' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,8,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
DOCNO (CHAR,255,'DOCNO')
USERNAME (CHAR,255,'USER')
CURDATE (DATE,8,'CURDATE')
ONROUTE (TIME,5,'ONROUTE')
ONSITE (TIME,5,'ONSITE')
ENDCALL (TIME,5,'ENDCALL')
UNIQUE (LINE)
;
EOF
BRING << \EOF
18 17 ZPDA_ANSWERS_LOAD0 
56 17 ZPDA_ANSWERS_LOAD17 ZPDA_ANSWERS_LOAD0 
19 17 ZPDA_ANSWERS_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 17 ZPDA_ANSWERS_LOAD2 4 LINE3 INT8 8 2 Ln
33 17 ZPDA_ANSWERS_LOAD4 LINE0 48 
19 17 ZPDA_ANSWERS_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 17 ZPDA_ANSWERS_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 17 ZPDA_ANSWERS_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 17 ZPDA_ANSWERS_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 17 ZPDA_ANSWERS_LOAD7 7 CURDATE4 DATE8 8 7 CURDATE
19 17 ZPDA_ANSWERS_LOAD8 5 DOCNO4 CHAR20 20 5 DOCNO
19 17 ZPDA_ANSWERS_LOAD9 6 QUESTF4 CHAR20 20 6 QUESTF
19 17 ZPDA_ANSWERS_LOAD10 8 QUESTNUM3 INT13 8 8 QUESTNUM
33 17 ZPDA_ANSWERS_LOAD8 QUESTNUM0 48 
19 17 ZPDA_ANSWERS_LOAD11 6 ANSNUM3 INT13 8 6 ANSNUM
33 17 ZPDA_ANSWERS_LOAD6 ANSNUM0 48 
19 17 ZPDA_ANSWERS_LOAD12 7 ANSTEXT4 CHAR255 255 7 ANSTEXT
20 17 ZPDA_ANSWERS_LOAD85 1 
21 17 ZPDA_ANSWERS_LOAD1 4 LINE1 
17 17 ZPDA_LOAD_ANSWERS17 ZPDA_LOAD_ANSWERS17 ZPDA_ANSWERS_LOAD73 89 0 89 0 0 0 99999 
57 20 Internal Development1 
58 1 17 ZPDA_LOAD_ANSWERS73 
59 17 ZPDA_LOAD_ANSWERS73 1 18 QUESTDOC70 0 
59 17 ZPDA_LOAD_ANSWERS73 1 210 QUESTLINES70 0 
60 17 ZPDA_LOAD_ANSWERS73 6 ANSNUM10 QUESTLINES70 6 ANSNUM2 0 0 0 0 0 
60 17 ZPDA_LOAD_ANSWERS73 7 CURDATE8 QUESTDOC70 7 CURDATE1 0 0 0 0 0 
60 17 ZPDA_LOAD_ANSWERS73 5 DOCNO8 QUESTDOC70 13 SERVCALLDOCNO2 0 0 0 0 0 
60 17 ZPDA_LOAD_ANSWERS73 6 QUESTF8 QUESTDOC70 10 QUESTFCODE3 0 0 0 0 0 
60 17 ZPDA_LOAD_ANSWERS73 8 QUESTNUM10 QUESTLINES70 8 QUESTNUM1 0 0 0 0 0 
18 16 ZPDA_DAYEND_LOAD0 
56 16 ZPDA_DAYEND_LOAD16 ZPDA_DAYEND_LOAD0 
19 16 ZPDA_DAYEND_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 16 ZPDA_DAYEND_LOAD2 4 LINE3 INT8 8 2 Ln
33 16 ZPDA_DAYEND_LOAD4 LINE0 48 
19 16 ZPDA_DAYEND_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 16 ZPDA_DAYEND_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 16 ZPDA_DAYEND_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 16 ZPDA_DAYEND_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 16 ZPDA_DAYEND_LOAD7 8 USERNAME4 CHAR255 255 4 USER
19 16 ZPDA_DAYEND_LOAD8 7 CURDATE4 DATE8 8 7 CURDATE
19 16 ZPDA_DAYEND_LOAD9 6 DAYEND4 TIME5 8 6 DAYEND
20 16 ZPDA_DAYEND_LOAD85 1 
21 16 ZPDA_DAYEND_LOAD1 4 LINE1 
17 16 ZPDA_LOAD_DAYEND16 ZPDA_LOAD_DAYEND16 ZPDA_DAYEND_LOAD73 89 0 0 0 0 0 99999 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_DAYEND73 
59 16 ZPDA_LOAD_DAYEND73 1 16 USERSB70 0 
59 16 ZPDA_LOAD_DAYEND73 1 213 ZPDA_SFDAYEND70 0 
60 16 ZPDA_LOAD_DAYEND73 7 CURDATE13 ZPDA_SFDAYEND70 7 CURDATE0 0 0 0 0 0 
60 16 ZPDA_LOAD_DAYEND73 6 DAYEND13 ZPDA_SFDAYEND70 6 DAYEND0 0 0 0 0 0 
60 16 ZPDA_LOAD_DAYEND73 8 USERNAME6 USERSB70 9 USERLOGIN0 0 0 0 0 0 
18 15 ZPDA_FLAGS_LOAD0 
56 15 ZPDA_FLAGS_LOAD15 ZPDA_FLAGS_LOAD0 
19 15 ZPDA_FLAGS_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 15 ZPDA_FLAGS_LOAD2 4 LINE3 INT8 8 2 Ln
33 15 ZPDA_FLAGS_LOAD4 LINE0 48 
19 15 ZPDA_FLAGS_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 15 ZPDA_FLAGS_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 15 ZPDA_FLAGS_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 15 ZPDA_FLAGS_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 15 ZPDA_FLAGS_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 15 ZPDA_FLAGS_LOAD8 8 MALFCODE4 CHAR255 255 8 MALFCODE
19 15 ZPDA_FLAGS_LOAD9 7 RESCODE4 CHAR255 255 7 RESCODE
20 15 ZPDA_FLAGS_LOAD85 1 
21 15 ZPDA_FLAGS_LOAD1 4 LINE1 
17 15 ZPDA_LOAD_FLAGS15 ZPDA_LOAD_FLAGS15 ZPDA_FLAGS_LOAD73 89 0 0 0 0 0 99999 
57 20 Internal Development1 
58 1 15 ZPDA_LOAD_FLAGS73 
59 15 ZPDA_LOAD_FLAGS73 1 111 DOCUMENTS_Q70 0 
60 15 ZPDA_LOAD_FLAGS73 5 DOCNO11 DOCUMENTS_Q70 5 DOCNO1 0 0 0 0 0 
60 15 ZPDA_LOAD_FLAGS73 8 MALFCODE11 DOCUMENTS_Q70 8 MALFCODE2 0 0 0 0 0 
60 15 ZPDA_LOAD_FLAGS73 7 RESCODE11 DOCUMENTS_Q70 12 SOLUTIONCODE3 0 0 0 0 0 
18 14 ZPDA_PART_LOAD0 
56 14 ZPDA_PART_LOAD14 ZPDA_PART_LOAD0 
19 14 ZPDA_PART_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 14 ZPDA_PART_LOAD2 4 LINE3 INT8 8 2 Ln
33 14 ZPDA_PART_LOAD4 LINE0 48 
19 14 ZPDA_PART_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 14 ZPDA_PART_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 14 ZPDA_PART_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 14 ZPDA_PART_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 14 ZPDA_PART_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 14 ZPDA_PART_LOAD8 7 CURDATE4 DATE8 8 7 CURDATE
19 14 ZPDA_PART_LOAD9 5 WARHS4 CHAR255 255 5 WARHS
19 14 ZPDA_PART_LOAD10 8 PARTNAME4 CHAR255 255 8 PARTNAME
19 14 ZPDA_PART_LOAD11 3 QTY3 INT13 8 3 QTY
33 14 ZPDA_PART_LOAD3 QTY0 48 
20 14 ZPDA_PART_LOAD85 1 
21 14 ZPDA_PART_LOAD1 4 LINE1 
17 14 ZPDA_LOAD_PART14 ZPDA_LOAD_PART14 ZPDA_PART_LOAD73 89 0 0 89 0 0 999999 
57 20 Internal Development1 
58 1 14 ZPDA_LOAD_PART73 
59 14 ZPDA_LOAD_PART73 1 111 DOCUMENTS_Q70 0 
59 14 ZPDA_LOAD_PART73 1 212 TRANSORDER_Q70 0 
60 14 ZPDA_LOAD_PART73 7 CURDATE12 TRANSORDER_Q70 7 CURDATE1 0 0 0 0 0 
60 14 ZPDA_LOAD_PART73 5 DOCNO11 DOCUMENTS_Q70 5 DOCNO1 0 0 0 0 0 
60 14 ZPDA_LOAD_PART73 8 PARTNAME12 TRANSORDER_Q70 8 PARTNAME2 0 0 0 0 0 
60 14 ZPDA_LOAD_PART73 3 QTY12 TRANSORDER_Q70 6 TQUANT4 0 0 0 0 0 
60 14 ZPDA_LOAD_PART73 5 WARHS12 TRANSORDER_Q70 9 WARHSNAME3 0 0 0 0 0 
18 16 ZPDA_REPAIR_LOAD0 
56 16 ZPDA_REPAIR_LOAD16 ZPDA_REPAIR_LOAD0 
19 16 ZPDA_REPAIR_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 16 ZPDA_REPAIR_LOAD2 4 LINE3 INT8 8 2 Ln
33 16 ZPDA_REPAIR_LOAD4 LINE0 48 
19 16 ZPDA_REPAIR_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 16 ZPDA_REPAIR_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 16 ZPDA_REPAIR_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 16 ZPDA_REPAIR_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 16 ZPDA_REPAIR_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 16 ZPDA_REPAIR_LOAD8 10 REPAIRTEXT4 CHAR255 255 10 REPAIRTEXT
20 16 ZPDA_REPAIR_LOAD85 1 
21 16 ZPDA_REPAIR_LOAD1 4 LINE1 
17 16 ZPDA_LOAD_REPAIR16 ZPDA_LOAD_REPAIR16 ZPDA_REPAIR_LOAD73 89 0 0 0 0 0 99999 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_REPAIR73 
59 16 ZPDA_LOAD_REPAIR73 1 116 ZPDA_REPAIR_FORM70 0 
59 16 ZPDA_LOAD_REPAIR73 1 217 ZPDA_REPAIR_SFORM70 0 
60 16 ZPDA_LOAD_REPAIR73 5 DOCNO16 ZPDA_REPAIR_FORM70 5 DOCNO0 0 0 0 0 0 
60 16 ZPDA_LOAD_REPAIR73 10 REPAIRTEXT17 ZPDA_REPAIR_SFORM70 4 TEXT0 0 0 0 0 0 
18 13 ZPDA_SIG_LOAD0 
56 13 ZPDA_SIG_LOAD13 ZPDA_SIG_LOAD0 
19 13 ZPDA_SIG_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 13 ZPDA_SIG_LOAD2 4 LINE3 INT8 8 2 Ln
33 13 ZPDA_SIG_LOAD4 LINE0 48 
19 13 ZPDA_SIG_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 13 ZPDA_SIG_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 13 ZPDA_SIG_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 13 ZPDA_SIG_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 13 ZPDA_SIG_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 13 ZPDA_SIG_LOAD8 7 SIGNAME4 CHAR255 255 7 SIGNAME
20 13 ZPDA_SIG_LOAD85 1 
21 13 ZPDA_SIG_LOAD1 4 LINE1 
17 13 ZPDA_LOAD_SIG13 ZPDA_LOAD_SIG13 ZPDA_SIG_LOAD73 89 0 89 0 0 0 99999 
57 20 Internal Development1 
58 1 13 ZPDA_LOAD_SIG73 
59 13 ZPDA_LOAD_SIG73 1 111 DOCUMENTS_Q70 1 
60 13 ZPDA_LOAD_SIG73 5 DOCNO11 DOCUMENTS_Q70 5 DOCNO1 0 0 0 0 0 
60 13 ZPDA_LOAD_SIG73 7 SIGNAME11 DOCUMENTS_Q70 14 ZPDA_SIGNATURE2 0 0 0 0 0 
18 16 ZPDA_STATUS_LOAD0 
56 16 ZPDA_STATUS_LOAD16 ZPDA_STATUS_LOAD0 
19 16 ZPDA_STATUS_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 16 ZPDA_STATUS_LOAD2 4 LINE3 INT8 8 2 Ln
33 16 ZPDA_STATUS_LOAD4 LINE0 48 
19 16 ZPDA_STATUS_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 16 ZPDA_STATUS_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 16 ZPDA_STATUS_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 16 ZPDA_STATUS_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 16 ZPDA_STATUS_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 16 ZPDA_STATUS_LOAD8 7 STATDES4 CHAR255 255 7 STATDES
20 16 ZPDA_STATUS_LOAD85 1 
21 16 ZPDA_STATUS_LOAD1 4 LINE1 
17 16 ZPDA_LOAD_STATUS16 ZPDA_LOAD_STATUS16 ZPDA_STATUS_LOAD73 89 0 0 0 0 0 99999 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_STATUS73 
59 16 ZPDA_LOAD_STATUS73 1 111 DOCUMENTS_Q70 0 
60 16 ZPDA_LOAD_STATUS73 5 DOCNO11 DOCUMENTS_Q70 5 DOCNO1 0 0 0 0 0 
60 16 ZPDA_LOAD_STATUS73 7 STATDES11 DOCUMENTS_Q70 7 STATDES2 0 0 0 0 0 
18 14 ZPDA_TIME_LOAD0 
56 14 ZPDA_TIME_LOAD14 ZPDA_TIME_LOAD0 
19 14 ZPDA_TIME_LOAD1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 14 ZPDA_TIME_LOAD2 4 LINE3 INT8 8 2 Ln
33 14 ZPDA_TIME_LOAD4 LINE0 48 
19 14 ZPDA_TIME_LOAD3 6 LOADED4 CHAR1 1 7 Loaded?
19 14 ZPDA_TIME_LOAD4 4 KEY14 CHAR20 20 5 Key 1
19 14 ZPDA_TIME_LOAD5 4 KEY24 CHAR20 20 5 Key 2
19 14 ZPDA_TIME_LOAD6 4 KEY34 CHAR20 20 5 Key 3
19 14 ZPDA_TIME_LOAD7 5 DOCNO4 CHAR255 255 5 DOCNO
19 14 ZPDA_TIME_LOAD8 8 USERNAME4 CHAR255 255 4 USER
19 14 ZPDA_TIME_LOAD9 7 CURDATE4 DATE8 8 7 CURDATE
19 14 ZPDA_TIME_LOAD10 7 ONROUTE4 TIME5 8 7 ONROUTE
19 14 ZPDA_TIME_LOAD11 6 ONSITE4 TIME5 8 6 ONSITE
19 14 ZPDA_TIME_LOAD12 7 ENDCALL4 TIME5 8 7 ENDCALL
20 14 ZPDA_TIME_LOAD85 1 
21 14 ZPDA_TIME_LOAD1 4 LINE1 
17 14 ZPDA_LOAD_TIME14 ZPDA_LOAD_TIME14 ZPDA_TIME_LOAD73 89 0 0 89 0 0 999999 
57 20 Internal Development1 
58 1 14 ZPDA_LOAD_TIME73 
59 14 ZPDA_LOAD_TIME73 1 111 DOCUMENTS_Q70 0 
59 14 ZPDA_LOAD_TIME73 1 213 TRANSORDER_QW70 0 
60 14 ZPDA_LOAD_TIME73 7 CURDATE13 TRANSORDER_QW70 7 CURDATE1 0 0 0 0 0 
60 14 ZPDA_LOAD_TIME73 5 DOCNO11 DOCUMENTS_Q70 5 DOCNO1 0 0 0 0 0 
60 14 ZPDA_LOAD_TIME73 7 ENDCALL13 TRANSORDER_QW70 5 ETIME4 0 0 0 0 0 
60 14 ZPDA_LOAD_TIME73 7 ONROUTE13 TRANSORDER_QW70 14 ATG_TRAVELTIME5 0 0 0 0 0 
60 14 ZPDA_LOAD_TIME73 6 ONSITE13 TRANSORDER_QW70 5 STIME3 0 0 0 0 0 
60 14 ZPDA_LOAD_TIME73 8 USERNAME13 TRANSORDER_QW70 14 TECHNICIANNAME2 0 0 0 0 0 
18 16 ZPDA_KANBAN_PART1 
56 16 ZPDA_KANBAN_PART20 Kanban parts for PDA0 
19 16 ZPDA_KANBAN_PART1 4 PART3 INT13 8 9 Part (ID)
33 16 ZPDA_KANBAN_PART4 PART0 48 
20 16 ZPDA_KANBAN_PART85 1 
21 16 ZPDA_KANBAN_PART1 4 PART1 
17 16 ZPDA_KANBAN_PART16 PDA Kanban Parts16 ZPDA_KANBAN_PART70 0 0 0 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_KANBAN_PART70 
13 16 ZPDA_KANBAN_PART70 16 ZPDA_KANBAN_PART4 PART0 4 PART0 0 13 48 500 0 72 0 0 0 0 0 1 
18 4 PART1 
56 4 PART5 Parts0 
19 4 PART1 8 PARTNAME4 CHAR15 15 11 Part Number
19 4 PART2 4 PART3 INT13 4 9 Part (ID)
19 4 PART3 4 TYPE4 CHAR1 1 12 Type (P/R/O)
19 4 PART4 4 PROC3 INT13 4 12 Routing (ID)
19 4 PART5 7 PARTDES4 CHAR32 32 16 Part Description
19 4 PART6 4 UNIT3 INT13 4 17 Factory Unit (ID)
19 4 PART7 3 UPD4 CHAR1 1 19 Upd SU & Proc Param
19 4 PART8 8 LEADTIME3 INT8 4 14 Min. Lead Time
19 4 PART9 6 STATUS4 CHAR1 1 20 Out of Use/Base Prod
19 4 PART10 8 FATQUANT4 REAL16 8 11 Qty(Parent)
33 4 PART8 FATQUANT3 51 
19 4 PART11 5 PRICE4 REAL16 8 8 Std Cost
33 4 PART5 PRICE4 52 
19 4 PART12 9 LASTPRICE4 REAL15 8 10 Last Price
33 4 PART9 LASTPRICE4 52 
19 4 PART13 4 COST4 REAL16 8 4 Cost
33 4 PART4 COST4 52 
19 4 PART14 3 REV3 INT13 4 13 Revision (ID)
33 4 PART3 REV0 48 
19 4 PART15 8 PRIVTYPE4 CHAR1 1 19 Quality Code (Part)
19 4 PART16 7 PATTERN3 INT13 4 13 Template (ID)
33 4 PART7 PATTERN0 48 
19 4 PART17 11 SERNPATTERN3 INT13 4 20 Serial No. Templ(ID)
33 4 PART11 SERNPATTERN0 48 
19 4 PART18 5 PUNIT3 INT13 4 9 Unit (ID)
33 4 PART5 PUNIT0 48 
19 4 PART19 4 CONV4 REAL14 8 16 Conversion Ratio
33 4 PART4 CONV0 48 
19 4 PART20 7 AVGDATE4 DATE8 4 18 Date Ready for Use
19 4 PART21 7 KITFLAG4 CHAR1 1 15 Issued to Kits?
19 4 PART22 6 DOLLAR4 REAL15 8 17 Actual Cost {F.F}
33 4 PART6 DOLLAR4 52 
19 4 PART23 8 TAKEFLAG4 CHAR1 1 13 Manual Issue?
19 4 PART24 5 WTYPE4 CHAR1 1 10 Not in Use
19 4 PART25 9 PREFERRED4 CHAR1 1 16 Preferred Status
19 4 PART26 6 EXCESS4 CHAR1 1 19 Excess Inv. B/N/C/I
19 4 PART27 9 PARTPARAM3 INT13 4 20 Part Parameters (ID)
33 4 PART9 PARTPARAM0 48 
19 4 PART28 4 PDES3 INT13 4 20 Part Description(ID)
33 4 PART4 PDES0 48 
19 4 PART29 8 COSTDATE4 DATE8 4 9 Cost Date
19 4 PART30 5 MPART3 INT13 4 10 MPART (ID)
33 4 PART5 MPART0 48 
19 4 PART31 10 AUTOSERIAL4 CHAR1 1 19 Open Automatically?
19 4 PART32 7 SIZEBAR3 INT13 4 15 Size Chart (ID)
33 4 PART7 SIZEBAR0 48 
19 4 PART33 8 CURRENCY3 INT13 4 13 Currency (ID)
33 4 PART8 CURRENCY0 48 
19 4 PART34 5 SCRAP4 REAL10 8 5 Scrap
33 4 PART5 SCRAP2 50 
19 4 PART35 10 SECONDCOST4 REAL16 8 10 Cost {F.F}
33 4 PART10 SECONDCOST4 52 
19 4 PART36 11 SECONDPRICE4 REAL16 8 14 Std Cost {F.F}
33 4 PART11 SECONDPRICE4 52 
19 4 PART37 9 COSTQUANT4 REAL9 8 12 Costing Unit
33 4 PART9 COSTQUANT3 51 
19 4 PART38 14 ACTUALCOSTTYPE4 CHAR1 1 14 Costing Method
19 4 PART39 8 SERNFLAG4 CHAR1 1 20 Maintain Serial Nos?
19 4 PART40 6 FAMILY3 INT13 4 11 Family (ID)
33 4 PART6 FAMILY0 48 
19 4 PART41 7 CURDATE4 DATE8 4 4 Date
19 4 PART42 12 LASTCURRENCY3 INT13 4 20 Last Price Curr (ID)
33 4 PART12 LASTCURRENCY0 48 
19 4 PART43 12 LASTCOSTFLAG4 CHAR1 1 12 Price Source
19 4 PART44 7 REVFLAG4 CHAR1 1 10 Revisions?
19 4 PART45 9 PRICEFLAG4 CHAR1 1 18 Source of Std Cost
19 4 PART46 8 FOBPRICE4 REAL15 8 16 Commission Price
33 4 PART8 FOBPRICE4 52 
19 4 PART47 11 FOBCURRENCY3 INT13 4 4 Curr
33 4 PART11 FOBCURRENCY0 48 
19 4 PART48 8 PURPRICE4 REAL15 8 14 Purchase Price
33 4 PART8 PURPRICE4 52 
19 4 PART49 4 USER3 INT13 4 9 User (ID)
33 4 PART4 USER0 48 
19 4 PART50 5 UDATE4 DATE14 4 10 Time Stamp
19 4 PART51 7 BARCODE4 CHAR16 16 8 Bar Code
19 4 PART52 14 MAXREPAIRPRICE4 REAL15 8 20 Maximum Repair Price
33 4 PART14 MAXREPAIRPRICE4 52 
19 4 PART53 14 REPAIRCURRENCY3 INT13 4 20 Repair Currency (ID)
33 4 PART14 REPAIRCURRENCY0 48 
19 4 PART54 6 UNSPSC3 INT13 4 17 UN/SPSC Code (ID)
33 4 PART6 UNSPSC0 48 
19 4 PART55 8 MOLDPART3 INT13 4 19 Byproduct Part (ID)
33 4 PART8 MOLDPART0 48 
19 4 PART56 8 RBALANCE4 REAL13 8 15 Current Balance
33 4 PART8 RBALANCE2 50 
19 4 PART57 12 ATG_SURVEYED4 CHAR1 1 18 Has Been Surveyed?
19 4 PART58 11 ATG_SURVSIG3 INT13 4 14 Survey User ID
33 4 PART11 ATG_SURVSIG0 48 
19 4 PART59 12 ATG_SURVDATE4 DATE14 4 13 Date Surveyed
19 4 PART60 8 PARTTYPE3 INT13 4 12 Product Type
33 4 PART8 PARTTYPE0 48 
19 4 PART61 11 ZATG_STEXTA4 CHAR50 50 12 Sales Test 1
19 4 PART62 11 ZATG_STEXTB4 CHAR50 50 12 Sales Text B
19 4 PART63 11 ZATG_STEXTC4 CHAR50 50 12 Sales Text 3
19 4 PART64 11 ZATG_STEXTD4 CHAR50 50 12 Sales Text 4
19 4 PART65 11 ZATG_STEXTE4 CHAR50 50 12 Sales Text 5
19 4 PART66 8 PARTSTAT3 INT13 4 16 Part Status (ID)
33 4 PART8 PARTSTAT0 48 
19 4 PART67 5 OWNER3 INT13 4 16 Assigned to (ID)
33 4 PART5 OWNER0 48 
19 4 PART68 11 EXTFILEFLAG4 CHAR1 1 12 Attachments?
19 4 PART69 7 LOCFLAG4 CHAR1 1 20 Designation Control?
19 4 PART70 11 PRICEPOLICY4 CHAR2 2 12 Price Policy
19 4 PART71 7 TURNKEY4 CHAR1 1 7 Turnkey
19 4 PART72 12 ATG_PREFPART3 INT13 4 13 Prefered Part
33 4 PART12 ATG_PREFPART0 48 
19 4 PART73 16 ZIAN_BARRIERPART4 CHAR1 1 13 Barriers Part
19 4 PART74 15 ZIAN_ATGINCPART4 CHAR1 1 13 ATG Inc. Part
19 4 PART75 9 SHOWINWEB4 CHAR1 1 20 Purch'd via Web Site
19 4 PART76 10 PALLETTYPE3 INT13 8 16 Pallet Type (ID)
33 4 PART10 PALLETTYPE0 48 
19 4 PART77 10 SUPERPHARM3 INT2 8 20 Superpharm Attribute
33 4 PART10 SUPERPHARM0 48 
19 4 PART78 12 NOTFIXEDCONV4 CHAR1 1 19 Variable Conversion
19 4 PART79 11 LOTBYVENDOR4 CHAR1 1 20 Internal/Vendor Lot#
19 4 PART80 8 MINPRICE4 REAL13 8 13 Minimum Price
33 4 PART8 MINPRICE2 50 
19 4 PART81 11 STORAGETYPE3 INT13 8 18 Storage Group (ID)
33 4 PART11 STORAGETYPE0 48 
20 4 PART65 1 
21 4 PART1 4 PART1 
20 4 PART85 2 
21 4 PART2 8 PARTNAME1 
20 4 PART78 3 
21 4 PART3 4 PROC1 
20 4 PART78 4 
21 4 PART4 7 PARTDES1 
20 4 PART78 5 
21 4 PART5 6 FAMILY1 
20 4 PART78 6 
21 4 PART6 7 BARCODE1 
20 4 PART78 7 
21 4 PART7 6 UNSPSC1 
20 4 PART78 8 
21 4 PART8 8 MOLDPART1 
20 4 PART78 9 
21 4 PART9 5 MPART1 
20 4 PART78 10 
21 4 PART10 8 PARTSTAT1 
13 16 ZPDA_KANBAN_PART70 4 PART7 PARTDES0 7 PARTDES0 0 32 0 20 0 0 0 0 0 0 0 1 
13 16 ZPDA_KANBAN_PART70 4 PART8 PARTNAME0 8 PARTNAME65 0 15 0 10 1 0 0 0 0 0 0 1 
13 16 ZPDA_KANBAN_PART70 4 PART4 PART0 5 PPART0 0 13 0 510 0 72 0 0 16 ZPDA_KANBAN_PART4 PART0 1 
24 11 10 POST-FIELD67 
8 16 ZPDA_KANBAN_PART70 5 PPART10 POST-FIELD67 
14 16 ZPDA_KANBAN_PART70 5 PPART10 POST-FIELD67 40 SELECT :$.PPART INTO :$.PART FROM DUMMY;1 1 
18 13 ZPDA_SFDAYEND0 
56 13 ZPDA_SFDAYEND13 ZPDA_SFDAYEND0 
19 13 ZPDA_SFDAYEND1 6 USERID3 INT13 8 4 USER
33 13 ZPDA_SFDAYEND6 USERID0 48 
19 13 ZPDA_SFDAYEND2 7 CURDATE4 DATE8 8 7 CURDATE
19 13 ZPDA_SFDAYEND3 6 DAYEND4 TIME5 8 6 DAYEND
20 13 ZPDA_SFDAYEND85 1 
21 13 ZPDA_SFDAYEND1 6 USERID1 
21 13 ZPDA_SFDAYEND1 7 CURDATE2 
17 13 ZPDA_SFDAYEND16 Reported Day End13 ZPDA_SFDAYEND70 0 0 0 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 13 ZPDA_SFDAYEND70 
13 13 ZPDA_SFDAYEND70 13 ZPDA_SFDAYEND7 CURDATE0 7 CURDATE0 0 8 0 20 0 0 0 0 0 0 0 1 
24 11 10 POST-FIELD67 
8 13 ZPDA_SFDAYEND70 7 CURDATE10 POST-FIELD67 
14 13 ZPDA_SFDAYEND70 7 CURDATE10 POST-FIELD67 44 SELECT :$$.USERID INTO :$.USERID FROM DUMMY;1 1 
13 13 ZPDA_SFDAYEND70 13 ZPDA_SFDAYEND6 DAYEND0 6 DAYEND0 0 5 0 30 0 0 0 0 0 0 0 1 
24 11 10 POST-FIELD67 
8 13 ZPDA_SFDAYEND70 6 DAYEND10 POST-FIELD67 
14 13 ZPDA_SFDAYEND70 6 DAYEND10 POST-FIELD67 44 SELECT :$$.USERID INTO :$.USERID FROM DUMMY;1 1 
13 13 ZPDA_SFDAYEND70 13 ZPDA_SFDAYEND6 USERID0 6 USERID0 0 13 48 10 0 72 0 0 0 0 0 1 
15 13 ZPDA_SFDAYEND70 6 USERID0 70 11 =:$$.USERID0 
18 14 QUESTLINESTEXT1 
56 14 QUESTLINESTEXT29 Responses to Questions - Text0 
19 14 QUESTLINESTEXT1 3 DOC3 INT13 4 11 Survey (ID)
33 14 QUESTLINESTEXT3 DOC0 48 
19 14 QUESTLINESTEXT2 8 QUESTNUM3 INT3 4 14 No. (Question)
33 14 QUESTLINESTEXT8 QUESTNUM0 48 
19 14 QUESTLINESTEXT3 4 TEXT4 CHAR68 68 16 Rest of Response
19 14 QUESTLINESTEXT4 8 TEXTLINE3 INT8 4 9 Text Line
33 14 QUESTLINESTEXT8 TEXTLINE0 48 
19 14 QUESTLINESTEXT5 7 TEXTORD3 INT8 4 5 Order
33 14 QUESTLINESTEXT7 TEXTORD0 48 
20 14 QUESTLINESTEXT85 1 
21 14 QUESTLINESTEXT1 3 DOC1 
21 14 QUESTLINESTEXT1 8 QUESTNUM2 
21 14 QUESTLINESTEXT1 8 TEXTLINE3 
17 16 ZPDA_ANSWER_FORM16 ZPDA_ANSWER_FORM14 QUESTLINESTEXT70 0 0 0 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_ANSWER_FORM70 
13 16 ZPDA_ANSWER_FORM70 14 QUESTLINESTEXT3 DOC0 3 DOC0 0 13 48 0 0 72 0 0 0 0 0 1 
15 16 ZPDA_ANSWER_FORM70 3 DOC0 70 8 :$$$.DOC0 
13 16 ZPDA_ANSWER_FORM70 14 QUESTLINESTEXT8 QUESTNUM0 8 QUESTNUM0 0 3 48 0 0 72 0 0 0 0 0 1 
15 16 ZPDA_ANSWER_FORM70 8 QUESTNUM0 70 12 :$$.QUESTNUM0 
13 16 ZPDA_ANSWER_FORM70 14 QUESTLINESTEXT4 TEXT0 4 TEXT0 0 68 0 0 0 0 0 0 0 0 0 1 
24 11 10 POST-FIELD67 
8 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 39 SELECT :$$$.DOC INTO :$.DOC FROM DUMMY;1 1 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 14 :NL = :NO = 0;2 2 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 29 SELECT MAX(TEXTLINE) INTO :NL3 3 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 19 FROM QUESTLINESTEXT4 4 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 11 WHERE DOC =5 5 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 9 :$$$.DOC;6 6 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 28 SELECT MAX(TEXTORD) INTO :NO7 7 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 19 FROM QUESTLINESTEXT8 8 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 11 WHERE DOC =9 9 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 9 :$$$.DOC;10 10 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 31 SELECT 0 + :NL + 1, 0 + :NO + 111 11 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 28 INTO :$.TEXTLINE, :$.TEXTORD12 12 
14 16 ZPDA_ANSWER_FORM70 4 TEXT10 POST-FIELD67 18 FROM DUMMY FORMAT;13 13 
13 16 ZPDA_ANSWER_FORM70 14 QUESTLINESTEXT8 TEXTLINE0 8 TEXTLINE0 0 8 48 0 0 0 0 0 0 0 0 1 
13 16 ZPDA_ANSWER_FORM70 14 QUESTLINESTEXT7 TEXTORD0 7 TEXTORD0 0 8 48 0 0 0 0 0 0 0 0 1 
18 15 ZPDA_SURVEYSIGN0 
56 15 ZPDA_SURVEYSIGN15 ZPDA_SURVEYSIGN0 
19 15 ZPDA_SURVEYSIGN1 5 DOCNO4 CHAR20 20 5 DOCNO
19 15 ZPDA_SURVEYSIGN2 6 QUESTF4 CHAR20 20 6 QUESTF
19 15 ZPDA_SURVEYSIGN3 7 SIGNAME4 CHAR255 255 7 SIGNAME
20 15 ZPDA_SURVEYSIGN85 1 
21 15 ZPDA_SURVEYSIGN1 5 DOCNO1 
21 15 ZPDA_SURVEYSIGN1 6 QUESTF2 
17 17 ZPDA_FORMSURVSIGN17 ZPDA_FORMSURVSIGN15 ZPDA_SURVEYSIGN70 0 0 81 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 17 ZPDA_FORMSURVSIGN70 
13 17 ZPDA_FORMSURVSIGN70 15 ZPDA_SURVEYSIGN5 DOCNO0 5 DOCNO0 0 20 0 10 0 72 0 0 0 0 0 1 
15 17 ZPDA_FORMSURVSIGN70 5 DOCNO0 70 19 = :$$.SERVCALLDOCNO0 
13 17 ZPDA_FORMSURVSIGN70 15 ZPDA_SURVEYSIGN6 QUESTF0 6 QUESTF0 0 20 0 20 0 72 0 0 0 0 0 1 
15 17 ZPDA_FORMSURVSIGN70 6 QUESTF0 70 14 :$$.QUESTFCODE0 
13 17 ZPDA_FORMSURVSIGN70 0 0 0 7 SIGNAME0 0 20 0 30 0 0 0 0 0 0 0 0 
15 17 ZPDA_FORMSURVSIGN70 7 SIGNAME0 70 23 ZPDA_SURVEYSIGN.SIGNAME4 CHAR
18 9 DOCUMENTS1 
56 9 DOCUMENTS31 Inventory Transaction Documents0 
19 9 DOCUMENTS1 3 DOC3 INT13 4 13 Document (ID)
19 9 DOCUMENTS2 5 WARHS3 INT13 4 14 Warehouse (ID)
19 9 DOCUMENTS3 5 DOCNO4 CHAR16 16 8 Document
19 9 DOCUMENTS4 7 CURDATE4 DATE8 4 4 Date
19 9 DOCUMENTS5 7 TOWARHS3 INT13 4 17 To Warehouse (ID)
19 9 DOCUMENTS6 4 TYPE4 CHAR1 1 4 Type
19 9 DOCUMENTS7 4 USER3 INT13 4 9 User (ID)
19 9 DOCUMENTS8 4 CUST3 INT13 4 13 Customer (ID)
19 9 DOCUMENTS9 6 DOCREF4 CHAR10 10 12 Stamp Number
19 9 DOCUMENTS10 3 ORD3 INT13 4 10 Order (ID)
19 9 DOCUMENTS11 4 PDOC3 INT13 4 20 Linked Document (ID)
19 9 DOCUMENTS12 5 LORRY3 INT13 4 14 Transport (ID)
33 9 DOCUMENTS5 LORRY0 48 
19 9 DOCUMENTS13 5 UDATE4 DATE14 4 10 Time Stamp
19 9 DOCUMENTS14 4 FLAG4 CHAR1 1 4 Flag
19 9 DOCUMENTS15 9 FORSERIAL3 INT13 4 19 For Work Order (ID)
33 9 DOCUMENTS9 FORSERIAL0 48 
19 9 DOCUMENTS16 5 IVALL4 CHAR1 1 6 Billed
19 9 DOCUMENTS17 6 CANCEL4 CHAR1 1 8 Canceled
19 9 DOCUMENTS18 5 FINAL4 CHAR1 1 5 Final
19 9 DOCUMENTS19 7 PRINTED4 CHAR1 1 8 Printed?
19 9 DOCUMENTS20 8 SHIPTYPE3 INT13 4 18 Shipment Type (ID)
33 9 DOCUMENTS8 SHIPTYPE0 48 
19 9 DOCUMENTS21 11 EXTFILEFLAG4 CHAR2 2 12 Attachments?
19 9 DOCUMENTS22 7 BOOKNUM4 CHAR16 16 18 Sales Rep Doc. No.
19 9 DOCUMENTS23 8 DESTCODE3 INT13 4 17 Address Code (ID)
33 9 DOCUMENTS8 DESTCODE0 48 
19 9 DOCUMENTS24 6 STORNO4 CHAR1 1 17 Reverse Document?
19 9 DOCUMENTS25 12 COMPANALYSIS4 CHAR1 1 17 Analysis Complete
19 9 DOCUMENTS26 4 PACK3 INT13 4 18 Packing Crate (ID)
33 9 DOCUMENTS4 PACK0 48 
19 9 DOCUMENTS27 6 WEIGHT4 REAL10 8 12 Total Weight
33 9 DOCUMENTS6 WEIGHT2 50 
19 9 DOCUMENTS28 2 PL4 CHAR1 1 15 Bill of Lading?
19 9 DOCUMENTS29 6 QPRICE4 REAL16 8 16 Price Bef. Disc.
33 9 DOCUMENTS6 QPRICE2 50 
19 9 DOCUMENTS30 3 VAT4 REAL16 8 9 Sales Tax
33 9 DOCUMENTS3 VAT2 50 
19 9 DOCUMENTS31 8 TOTPRICE4 REAL16 8 11 Final Price
33 9 DOCUMENTS8 TOTPRICE2 50 
19 9 DOCUMENTS32 7 PERCENT4 REAL8 8 18 % Overall Discount
33 9 DOCUMENTS7 PERCENT2 50 
19 9 DOCUMENTS33 8 CURRENCY3 INT13 4 13 Currency (ID)
33 9 DOCUMENTS8 CURRENCY0 48 
19 9 DOCUMENTS34 8 VATPRICE4 REAL16 8 19 Tax before Rounding
33 9 DOCUMENTS8 VATPRICE2 50 
19 9 DOCUMENTS35 12 ADJPRICEFLAG4 CHAR1 1 14 Adjust Prices?
19 9 DOCUMENTS36 5 PHONE3 INT13 4 12 Contact (ID)
33 9 DOCUMENTS5 PHONE0 48 
19 9 DOCUMENTS37 10 PARENTSERN3 INT13 4 20 Ser No. of Parent-ID
33 9 DOCUMENTS10 PARENTSERN0 48 
19 9 DOCUMENTS38 6 RMADOC3 INT13 4 8 RMA (ID)
33 9 DOCUMENTS6 RMADOC0 48 
19 9 DOCUMENTS39 5 PLIST3 INT13 4 15 Price List (ID)
33 9 DOCUMENTS5 PLIST0 48 
19 9 DOCUMENTS40 7 SHIPPER3 INT13 4 12 Shipper (ID)
33 9 DOCUMENTS7 SHIPPER0 48 
19 9 DOCUMENTS41 7 DETAILS4 CHAR24 24 7 Details
19 9 DOCUMENTS42 2 IV3 INT13 4 12 Invoice (ID)
33 9 DOCUMENTS2 IV0 48 
19 9 DOCUMENTS43 5 AGENT3 INT13 4 14 Sales Rep (ID)
33 9 DOCUMENTS5 AGENT0 48 
19 9 DOCUMENTS44 10 ATG_DRAWNO4 CHAR40 40 14 Work Sheet No.
19 9 DOCUMENTS45 7 ZATG_RC3 INT13 4 15 Root Cause (ID)
33 9 DOCUMENTS7 ZATG_RC0 48 
19 9 DOCUMENTS46 15 ZIAN_RMA_REASON3 INT13 8 10 RMA Reason
33 9 DOCUMENTS15 ZIAN_RMA_REASON0 48 
19 9 DOCUMENTS47 17 ZIAN_RMA_DECISION3 INT13 8 12 RAM Decision
33 9 DOCUMENTS17 ZIAN_RMA_DECISION0 48 
19 9 DOCUMENTS48 17 ZIAN_RMA_RETURNED3 INT13 8 15 RMA Returned By
33 9 DOCUMENTS17 ZIAN_RMA_RETURNED0 48 
19 9 DOCUMENTS49 19 ZIAN_RMA_ORIGINATOR3 INT13 8 18 RMA Contact at ATG
33 9 DOCUMENTS19 ZIAN_RMA_ORIGINATOR0 48 
20 9 DOCUMENTS65 1 
21 9 DOCUMENTS1 3 DOC1 
20 9 DOCUMENTS85 2 
21 9 DOCUMENTS2 5 DOCNO1 
21 9 DOCUMENTS2 4 TYPE2 
20 9 DOCUMENTS78 3 
21 9 DOCUMENTS3 7 CURDATE1 
20 9 DOCUMENTS78 4 
21 9 DOCUMENTS4 3 ORD1 
20 9 DOCUMENTS78 5 
21 9 DOCUMENTS5 7 BOOKNUM1 
20 9 DOCUMENTS78 6 
21 9 DOCUMENTS6 7 CURDATE3 
21 9 DOCUMENTS6 4 CUST1 
21 9 DOCUMENTS6 5 IVALL2 
20 9 DOCUMENTS78 7 
21 9 DOCUMENTS7 7 CURDATE2 
21 9 DOCUMENTS7 4 TYPE1 
20 9 DOCUMENTS78 8 
21 9 DOCUMENTS8 4 TYPE1 
21 9 DOCUMENTS8 4 CUST3 
21 9 DOCUMENTS8 4 PDOC2 
20 9 DOCUMENTS78 9 
21 9 DOCUMENTS9 7 TOWARHS2 
21 9 DOCUMENTS9 4 TYPE1 
17 16 ZPDA_REPAIR_FORM16 ZPDA_REPAIR_FORM9 DOCUMENTS70 0 0 81 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_REPAIR_FORM70 
13 16 ZPDA_REPAIR_FORM70 9 DOCUMENTS3 DOC0 3 DOC0 0 13 0 10 0 72 0 0 0 0 0 1 
13 16 ZPDA_REPAIR_FORM70 9 DOCUMENTS5 DOCNO0 5 DOCNO0 0 16 0 30 0 0 0 0 0 0 0 1 
13 16 ZPDA_REPAIR_FORM70 9 DOCUMENTS4 TYPE0 4 TYPE0 0 1 0 60 0 72 0 0 0 0 0 1 
15 16 ZPDA_REPAIR_FORM70 4 TYPE0 70 3 'Q'0 
18 13 DOCUMENTSTEXT1 
56 13 DOCUMENTSTEXT32 Inventory Transactions - Remarks0 
19 13 DOCUMENTSTEXT1 3 DOC3 INT13 4 13 Document (ID)
33 13 DOCUMENTSTEXT3 DOC0 48 
19 13 DOCUMENTSTEXT2 4 TEXT4 CHAR68 68 7 Remarks
19 13 DOCUMENTSTEXT3 8 TEXTLINE3 INT8 4 4 Line
33 13 DOCUMENTSTEXT8 TEXTLINE0 48 
19 13 DOCUMENTSTEXT4 7 TEXTORD3 INT8 4 5 Order
33 13 DOCUMENTSTEXT7 TEXTORD0 48 
20 13 DOCUMENTSTEXT85 1 
21 13 DOCUMENTSTEXT1 3 DOC1 
21 13 DOCUMENTSTEXT1 8 TEXTLINE2 
17 17 ZPDA_REPAIR_SFORM17 ZPDA_REPAIR_SFORM13 DOCUMENTSTEXT70 0 0 0 78 4 ZPDA0 0 
57 20 Internal Development1 
58 1 17 ZPDA_REPAIR_SFORM70 
13 17 ZPDA_REPAIR_SFORM70 13 DOCUMENTSTEXT3 DOC0 3 DOC0 0 13 48 10 0 0 0 0 0 0 0 1 
15 17 ZPDA_REPAIR_SFORM70 3 DOC0 70 9 = :$$.DOC0 
13 17 ZPDA_REPAIR_SFORM70 13 DOCUMENTSTEXT4 TEXT0 4 TEXT0 0 68 0 20 0 0 0 0 0 0 0 1 
24 11 10 POST-FIELD67 
8 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 38 SELECT :$$.DOC INTO :$.DOC FROM DUMMY;1 1 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 14 :NL = :NO = 0;2 2 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 29 SELECT MAX(TEXTLINE) INTO :NL3 3 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 18 FROM DOCUMENTSTEXT4 4 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 11 WHERE DOC =5 5 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 8 :$$.DOC;6 6 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 28 SELECT MAX(TEXTORD) INTO :NO7 7 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 18 FROM DOCUMENTSTEXT8 8 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 11 WHERE DOC =9 9 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 8 :$$.DOC;10 10 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 31 SELECT 0 + :NL + 1, 0 + :NO + 111 11 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 28 INTO :$.TEXTLINE, :$.TEXTORD12 12 
14 17 ZPDA_REPAIR_SFORM70 4 TEXT10 POST-FIELD67 18 FROM DUMMY FORMAT;13 13 
13 17 ZPDA_REPAIR_SFORM70 13 DOCUMENTSTEXT8 TEXTLINE0 8 TEXTLINE0 0 8 48 30 0 0 0 0 0 0 0 1 
13 17 ZPDA_REPAIR_SFORM70 13 DOCUMENTSTEXT7 TEXTORD0 7 TEXTORD65 0 8 48 40 1 0 0 0 0 0 0 1 
17 17 ZPDA_LOAD_ANSWERS17 ZPDA_LOAD_ANSWERS0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 17 ZPDA_LOAD_ANSWERS80 
7 17 ZPDA_LOAD_ANSWERS80 10 4 SQLI67 
28 17 ZPDA_LOAD_ANSWERS80 10 24 UPDATE ZPDA_ANSWERS_LOAD1 1 
28 17 ZPDA_LOAD_ANSWERS80 10 21 SET RECORDTYPE = '3',2 2 
28 17 ZPDA_LOAD_ANSWERS80 10 13 QUESTNUM = 0,3 3 
28 17 ZPDA_LOAD_ANSWERS80 10 10 ANSNUM = 04 4 
28 17 ZPDA_LOAD_ANSWERS80 10 20 WHERE QUESTNUM = -1;5 5 
7 17 ZPDA_LOAD_ANSWERS80 20 17 ZPDA_LOAD_ANSWERS73 
7 17 ZPDA_LOAD_ANSWERS80 30 4 SQLI67 
28 17 ZPDA_LOAD_ANSWERS80 30 53 /*DELETE FROM ZPDA_ANSWERS_LOAD WHERE LOADED = 'Y';*/1 1 
17 16 ZPDA_LOAD_DAYEND16 ZPDA_LOAD_DAYEND0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_DAYEND80 
7 16 ZPDA_LOAD_DAYEND80 10 16 ZPDA_LOAD_DAYEND73 
17 15 ZPDA_LOAD_FLAGS15 ZPDA_LOAD_FLAGS0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 15 ZPDA_LOAD_FLAGS80 
7 15 ZPDA_LOAD_FLAGS80 10 15 ZPDA_LOAD_FLAGS73 
7 15 ZPDA_LOAD_FLAGS80 20 4 SQLI67 
28 15 ZPDA_LOAD_FLAGS80 20 47 DELETE FROM ZPDA_FLAGS_LOAD WHERE LOADED = 'Y';1 1 
17 14 ZPDA_LOAD_PART14 ZPDA_LOAD_PART0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 14 ZPDA_LOAD_PART80 
7 14 ZPDA_LOAD_PART80 10 14 ZPDA_LOAD_PART73 
7 14 ZPDA_LOAD_PART80 20 4 SQLI67 
28 14 ZPDA_LOAD_PART80 20 33 :ID = :LINE = :NOLD = :FIRST = 0;1 1 
28 14 ZPDA_LOAD_PART80 20 19 :LOADED = :RT = '';2 2 
28 14 ZPDA_LOAD_PART80 20 32 /* ITERATE THROUGH LOAD TABLE */3 3 
28 14 ZPDA_LOAD_PART80 20 20 DECLARE C CURSOR FOR4 4 
28 14 ZPDA_LOAD_PART80 20 36 SELECT RECORDTYPE, LINE, LOADED FROM5 5 
28 14 ZPDA_LOAD_PART80 20 41 /********************** LOAD TABLE NAME*/6 6 
28 14 ZPDA_LOAD_PART80 20 14 ZPDA_PART_LOAD7 7 
28 14 ZPDA_LOAD_PART80 20 41 /***************************************/8 8 
28 14 ZPDA_LOAD_PART80 20 15 WHERE LINE > 0;9 9 
28 14 ZPDA_LOAD_PART80 20 7 OPEN C;10 10 
28 14 ZPDA_LOAD_PART80 20 9 LABEL 10;11 11 
28 14 ZPDA_LOAD_PART80 20 33 FETCH C INTO :RT, :LINE, :LOADED;12 12 
28 14 ZPDA_LOAD_PART80 20 26 GOTO 20 WHERE :RETVAL = 0;13 13 
28 14 ZPDA_LOAD_PART80 20 52 SELECT 1 INTO :NOLD FROM DUMMY WHERE :LOADED <> 'Y';14 14 
28 14 ZPDA_LOAD_PART80 20 39 GOTO 15 WHERE :RT <> '1' OR :FIRST = 0;15 15 
28 14 ZPDA_LOAD_PART80 20 19 /* RECORD TYPE 1 */16 16 
28 14 ZPDA_LOAD_PART80 20 12 /* LOADED */17 17 
28 14 ZPDA_LOAD_PART80 20 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */18 18 
28 14 ZPDA_LOAD_PART80 20 36 GOSUB 200; /* CLEAN UP LOADING ID */19 19 
28 14 ZPDA_LOAD_PART80 20 33 GOSUB 100; /* GET A LOADING ID */20 20 
28 14 ZPDA_LOAD_PART80 20 9 LABEL 15;21 21 
28 14 ZPDA_LOAD_PART80 20 62 INSERT INTO ZPDA_CLEANTABLE (LOADID,LINE) VALUES (:ID, :LINE);22 22 
28 14 ZPDA_LOAD_PART80 20 32 SELECT 1 INTO :FIRST FROM DUMMY;23 23 
28 14 ZPDA_LOAD_PART80 20 8 LOOP 10;24 24 
28 14 ZPDA_LOAD_PART80 20 9 LABEL 20;25 25 
28 14 ZPDA_LOAD_PART80 20 8 CLOSE C;26 26 
28 14 ZPDA_LOAD_PART80 20 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */27 27 
28 14 ZPDA_LOAD_PART80 20 36 GOSUB 200; /* CLEAN UP LOADING ID */28 28 
28 14 ZPDA_LOAD_PART80 20 25 /************************29 29 
28 14 ZPDA_LOAD_PART80 20 25 ************************/30 30 
28 14 ZPDA_LOAD_PART80 20 8 SUB 100;31 31 
28 14 ZPDA_LOAD_PART80 20 22 /* GET A LOADING ID */32 32 
28 14 ZPDA_LOAD_PART80 20 57 SELECT 0 + MAX(LOADID) + 1 INTO :ID FROM ZPDA_CLEANTABLE;33 33 
28 14 ZPDA_LOAD_PART80 20 59 INSERT INTO ZPDA_CLEANTABLE (LOADID, LINE) VALUES (:ID, 0);34 34 
28 14 ZPDA_LOAD_PART80 20 7 RETURN;35 35 
28 14 ZPDA_LOAD_PART80 20 4 /**/36 36 
28 14 ZPDA_LOAD_PART80 20 8 SUB 200;37 37 
28 14 ZPDA_LOAD_PART80 20 25 /* CLEAN UP LOADING ID */38 38 
28 14 ZPDA_LOAD_PART80 20 31 SELECT 0 INTO :NOLD FROM DUMMY;39 39 
28 14 ZPDA_LOAD_PART80 20 47 DELETE FROM ZPDA_CLEANTABLE WHERE LOADID = :ID;40 40 
28 14 ZPDA_LOAD_PART80 20 7 RETURN;41 41 
28 14 ZPDA_LOAD_PART80 20 8 SUB 300;42 42 
28 14 ZPDA_LOAD_PART80 20 35 /* DELETE LOADED FROM LOAD TABLE */43 43 
28 14 ZPDA_LOAD_PART80 20 25 GOTO 310 WHERE :NOLD = 1;44 44 
28 14 ZPDA_LOAD_PART80 20 11 DELETE FROM45 45 
28 14 ZPDA_LOAD_PART80 20 41 /********************** LOAD TABLE NAME*/46 46 
28 14 ZPDA_LOAD_PART80 20 14 ZPDA_PART_LOAD47 47 
28 14 ZPDA_LOAD_PART80 20 41 /***************************************/48 48 
28 14 ZPDA_LOAD_PART80 20 13 WHERE LINE IN49 49 
28 14 ZPDA_LOAD_PART80 20 1 (50 50 
28 14 ZPDA_LOAD_PART80 20 32 SELECT LINE FROM ZPDA_CLEANTABLE51 51 
28 14 ZPDA_LOAD_PART80 20 18 WHERE LOADID = :ID52 52 
28 14 ZPDA_LOAD_PART80 20 12 AND LINE > 053 53 
28 14 ZPDA_LOAD_PART80 20 2 );54 54 
28 14 ZPDA_LOAD_PART80 20 10 LABEL 310;55 55 
28 14 ZPDA_LOAD_PART80 20 7 RETURN;56 56 
17 16 ZPDA_LOAD_REPAIR16 ZPDA_LOAD_REPAIR0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_REPAIR80 
7 16 ZPDA_LOAD_REPAIR80 10 16 ZPDA_LOAD_REPAIR73 
7 16 ZPDA_LOAD_REPAIR80 20 4 SQLI67 
28 16 ZPDA_LOAD_REPAIR80 20 52 /*DELETE FROM ZPDA_REPAIR_LOAD WHERE LOADED = 'Y';*/1 1 
17 13 ZPDA_LOAD_SIG13 ZPDA_LOAD_SIG0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 13 ZPDA_LOAD_SIG80 
7 13 ZPDA_LOAD_SIG80 5 4 SQLI67 
28 13 ZPDA_LOAD_SIG80 5 27 INSERT INTO ZPDA_SURVEYSIGN1 1 
28 13 ZPDA_LOAD_SIG80 5 6 SELECT2 2 
28 13 ZPDA_LOAD_SIG80 5 29 STRPIECE (DOCNO, '/', 1, 1) ,3 3 
28 13 ZPDA_LOAD_SIG80 5 28 STRPIECE (DOCNO, '/', 2, 1),4 4 
28 13 ZPDA_LOAD_SIG80 5 7 SIGNAME5 5 
28 13 ZPDA_LOAD_SIG80 5 19 FROM  ZPDA_SIG_LOAD6 6 
28 13 ZPDA_LOAD_SIG80 5 22 WHERE DOCNO LIKE'%/%';7 7 
28 13 ZPDA_LOAD_SIG80 5 25 DELETE FROM ZPDA_SIG_LOAD8 8 
28 13 ZPDA_LOAD_SIG80 5 22 WHERE DOCNO LIKE'%/%';9 9 
7 13 ZPDA_LOAD_SIG80 10 13 ZPDA_LOAD_SIG73 
7 13 ZPDA_LOAD_SIG80 20 4 SQLI67 
28 13 ZPDA_LOAD_SIG80 20 49 /*DELETE FROM ZPDA_SIG_LOAD WHERE LOADED = 'Y';*/1 1 
17 16 ZPDA_LOAD_STATUS16 ZPDA_LOAD_STATUS0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 16 ZPDA_LOAD_STATUS80 
7 16 ZPDA_LOAD_STATUS80 10 16 ZPDA_LOAD_STATUS73 
7 16 ZPDA_LOAD_STATUS80 20 4 SQLI67 
28 16 ZPDA_LOAD_STATUS80 20 48 DELETE FROM ZPDA_STATUS_LOAD WHERE LOADED = 'Y';1 1 
17 14 ZPDA_LOAD_TIME14 ZPDA_LOAD_TIME0 80 0 0 0 0 4 ZPDA0 0 
57 20 Internal Development1 
58 1 14 ZPDA_LOAD_TIME80 
7 14 ZPDA_LOAD_TIME80 10 14 ZPDA_LOAD_TIME73 
7 14 ZPDA_LOAD_TIME80 20 4 SQLI67 
28 14 ZPDA_LOAD_TIME80 20 33 :ID = :LINE = :NOLD = :FIRST = 0;1 1 
28 14 ZPDA_LOAD_TIME80 20 19 :LOADED = :RT = '';2 2 
28 14 ZPDA_LOAD_TIME80 20 32 /* ITERATE THROUGH LOAD TABLE */3 3 
28 14 ZPDA_LOAD_TIME80 20 20 DECLARE C CURSOR FOR4 4 
28 14 ZPDA_LOAD_TIME80 20 36 SELECT RECORDTYPE, LINE, LOADED FROM5 5 
28 14 ZPDA_LOAD_TIME80 20 41 /********************** LOAD TABLE NAME*/6 6 
28 14 ZPDA_LOAD_TIME80 20 14 ZPDA_TIME_LOAD7 7 
28 14 ZPDA_LOAD_TIME80 20 41 /***************************************/8 8 
28 14 ZPDA_LOAD_TIME80 20 15 WHERE LINE > 0;9 9 
28 14 ZPDA_LOAD_TIME80 20 7 OPEN C;10 10 
28 14 ZPDA_LOAD_TIME80 20 9 LABEL 10;11 11 
28 14 ZPDA_LOAD_TIME80 20 33 FETCH C INTO :RT, :LINE, :LOADED;12 12 
28 14 ZPDA_LOAD_TIME80 20 26 GOTO 20 WHERE :RETVAL = 0;13 13 
28 14 ZPDA_LOAD_TIME80 20 52 SELECT 1 INTO :NOLD FROM DUMMY WHERE :LOADED <> 'Y';14 14 
28 14 ZPDA_LOAD_TIME80 20 39 GOTO 15 WHERE :RT <> '1' OR :FIRST = 0;15 15 
28 14 ZPDA_LOAD_TIME80 20 19 /* RECORD TYPE 1 */16 16 
28 14 ZPDA_LOAD_TIME80 20 12 /* LOADED */17 17 
28 14 ZPDA_LOAD_TIME80 20 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */18 18 
28 14 ZPDA_LOAD_TIME80 20 36 GOSUB 200; /* CLEAN UP LOADING ID */19 19 
28 14 ZPDA_LOAD_TIME80 20 33 GOSUB 100; /* GET A LOADING ID */20 20 
28 14 ZPDA_LOAD_TIME80 20 9 LABEL 15;21 21 
28 14 ZPDA_LOAD_TIME80 20 62 INSERT INTO ZPDA_CLEANTABLE (LOADID,LINE) VALUES (:ID, :LINE);22 22 
28 14 ZPDA_LOAD_TIME80 20 32 SELECT 1 INTO :FIRST FROM DUMMY;23 23 
28 14 ZPDA_LOAD_TIME80 20 8 LOOP 10;24 24 
28 14 ZPDA_LOAD_TIME80 20 9 LABEL 20;25 25 
28 14 ZPDA_LOAD_TIME80 20 8 CLOSE C;26 26 
28 14 ZPDA_LOAD_TIME80 20 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */27 27 
28 14 ZPDA_LOAD_TIME80 20 36 GOSUB 200; /* CLEAN UP LOADING ID */28 28 
28 14 ZPDA_LOAD_TIME80 20 25 /************************29 29 
28 14 ZPDA_LOAD_TIME80 20 25 ************************/30 30 
28 14 ZPDA_LOAD_TIME80 20 8 SUB 100;31 31 
28 14 ZPDA_LOAD_TIME80 20 22 /* GET A LOADING ID */32 32 
28 14 ZPDA_LOAD_TIME80 20 57 SELECT 0 + MAX(LOADID) + 1 INTO :ID FROM ZPDA_CLEANTABLE;33 33 
28 14 ZPDA_LOAD_TIME80 20 59 INSERT INTO ZPDA_CLEANTABLE (LOADID, LINE) VALUES (:ID, 0);34 34 
28 14 ZPDA_LOAD_TIME80 20 7 RETURN;35 35 
28 14 ZPDA_LOAD_TIME80 20 4 /**/36 36 
28 14 ZPDA_LOAD_TIME80 20 8 SUB 200;37 37 
28 14 ZPDA_LOAD_TIME80 20 25 /* CLEAN UP LOADING ID */38 38 
28 14 ZPDA_LOAD_TIME80 20 31 SELECT 0 INTO :NOLD FROM DUMMY;39 39 
28 14 ZPDA_LOAD_TIME80 20 47 DELETE FROM ZPDA_CLEANTABLE WHERE LOADID = :ID;40 40 
28 14 ZPDA_LOAD_TIME80 20 7 RETURN;41 41 
28 14 ZPDA_LOAD_TIME80 20 8 SUB 300;42 42 
28 14 ZPDA_LOAD_TIME80 20 35 /* DELETE LOADED FROM LOAD TABLE */43 43 
28 14 ZPDA_LOAD_TIME80 20 25 GOTO 310 WHERE :NOLD = 1;44 44 
28 14 ZPDA_LOAD_TIME80 20 11 DELETE FROM45 45 
28 14 ZPDA_LOAD_TIME80 20 41 /********************** LOAD TABLE NAME*/46 46 
28 14 ZPDA_LOAD_TIME80 20 14 ZPDA_TIME_LOAD47 47 
28 14 ZPDA_LOAD_TIME80 20 41 /***************************************/48 48 
28 14 ZPDA_LOAD_TIME80 20 13 WHERE LINE IN49 49 
28 14 ZPDA_LOAD_TIME80 20 1 (50 50 
28 14 ZPDA_LOAD_TIME80 20 32 SELECT LINE FROM ZPDA_CLEANTABLE51 51 
28 14 ZPDA_LOAD_TIME80 20 18 WHERE LOADID = :ID52 52 
28 14 ZPDA_LOAD_TIME80 20 12 AND LINE > 053 53 
28 14 ZPDA_LOAD_TIME80 20 2 );54 54 
28 14 ZPDA_LOAD_TIME80 20 10 LABEL 310;55 55 
28 14 ZPDA_LOAD_TIME80 20 7 RETURN;56 56 
EOF
echo End of Upgrade 7.0.3

echo Begin of Upgrade 7.0.3
DBI <<\EOF
CREATE TABLE ZSFDC_CLEANTABLE 'SFDC Load Clean Up' 1
LOADID (INT,17,'Load ID')
LINE (INT,17,'Ln')
UNIQUE (LOADID,LINE)
;
EOF
DBI <<\EOF
CREATE TABLE ZSFDC_PRODREP 'SFDC ProductiOn Reporting' 0
RECORDTYPE (CHAR,3,'Record Type')
LINE (INT,17,'Ln')
LOADED (CHAR,1,'Loaded?')
KEY1 (CHAR,20,'Key 1')
KEY2 (CHAR,20,'Key 2')
KEY3 (CHAR,20,'Key 3')
CURDATE (DATE,8,'Date')
FORMNAME (CHAR,16,'Form Number')
SHIFTNAME (CHAR,8,'Shift')
DETAILS (CHAR,24,'Details')
FINAL (CHAR,1,'Final')
SERIALNAME (CHAR,22,'Work Order')
PARTNAME (CHAR,15,'Part Number')
ACTNAME (CHAR,16,'Operation')
WORKCNAME (CHAR,6,'Work Cell')
USERID (INT,16,'Employee ID')
QUANT (INT,17,'Qty Completed')
SQUANT (INT,17,'Qty Rejected')
DEFECTCODE (CHAR,3,'Defect Code')
MQUANT (INT,17,'Qty for MRB')
TQUANT (INT,17,'Completed (Buy/Sell)')
TSQUANT (INT,17,'Rejected (Buy/Sell)')
TMQUANT (INT,17,'MRB (Buy/Sell Units)')
NUMPACK (INT,13,'Packing Crates (No.)')
PACKCODE (CHAR,2,'Packing Crate Code')
STIME (CHAR,5,'Start Time')
ETIME (CHAR,5,'End Time')
ASPAN (TIME,6,'Span')
EMPSTIME (CHAR,5,'Start Labor')
EMPETIME (CHAR,5,'End Labor')
EMPASPAN (TIME,6,'Labor Span')
SHIFTNAME2 (CHAR,8,'Type 2 Shift')
TOOLNAME (CHAR,15,'Tool')
RTYPEBOOL (CHAR,1,'Rework?')
MODE (CHAR,1,'Set-up/Break (S/B)')
WARHSNAME (CHAR,4,'To Warehouse')
LOCNAME (CHAR,14,'Bin')
NEWPALLET (CHAR,1,'New Pallet?')
TOPALLETNAME (CHAR,16,'To Pallet')
ACTCANCEL (CHAR,1,'Remove Oper. Number?')
SERCANCEL (CHAR,1,'Remove Wk Order No.?')
UNIQUE (LINE)
;
EOF
BRING << \EOF
18 13 ZSFDC_PRODREP0 
56 13 ZSFDC_PRODREP25 SFDC ProductiOn Reporting0 
19 13 ZSFDC_PRODREP1 10 RECORDTYPE4 CHAR3 3 11 Record Type
19 13 ZSFDC_PRODREP2 4 LINE3 INT17 8 2 Ln
33 13 ZSFDC_PRODREP4 LINE0 48 
19 13 ZSFDC_PRODREP3 6 LOADED4 CHAR1 1 7 Loaded?
19 13 ZSFDC_PRODREP4 4 KEY14 CHAR20 20 5 Key 1
19 13 ZSFDC_PRODREP5 4 KEY24 CHAR20 20 5 Key 2
19 13 ZSFDC_PRODREP6 4 KEY34 CHAR20 20 5 Key 3
19 13 ZSFDC_PRODREP7 7 CURDATE4 DATE8 8 4 Date
19 13 ZSFDC_PRODREP8 8 FORMNAME4 CHAR16 16 11 Form Number
19 13 ZSFDC_PRODREP9 9 SHIFTNAME4 CHAR8 8 5 Shift
19 13 ZSFDC_PRODREP10 7 DETAILS4 CHAR24 24 7 Details
19 13 ZSFDC_PRODREP11 5 FINAL4 CHAR1 1 5 Final
19 13 ZSFDC_PRODREP12 10 SERIALNAME4 CHAR22 22 10 Work Order
19 13 ZSFDC_PRODREP13 8 PARTNAME4 CHAR15 15 11 Part Number
19 13 ZSFDC_PRODREP14 7 ACTNAME4 CHAR16 16 9 Operation
19 13 ZSFDC_PRODREP15 9 WORKCNAME4 CHAR6 6 9 Work Cell
19 13 ZSFDC_PRODREP16 6 USERID3 INT16 8 11 Employee ID
33 13 ZSFDC_PRODREP6 USERID0 48 
19 13 ZSFDC_PRODREP17 5 QUANT3 INT17 8 13 Qty Completed
33 13 ZSFDC_PRODREP5 QUANT0 48 
19 13 ZSFDC_PRODREP18 6 SQUANT3 INT17 8 12 Qty Rejected
33 13 ZSFDC_PRODREP6 SQUANT0 48 
19 13 ZSFDC_PRODREP19 10 DEFECTCODE4 CHAR3 3 11 Defect Code
19 13 ZSFDC_PRODREP20 6 MQUANT3 INT17 8 11 Qty for MRB
33 13 ZSFDC_PRODREP6 MQUANT0 48 
19 13 ZSFDC_PRODREP21 6 TQUANT3 INT17 8 20 Completed (Buy/Sell)
33 13 ZSFDC_PRODREP6 TQUANT0 48 
19 13 ZSFDC_PRODREP22 7 TSQUANT3 INT17 8 19 Rejected (Buy/Sell)
33 13 ZSFDC_PRODREP7 TSQUANT0 48 
19 13 ZSFDC_PRODREP23 7 TMQUANT3 INT17 8 20 MRB (Buy/Sell Units)
33 13 ZSFDC_PRODREP7 TMQUANT0 48 
19 13 ZSFDC_PRODREP24 7 NUMPACK3 INT13 8 20 Packing Crates (No.)
33 13 ZSFDC_PRODREP7 NUMPACK0 48 
19 13 ZSFDC_PRODREP25 8 PACKCODE4 CHAR2 2 18 Packing Crate Code
19 13 ZSFDC_PRODREP26 5 STIME4 CHAR5 5 10 Start Time
19 13 ZSFDC_PRODREP27 5 ETIME4 CHAR5 5 8 End Time
19 13 ZSFDC_PRODREP28 5 ASPAN4 TIME6 8 4 Span
19 13 ZSFDC_PRODREP29 8 EMPSTIME4 CHAR5 5 11 Start Labor
19 13 ZSFDC_PRODREP30 8 EMPETIME4 CHAR5 5 9 End Labor
19 13 ZSFDC_PRODREP31 8 EMPASPAN4 TIME6 8 10 Labor Span
19 13 ZSFDC_PRODREP32 10 SHIFTNAME24 CHAR8 8 12 Type 2 Shift
19 13 ZSFDC_PRODREP33 8 TOOLNAME4 CHAR15 15 4 Tool
19 13 ZSFDC_PRODREP34 9 RTYPEBOOL4 CHAR1 1 7 Rework?
19 13 ZSFDC_PRODREP35 4 MODE4 CHAR1 1 18 Set-up/Break (S/B)
19 13 ZSFDC_PRODREP36 9 WARHSNAME4 CHAR4 4 12 To Warehouse
19 13 ZSFDC_PRODREP37 7 LOCNAME4 CHAR14 14 3 Bin
19 13 ZSFDC_PRODREP38 9 NEWPALLET4 CHAR1 1 11 New Pallet?
19 13 ZSFDC_PRODREP39 12 TOPALLETNAME4 CHAR16 16 9 To Pallet
19 13 ZSFDC_PRODREP40 9 ACTCANCEL4 CHAR1 1 20 Remove Oper. Number?
19 13 ZSFDC_PRODREP41 9 SERCANCEL4 CHAR1 1 20 Remove Wk Order No.?
20 13 ZSFDC_PRODREP85 1 
21 13 ZSFDC_PRODREP1 4 LINE1 
17 13 ZSFDC_PRODREP27 Load SFDC Production Report13 ZSFDC_PRODREP73 89 0 0 0 0 0 9999 
57 20 Internal Development1 
58 1 13 ZSFDC_PRODREP73 
59 13 ZSFDC_PRODREP73 1 15 AFORM70 0 
59 13 ZSFDC_PRODREP73 1 25 ALINE70 0 
60 13 ZSFDC_PRODREP73 9 ACTCANCEL5 ALINE70 9 ACTCANCEL0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 ACTNAME5 ALINE70 7 ACTNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 CURDATE5 AFORM70 7 CURDATE1 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 10 DEFECTCODE5 ALINE70 10 DEFECTCODE0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 DETAILS5 AFORM70 7 DETAILS4 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 5 FINAL5 AFORM70 5 FINAL5 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 8 FORMNAME5 AFORM70 8 FORMNAME2 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 LOCNAME5 ALINE70 7 LOCNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 4 MODE5 ALINE70 4 MODE0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 6 MQUANT5 ALINE70 6 MQUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 NEWPALLET5 ALINE70 9 NEWPALLET0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 NUMPACK5 ALINE70 7 NUMPACK0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 8 PACKCODE5 ALINE70 8 PACKCODE0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 10 PACKCODE@25 ALINE70 8 PACKCODE0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 8 PARTNAME5 ALINE70 8 PARTNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 5 QUANT5 ALINE70 5 QUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 RTYPEBOOL5 ALINE70 9 RTYPEBOOL0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 SERCANCEL5 ALINE70 9 SERCANCEL0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 10 SERIALNAME5 ALINE70 10 SERIALNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 SHIFTNAME5 AFORM70 9 SHIFTNAME3 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 10 SHIFTNAME25 ALINE70 9 SHIFTNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 6 SQUANT5 ALINE70 6 SQUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 TMQUANT5 ALINE70 7 TMQUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 8 TOOLNAME5 ALINE70 8 TOOLNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 12 TOPALLETNAME5 ALINE70 12 TOPALLETNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 6 TQUANT5 ALINE70 6 TQUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 7 TSQUANT5 ALINE70 7 TSQUANT0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 6 USERID5 ALINE70 6 USERID0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 WARHSNAME5 ALINE70 9 WARHSNAME0 0 0 0 0 0 
60 13 ZSFDC_PRODREP73 9 WORKCNAME5 ALINE70 9 WORKCNAME0 0 0 0 0 0 
17 13 ZSFDC_PRODREP25 SFDC ProductiOn Reporting13 ZSFDC_PRODREP70 0 0 0 78 4 SFDC0 0 
57 20 Internal Development1 
58 1 13 ZSFDC_PRODREP70 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 ACTCANCEL0 9 ACTCANCEL0 0 1 0 400 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 ACTNAME0 7 ACTNAME0 0 16 0 140 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP5 ASPAN0 5 ASPAN0 0 6 0 280 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 CURDATE0 7 CURDATE0 0 8 0 70 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP10 DEFECTCODE0 10 DEFECTCODE0 0 3 0 190 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 DETAILS0 7 DETAILS0 0 24 0 100 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 EMPASPAN0 8 EMPASPAN0 0 6 0 310 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 EMPETIME0 8 EMPETIME0 0 5 0 300 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 EMPSTIME0 8 EMPSTIME0 0 5 0 290 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP5 ETIME0 5 ETIME0 0 5 0 270 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP5 FINAL0 5 FINAL0 0 1 0 110 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 FORMNAME0 8 FORMNAME0 0 16 0 80 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP4 KEY10 4 KEY10 0 20 0 40 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP4 KEY20 4 KEY20 0 20 0 50 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP4 KEY30 4 KEY30 0 20 0 60 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP4 LINE0 4 LINE0 0 17 48 20 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP6 LOADED0 6 LOADED0 0 1 0 30 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 LOCNAME0 7 LOCNAME0 0 14 0 370 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP4 MODE0 4 MODE0 0 1 0 350 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP6 MQUANT0 6 MQUANT0 0 17 48 200 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 NEWPALLET0 9 NEWPALLET0 0 1 0 380 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 NUMPACK0 7 NUMPACK0 0 13 48 240 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 PACKCODE0 8 PACKCODE0 0 2 0 250 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 PARTNAME0 8 PARTNAME0 0 15 0 130 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP5 QUANT0 5 QUANT0 0 17 48 170 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP10 RECORDTYPE0 10 RECORDTYPE0 0 3 0 10 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 RTYPEBOOL0 9 RTYPEBOOL0 0 1 0 340 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 SERCANCEL0 9 SERCANCEL0 0 1 0 410 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP10 SERIALNAME0 10 SERIALNAME0 0 22 0 120 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 SHIFTNAME0 9 SHIFTNAME0 0 8 0 90 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP10 SHIFTNAME20 10 SHIFTNAME20 0 8 0 320 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP6 SQUANT0 6 SQUANT0 0 17 48 180 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP5 STIME0 5 STIME0 0 5 0 260 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 TMQUANT0 7 TMQUANT0 0 17 48 230 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP8 TOOLNAME0 8 TOOLNAME0 0 15 0 330 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP12 TOPALLETNAME0 12 TOPALLETNAME0 0 16 0 390 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP6 TQUANT0 6 TQUANT0 0 17 48 210 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP7 TSQUANT0 7 TSQUANT0 0 17 48 220 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP6 USERID0 6 USERID0 0 16 48 160 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 WARHSNAME0 9 WARHSNAME0 0 4 0 360 0 0 0 0 0 0 0 1 
13 13 ZSFDC_PRODREP70 13 ZSFDC_PRODREP9 WORKCNAME0 9 WORKCNAME0 0 6 0 150 0 0 0 0 0 0 0 1 
17 13 ZSFDC_PRODREP24 Load a Production Report0 80 0 0 0 0 4 SFDC0 0 
57 20 Internal Development1 
58 1 13 ZSFDC_PRODREP80 
7 13 ZSFDC_PRODREP80 10 4 SQLI67 
7 13 ZSFDC_PRODREP80 20 13 ZSFDC_PRODREP73 
7 13 ZSFDC_PRODREP80 30 4 SQLI67 
28 13 ZSFDC_PRODREP80 30 33 :ID = :LINE = :NOLD = :FIRST = 0;1 1 
28 13 ZSFDC_PRODREP80 30 19 :LOADED = :RT = '';2 2 
28 13 ZSFDC_PRODREP80 30 32 /* ITERATE THROUGH LOAD TABLE */3 3 
28 13 ZSFDC_PRODREP80 30 22 DECLARE Cur CURSOR FOR4 4 
28 13 ZSFDC_PRODREP80 30 36 SELECT RECORDTYPE, LINE, LOADED FROM5 5 
28 13 ZSFDC_PRODREP80 30 40 /********************** LOAD TABLE NAME*6 6 
28 13 ZSFDC_PRODREP80 30 13 ZSFDC_PRODREP7 7 
28 13 ZSFDC_PRODREP80 30 41 /***************************************/8 8 
28 13 ZSFDC_PRODREP80 30 15 WHERE LINE > 0;9 9 
28 13 ZSFDC_PRODREP80 30 9 OPEN Cur;10 10 
28 13 ZSFDC_PRODREP80 30 9 LABEL 10;11 11 
28 13 ZSFDC_PRODREP80 30 35 FETCH Cur INTO :RT, :LINE, :LOADED;12 12 
28 13 ZSFDC_PRODREP80 30 26 GOTO 20 WHERE :RETVAL = 0;13 13 
28 13 ZSFDC_PRODREP80 30 52 SELECT 1 INTO :NOLD FROM DUMMY WHERE :LOADED <> 'Y';14 14 
28 13 ZSFDC_PRODREP80 30 39 GOTO 15 WHERE :RT <> '1' OR :FIRST = 0;15 15 
28 13 ZSFDC_PRODREP80 30 19 /* RECORD TYPE 1 */16 16 
28 13 ZSFDC_PRODREP80 30 12 /* LOADED */17 17 
28 13 ZSFDC_PRODREP80 30 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */18 18 
28 13 ZSFDC_PRODREP80 30 36 GOSUB 200; /* CLEAN UP LOADING ID */19 19 
28 13 ZSFDC_PRODREP80 30 33 GOSUB 100; /* GET A LOADING ID */20 20 
28 13 ZSFDC_PRODREP80 30 9 LABEL 15;21 21 
28 13 ZSFDC_PRODREP80 30 63 INSERT INTO ZSFDC_CLEANTABLE (LOADID,LINE) VALUES (:ID, :LINE);22 22 
28 13 ZSFDC_PRODREP80 30 32 SELECT 1 INTO :FIRST FROM DUMMY;23 23 
28 13 ZSFDC_PRODREP80 30 8 LOOP 10;24 24 
28 13 ZSFDC_PRODREP80 30 9 LABEL 20;25 25 
28 13 ZSFDC_PRODREP80 30 10 CLOSE Cur;26 26 
28 13 ZSFDC_PRODREP80 30 46 GOSUB 300; /* DELETE LOADED FROM LOAD TABLE */27 27 
28 13 ZSFDC_PRODREP80 30 36 GOSUB 200; /* CLEAN UP LOADING ID */28 28 
28 13 ZSFDC_PRODREP80 30 25 /************************29 29 
28 13 ZSFDC_PRODREP80 30 25 ************************/30 30 
28 13 ZSFDC_PRODREP80 30 8 SUB 100;31 31 
28 13 ZSFDC_PRODREP80 30 22 /* GET A LOADING ID */32 32 
28 13 ZSFDC_PRODREP80 30 58 SELECT 0 + MAX(LOADID) + 1 INTO :ID FROM ZSFDC_CLEANTABLE;33 33 
28 13 ZSFDC_PRODREP80 30 60 INSERT INTO ZSFDC_CLEANTABLE (LOADID, LINE) VALUES (:ID, 0);34 34 
28 13 ZSFDC_PRODREP80 30 7 RETURN;35 35 
28 13 ZSFDC_PRODREP80 30 4 /**/36 36 
28 13 ZSFDC_PRODREP80 30 8 SUB 200;37 37 
28 13 ZSFDC_PRODREP80 30 25 /* CLEAN UP LOADING ID */38 38 
28 13 ZSFDC_PRODREP80 30 31 SELECT 0 INTO :NOLD FROM DUMMY;39 39 
28 13 ZSFDC_PRODREP80 30 48 DELETE FROM ZSFDC_CLEANTABLE WHERE LOADID = :ID;40 40 
28 13 ZSFDC_PRODREP80 30 7 RETURN;41 41 
28 13 ZSFDC_PRODREP80 30 8 SUB 300;42 42 
28 13 ZSFDC_PRODREP80 30 35 /* DELETE LOADED FROM LOAD TABLE */43 43 
28 13 ZSFDC_PRODREP80 30 25 GOTO 310 WHERE :NOLD = 1;44 44 
28 13 ZSFDC_PRODREP80 30 11 DELETE FROM45 45 
28 13 ZSFDC_PRODREP80 30 41 /********************** LOAD TABLE NAME*/46 46 
28 13 ZSFDC_PRODREP80 30 13 ZSFDC_PRODREP47 47 
28 13 ZSFDC_PRODREP80 30 41 /***************************************/48 48 
28 13 ZSFDC_PRODREP80 30 13 WHERE LINE IN49 49 
28 13 ZSFDC_PRODREP80 30 1 (50 50 
28 13 ZSFDC_PRODREP80 30 33 SELECT LINE FROM ZSFDC_CLEANTABLE51 51 
28 13 ZSFDC_PRODREP80 30 18 WHERE LOADID = :ID52 52 
28 13 ZSFDC_PRODREP80 30 12 AND LINE > 053 53 
28 13 ZSFDC_PRODREP80 30 2 );54 54 
28 13 ZSFDC_PRODREP80 30 10 LABEL 310;55 55 
28 13 ZSFDC_PRODREP80 30 7 RETURN;56 56 
7 13 ZSFDC_PRODREP80 40 3 END66 
EOF
echo End of Upgrade 7.0.3

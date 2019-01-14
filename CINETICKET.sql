--
-- Create Schema Script 
--   Database Version   : 11.2.0.1.0 
--   TOAD Version       : 9.7.2.5 
--   DB Connect String  : ORCLG2 
--   Schema             : CINETICKET 
--   Script Created by  : CINETICKET 
--   Script Created at  : 1/14/2019 3:37:29 PM 
--   Physical Location  :  
--   Notes              :  
--

-- Object Counts: 
--   Database Links: 1 
--   Indexes: 5         Columns: 5          
--   Packages: 5        Lines of Code: 188 
--   Package Bodies: 5  Lines of Code: 1817 
--   Procedures: 44     Lines of Code: 593 
--   Sequences: 3 
--   Tables: 8          Columns: 83         Constraints: 3      
--   Views: 2           


CREATE SEQUENCE SCQ_AUDIT_INFO
  START WITH 92513
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE SEQUENCE SCQ_SERVICE_ACCESS_LOG
  START WITH 67096
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE SEQUENCE SCQ_USER_INFO
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE TABLE AUDIT_INFO
(
  AUDIT_INFO_ID  NUMBER,
  AUDIT_LOG_ID   NUMBER                         NOT NULL,
  USER_ID        VARCHAR2(100 BYTE)             NOT NULL,
  CREATE_DATE    DATE                           NOT NULL,
  DETAIL         VARCHAR2(4000 BYTE)            NOT NULL,
  IS_ACTIVE      VARCHAR2(1 BYTE),
  IS_DELETED     VARCHAR2(1 BYTE),
  IPADDRESS      VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE AUDIT_LOG
(
  AUDIT_ID           NUMBER,
  AUDIT_DESC         VARCHAR2(200 BYTE),
  CREATE_DATE        DATE,
  USER_ID            NUMBER,
  IS_ACTIVE          VARCHAR2(2 BYTE),
  IS_DELETED         VARCHAR2(2 BYTE),
  LAST_UPDATED_BY    NUMBER,
  LAST_UPDATED_DATE  DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE CINEMAHALL
(
  ID                 NUMBER,
  CODE               VARCHAR2(200 BYTE),
  HALL_NAME          VARCHAR2(2000 BYTE),
  CREATE_DATE        DATE,
  IS_ACTIVE          VARCHAR2(2 BYTE),
  IS_DELETED         VARCHAR2(2 BYTE),
  LAST_UPDATED_BY    NUMBER,
  LAST_UPDATED_DATE  DATE,
  DESCRIPTION        VARCHAR2(2000 BYTE),
  DBUSER             VARCHAR2(100 BYTE),
  DBPASSWORD         VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE CINEMALOCATION
(
  ID                 NUMBER,
  CODE               VARCHAR2(200 BYTE),
  LOCATION_NAME      VARCHAR2(2000 BYTE),
  CREATE_DATE        DATE,
  IS_ACTIVE          VARCHAR2(2 BYTE),
  IS_DELETED         VARCHAR2(2 BYTE),
  LAST_UPDATED_BY    NUMBER,
  LAST_UPDATED_DATE  DATE,
  DESCRIPTION        VARCHAR2(2000 BYTE),
  DBUSER             VARCHAR2(100 BYTE),
  DBPASSWORD         VARCHAR2(100 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE CUSTOMERPROFILE
(
  ID                       NUMBER               NOT NULL,
  USERNAME                 VARCHAR2(50 BYTE),
  PASSWORD                 VARCHAR2(100 BYTE),
  NAME                     VARCHAR2(100 BYTE),
  GENDER                   VARCHAR2(10 BYTE),
  DOB                      DATE,
  EMAIL                    VARCHAR2(100 BYTE),
  MOBILE                   VARCHAR2(11 BYTE),
  PROFILE_EXTRA            VARCHAR2(2000 BYTE),
  IS_EMAIL_VERIFIED        CHAR(1 CHAR),
  IS_SMS_VERIFIED          CHAR(1 CHAR),
  IS_ACTIVE                CHAR(1 CHAR),
  IS_DELETED               CHAR(1 CHAR),
  EMAIL_VERIFICATION_CODE  VARCHAR2(100 BYTE),
  SMS_VERIFICATION_CODE    VARCHAR2(8 BYTE),
  PASSWORD_RECOVERY_CODE   VARCHAR2(8 BYTE),
  CREATED_BY               VARCHAR2(50 BYTE),
  CREATED_AT               DATE,
  UPDATED_BY               VARCHAR2(50 BYTE),
  UPDATED_AT               DATE,
  DELETED_BY               VARCHAR2(50 BYTE),
  DELETED_AT               DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE FEATURESTMP
(
  FEATUREID     NUMBER(10)                      NOT NULL,
  FEATUREIMAGE  BLOB
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE SERVICE_ACCESS_LOG
(
  ACCESS_ID          NUMBER,
  IP_ADDRESS         VARCHAR2(200 BYTE),
  USER_NAME          VARCHAR2(2000 BYTE),
  CREATE_DATE        DATE,
  OPERATION_NAME     VARCHAR2(2000 BYTE),
  IS_ACTIVE          VARCHAR2(2 BYTE),
  IS_DELETED         VARCHAR2(2 BYTE),
  LAST_UPDATED_BY    NUMBER,
  LAST_UPDATED_DATE  DATE
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE USER_INFO
(
  USER_ID             NUMBER,
  USER_NAME           VARCHAR2(200 BYTE),
  USER_PASSWORD       VARCHAR2(2000 BYTE),
  CREATE_DATE         DATE,
  TRANSACTION_STATUS  VARCHAR2(2 BYTE),
  IS_ACTIVE           VARCHAR2(2 BYTE),
  IS_DELETED          VARCHAR2(2 BYTE),
  LAST_UPDATED_BY     NUMBER,
  LAST_UPDATED_DATE   DATE,
  IP_ADDRESS          VARCHAR2(200 BYTE),
  SEND_SMS            VARCHAR2(2 BYTE),
  PERMISSION_STATUS   VARCHAR2(2 BYTE)
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX AUDIT_INFO_PK ON AUDIT_INFO
(AUDIT_INFO_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX AUDIT_LOG_PK ON AUDIT_LOG
(AUDIT_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX CUSTOMERPROFILE_PK ON CUSTOMERPROFILE
(ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX SERVICE_ACCESS_LOG_PK ON SERVICE_ACCESS_LOG
(ACCESS_ID)
LOGGING
NOPARALLEL;


CREATE UNIQUE INDEX USER_INFO_PK ON USER_INFO
(USER_ID)
LOGGING
NOPARALLEL;


CREATE DATABASE LINK TICKETLINK
 CONNECT TO SMBBO2
 IDENTIFIED BY <PWD>
 USING 'ORCLG2';


CREATE OR REPLACE PACKAGE            PKG_AUDIT AS
 PROCEDURE InsertData
    (
    LOG_ID IN NUMBER,
    USERBY IN VARCHAR2,
    AUDIT_DETAIL IN AUDIT_INFO.DETAIL%TYPE,
    IPADDRESS IN VARCHAR2
          
    );
     PROCEDURE AuditData
    (
    LOG_ID IN NUMBER,
    USERBY IN VARCHAR2,
    AUDIT_DETAIL IN AUDIT_INFO.DETAIL%TYPE,
    IPADDRESS IN VARCHAR2
          
    );
END PKG_AUDIT;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE            PKG_BBO_TICKET_SERVICE AS
PROCEDURE PROC_GET_TICKETOPTIONVALUE(p_optionId IN VARCHAR2,p_cursor_option OUT SYS_REFCURSOR);
PROCEDURE PROC_GET_SHOWDATES (p_cursor_date OUT SYS_REFCURSOR);
PROCEDURE PROC_GET_MOVIES(p_showdate in Date, p_cursor_movie OUT SYS_REFCURSOR);
PROCEDURE PROC_GET_SHOWTIME(p_showdate IN Date,p_featureid IN number, p_cursor_time OUT SYS_REFCURSOR);
PROCEDURE PROC_VALIDATE_SHOWTIME(p_programid IN number, p_cursor_time OUT SYS_REFCURSOR);
PROCEDURE PROC_GET_SEATTYPE(p_programid IN number, p_cursor_seattype OUT SYS_REFCURSOR);
PROCEDURE PROC_VALIDATE_SEAT(p_programid IN number,p_classheirarchey IN Number, p_cursor_seattype OUT SYS_REFCURSOR);
PROCEDURE PROC_GET_TICKETUNITPRICE(p_programid IN number,p_classheirarchey IN Number, p_cursor_price OUT SYS_REFCURSOR);
END PKG_BBO_TICKET_SERVICE;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE            PKG_CINE_API AS

PROCEDURE cineApiPurchaseLog
    (
        i_tranid IN NUMBER,
        i_trandatefrom IN VARCHAR2,
        i_trandateto IN VARCHAR2,
        i_status IN VARCHAR2,
        result out NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    

END PKG_CINE_API;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE            PKG_CUSTOMER_PROFILE AS
 PROCEDURE InsertCustomerProfile
    (
    
        i_loginusername IN VARCHAR2,                 
        i_loginpassword IN VARCHAR2,                 
        i_name IN VARCHAR2,                     
        i_gender IN VARCHAR2,                  
        i_dob IN VARCHAR2,                    
        i_email IN VARCHAR2,                  
        i_mobile IN VARCHAR2,                   
        i_profileextra IN VARCHAR2 ,           
        i_isemailverified IN VARCHAR2,     
        i_issmsverified IN VARCHAR2,                    
        i_emailverificationcode IN VARCHAR2,
        i_smsverificationcode IN VARCHAR2,   
        i_passwordrecoverycode IN VARCHAR2,  
        i_action IN NUMBER,
        result out NUMBER
          
    );
 
 PROCEDURE UpdateCustomerProfile
    (
    
        i_loginusername IN VARCHAR2,                 
        i_loginpassword IN VARCHAR2,                 
        i_name IN VARCHAR2,                     
        i_gender IN VARCHAR2,                  
        i_dob IN VARCHAR2,                    
        i_email IN VARCHAR2,                  
        i_mobile IN VARCHAR2,                   
        i_profileextra IN VARCHAR2 ,           
        i_isemailverified IN VARCHAR2,     
        i_issmsverified IN VARCHAR2,                    
        i_emailverificationcode IN VARCHAR2,
        i_smsverificationcode IN VARCHAR2,   
        i_passwordrecoverycode IN VARCHAR2,  
        i_action IN NUMBER,
        result out NUMBER
          
    );
       
 PROCEDURE SelectCustomerProfile
    (
    
        i_loginusername IN VARCHAR2,                 
        i_action IN NUMBER,
        result out NUMBER,
        p_cursor OUT SYS_REFCURSOR
          
    ); 
 
  
END PKG_CUSTOMER_PROFILE;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE            PKG_TICKE_PURCHAGE AS
 PROCEDURE InsertConcessionBookingData
    (
    
        i_itemcode IN NUMBER, 
        i_noofitems IN NUMBER,
        i_totalamount IN NUMBER,
        i_mobilenumber IN varchar2,
        i_showdate IN varchar2,
        i_customername IN varchar2,
        i_agentname IN varchar2,
        result out NUMBER
          
    );
    
 PROCEDURE InsertTransactionData
    (
    
        i_programid IN NUMBER,
        i_nooftickets IN NUMBER,
        i_totalamount IN NUMBER,
        i_mobilenumber IN varchar2,
        i_seattype IN NUMBER,
        i_showdate IN varchar2,
        i_customername IN varchar2,
        result out NUMBER
          
    );
    
 PROCEDURE InsertBookingData_Bak
    (
    
        i_programid IN NUMBER,
        i_nooftickets IN NUMBER,
        i_totalamount IN NUMBER,
        i_mobilenumber IN varchar2,
        i_seattype IN NUMBER,
        i_showdate IN varchar2,
        i_customername IN varchar2,
        i_agentname IN varchar2,
        result out NUMBER
          
    );
    
    PROCEDURE InsertBookingData
    (
    
        i_programid IN NUMBER,
        i_featureid IN NUMBER, 
        i_nooftickets IN NUMBER,
        i_totalamount IN NUMBER,
        i_mobilenumber IN varchar2,
        i_seattype IN NUMBER,
        i_showdate IN varchar2,
        i_customername IN varchar2,
        i_agentname IN varchar2,
        result out NUMBER
          
    );
    
  PROCEDURE confirmTransactionData
    (
    
        i_trancode IN varchar2,
        i_tickamt IN varchar2,
        result out NUMBER
          
    );  
    

  PROCEDURE confirmConcessionTransData
    (
    
        i_trancode IN varchar2,
        i_concessionamt IN varchar2,
        result out NUMBER
          
    );    
PROCEDURE cancelTransaction
    (
    
        i_programid IN NUMBER,
        i_nooftickets IN NUMBER,
        i_totalamount IN NUMBER,
        i_bookingid IN NUMBER,
        i_agentname IN varchar2,
        result out NUMBER
          
    );       
    
END PKG_TICKE_PURCHAGE;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY            PKG_AUDIT AS

PROCEDURE InsertData
    (
    LOG_ID IN NUMBER,
    USERBY IN VARCHAR2,
    AUDIT_DETAIL IN AUDIT_INFO.DETAIL%TYPE,
    IPADDRESS IN VARCHAR2
          
    )
  AS 
    
   BEGIN 
INSERT INTO AUDIT_INFO (
    AUDIT_INFO_ID,
    AUDIT_LOG_ID ,
    USER_ID,
    CREATE_DATE,
    DETAIL,
    IPADDRESS,
    IS_ACTIVE ,
    IS_DELETED
   )
VALUES (
   SCQ_AUDIT_INFO.nextval,
    LOG_ID,
    USERBY,
    SYSDATE,
    AUDIT_DETAIL,
    IPADDRESS,
    'Y',
    'N'
    
    );
   

    END InsertData;
    PROCEDURE AuditData
    (
    LOG_ID IN NUMBER,
    USERBY IN VARCHAR2,
    AUDIT_DETAIL IN AUDIT_INFO.DETAIL%TYPE,
    IPADDRESS IN VARCHAR2
          
    )
  AS 
    
   BEGIN 
INSERT INTO AUDIT_INFO (
    AUDIT_INFO_ID,
    AUDIT_LOG_ID ,
    USER_ID,
    CREATE_DATE,
    DETAIL,
    IPADDRESS,
    IS_ACTIVE ,
    IS_DELETED
   )
VALUES (
   SCQ_AUDIT_INFO.nextval,
    LOG_ID,
    USERBY,
    SYSDATE,
    AUDIT_DETAIL,
    IPADDRESS,
    'Y',
    'N'
    
    );
    commit;
    END AuditData;

END PKG_AUDIT;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY            PKG_BBO_TICKET_SERVICE AS

PROCEDURE PROC_GET_TICKETOPTIONVALUE(p_optionId IN VARCHAR2,p_cursor_option OUT SYS_REFCURSOR)
AS
BEGIN 
       OPEN p_cursor_option FOR 
       select optvalue from optionbag@ticketlink 
       where optid= p_optionId;
END PROC_GET_TICKETOPTIONVALUE;
PROCEDURE PROC_GET_SHOWDATES(p_cursor_date OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_date FOR
        SELECT distinct TO_CHAR(pf.showdate,'DD-MON-YYYY') as showdate 
        FROM programedfilm@ticketlink pf
        WHERE pf.status = 'N' and pf.IsOnline='Y'
        AND pf.isprosponed='N'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1);
END PROC_GET_SHOWDATES;

PROCEDURE PROC_GET_MOVIES(p_showdate in Date, p_cursor_movie OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_movie FOR
        SELECT distinct(f.featureid) as id, f.TRAILERURL as trailerurl, TO_CHAR(pf.showdate,'DD-MON-YYYY') as showdate, f.longtitle as longname,f.shorttitle as shortname, f.flength as flength , f.synopsis as synopsis  
        FROM programedfilm@ticketlink pf,features@ticketlink f
        WHERE pf.featureid = f.featureid
        AND pf.status = 'N' and pf.IsOnline='Y'
        AND pf.isprosponed='N'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1)
        AND pf.showdate=p_showdate;
        
END PROC_GET_MOVIES;

PROCEDURE PROC_GET_SHOWTIME(p_showdate IN Date,p_featureid IN number, p_cursor_time OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_time FOR
        SELECT distinct pf.programid,(pf.featureid) as id,
        to_char(st.showtime,'hh24:mi:ss') as showtime,TO_CHAR(pf.showdate,'DD-MON-YYYY') as showdate,
        to_char(sysdate,'YYYY-MM-DD hh24:mi') as systemdate 
        FROM programedfilm@ticketlink pf, showtime@ticketlink st
        WHERE pf.showtimeid = st.showtimeid
        AND pf.boxofficeid = st.boxofficeid
        AND pf.status = 'N' and pf.IsOnline='Y'
        AND pf.isprosponed='N'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1)
        AND pf.showdate=p_showdate
        AND pf.featureid=p_featureid
        ORDER BY showtime;
        
END PROC_GET_SHOWTIME;

PROCEDURE PROC_VALIDATE_SHOWTIME(p_programid IN number, p_cursor_time OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_time FOR
        SELECT distinct pf.programid,(pf.featureid) as id,
        to_char(st.showtime,'hh24:mi:ss') as showtime,TO_CHAR(pf.showdate,'DD-MON-YYYY') as showdate,
        to_char(sysdate,'YYYY-MM-DD hh24:mi') as systemdate 
        FROM programedfilm@ticketlink pf, showtime@ticketlink st
        WHERE pf.showtimeid = st.showtimeid
        AND pf.boxofficeid = st.boxofficeid
        AND pf.status = 'N' and pf.IsOnline='Y'
        AND pf.isprosponed='N'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1)
        AND pf.programid=p_programid
        ORDER BY showtime;
        
END PROC_VALIDATE_SHOWTIME;

PROCEDURE PROC_GET_SEATTYPE(p_programid IN number, p_cursor_seattype OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_seattype FOR
        SELECT sp.classheirarchey as SeatType,count(*) as SeatCount
        FROM seatplan@ticketlink sp, programedFilm@ticketlink pf,TicketBook@ticketlink tb
        WHERE sp.boxofficeid = pf.boxofficeid
        AND pf.ProgramId=tb.ProgramId AND sp.SeatSeqId=tb.TicketSeqId
        AND sp.isonline='Y' AND pf.IsOnline='Y' AND tb.Status='B'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1)
        AND pf.programId = p_programid
        GROUP BY sp.classheirarchey
        HAVING count(*)>0;
        
END PROC_GET_SEATTYPE;

PROCEDURE PROC_VALIDATE_SEAT(p_programid IN number,p_classheirarchey IN Number, p_cursor_seattype OUT SYS_REFCURSOR)
AS
BEGIN 
    OPEN p_cursor_seattype FOR
        SELECT sp.classheirarchey as SeatType,count(*) as SeatCount
        FROM seatplan@ticketlink sp, programedFilm@ticketlink pf,TicketBook@ticketlink tb
        WHERE sp.boxofficeid = pf.boxofficeid
        AND pf.ProgramId=tb.ProgramId AND sp.SeatSeqId=tb.TicketSeqId
        AND sp.isonline='Y' AND pf.IsOnline='Y' AND tb.Status='B'
        AND pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+1)
        AND pf.programId = p_programid
        AND sp.classheirarchey=p_classheirarchey
        GROUP BY sp.classheirarchey 
        HAVING count(*)>0;
        
END PROC_VALIDATE_SEAT;

PROCEDURE PROC_GET_TICKETUNITPRICE(p_programid IN number,p_classheirarchey IN Number, p_cursor_price OUT SYS_REFCURSOR)
AS

BEGIN 
        OPEN p_cursor_price FOR
        SELECT TicketUnitPrice
        FROM vw_ticketprice@ticketlink
        WHERE PROGRAMID=p_programid and CLASSHEIRARCHEY=p_classheirarchey;   
     
END PROC_GET_TICKETUNITPRICE;


END PKG_BBO_TICKET_SERVICE;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY            PKG_CINE_API AS
PROCEDURE cineApiPurchaseLog
    (
        i_tranid IN NUMBER,
        i_trandatefrom IN VARCHAR2,
        i_trandateto IN VARCHAR2,
        i_status IN VARCHAR2,
        result out NUMBER,
        p_cursor OUT SYS_REFCURSOR
    )
    AS
      var_cond varchar2(500);
    BEGIN
        var_cond:='';
        if i_tranid<>0 then
           var_cond:=var_cond + ' AND A.ONLINETRANSID=i_tranid';
        end if;
         result:=109;
         
         --select MAX(ID) into out_custId from CUSTOMERPROFILE; 
         
         
                  
          OPEN p_cursor FOR  
          
          SELECT    TO_CHAR(A.ONLINETRASDATE,'DD-MON-YYYY') AS TRANSDATE,TO_CHAR(A.ONLINETRASDATE,'hh24:mm:ss') AS TRANSTIME, 
                    A.ONLINETRANSID AS TRANSID,B.ONLINETRANSID AS SMSCODE,D.LONGTITLE AS MOVIE,
                    TO_CHAR(A.SHOWDATE,'DD-MON-YYYY') AS SHOWDATE, TO_CHAR(E.SHOWTIME,'hh24:mm:ss') AS SHOWTIME,
                    A.ONLINETICKETQTY AS QTY,A.ONLINEAMTTENDERED AS AMOUNT,F.CLASSTITLE,
                    A.CUSTOMER_NAME,A.MOBILENO,A.IS_BOOKED,A.INSERTEDBY
          FROM      ONLINESALEMASTERLOG@ticketlink A LEFT OUTER JOIN ONLINESALEMASTER@ticketlink B ON A.TRASACTION_ID=B.ONLINETRANSID
                    INNER JOIN PROGRAMEDFILM@ticketlink C ON A.PROGRAMID=C.PROGRAMID
                    INNER JOIN FEATURES@ticketlink D ON C.FEATUREID=D.FEATUREID 
                    INNER JOIN SHOWTIME@ticketlink E ON C.SHOWTIMEID=E.SHOWTIMEID AND C.BOXOFFICEID=E.BOXOFFICEID
                    INNER JOIN BOXOFFICECLASSES@ticketlink F ON C.BOXOFFICEID=F.BOXOFFICEID AND A.SEAT_TYPE=F.CLASSHEIRARCHEY 
                    WHERE 1=1 + var_cond;

         
     EXCEPTION
       WHEN OTHERS THEN
       result :=101;
       -- Consider logging the error and then re-raise
     --  RAISE;
     rollback;
      
    END cineApiPurchaseLog;
    
    
END PKG_CINE_API;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY            PKG_CUSTOMER_PROFILE AS
PROCEDURE InsertCustomerProfile
    (
        i_loginusername IN VARCHAR2,                 
        i_loginpassword IN VARCHAR2,                 
        i_name IN VARCHAR2,                     
        i_gender IN VARCHAR2,                  
        i_dob IN VARCHAR2,                    
        i_email IN VARCHAR2,                  
        i_mobile IN VARCHAR2,                   
        i_profileextra IN VARCHAR2 ,           
        i_isemailverified IN VARCHAR2,     
        i_issmsverified IN VARCHAR2,                    
        i_emailverificationcode IN VARCHAR2,
        i_smsverificationcode IN VARCHAR2,   
        i_passwordrecoverycode IN VARCHAR2,  
        i_action IN NUMBER,
        result out NUMBER
          
                
    )
    AS
      var_temp NUMBER;
      out_custId number;
      
      
      out_unitprice NUMBER;
      newRId number;
      tranID NUMBER;
      
    

  
    BEGIN
         out_custId := 0;
         var_temp:=1;
         result:=109;
         
         select NVL(MAX(ID), 0) into out_custId from CUSTOMERPROFILE; 
         
         
         IF(i_action=1) THEN
         
          out_custId := out_custId + 1;
          
          insert into CUSTOMERPROFILE(ID,USERNAME,PASSWORD,NAME,GENDER,DOB,EMAIL,MOBILE,PROFILE_EXTRA,IS_EMAIL_VERIFIED,IS_SMS_VERIFIED,EMAIL_VERIFICATION_CODE,SMS_VERIFICATION_CODE,PASSWORD_RECOVERY_CODE,CREATED_BY,CREATED_AT)
                            values(out_custId,i_loginusername,i_loginpassword,i_name,i_gender,to_date(i_dob, 'dd/mm/yyyy'),i_email,i_mobile,i_profileextra,i_isemailverified,i_issmsverified,i_emailverificationcode,i_smsverificationcode,i_passwordrecoverycode,i_loginusername,sysdate);
          
         result:=101;            
         
       --  ELSE IF(i_action=2) THEN 
         
         --ELSE IF(i_action=3) THEN
         
        -- ELSE IF(i_action=4) THEN
         
         ELSE
         
            result:=109;
            
         END IF;
         
      
         
     EXCEPTION
       WHEN OTHERS THEN
       result :=101;
       -- Consider logging the error and then re-raise
     --  RAISE;
     rollback;
      
    END InsertCustomerProfile;
    
 
PROCEDURE UpdateCustomerProfile
    (
        i_loginusername IN VARCHAR2,                 
        i_loginpassword IN VARCHAR2,                 
        i_name IN VARCHAR2,                     
        i_gender IN VARCHAR2,                  
        i_dob IN VARCHAR2,                    
        i_email IN VARCHAR2,                  
        i_mobile IN VARCHAR2,                   
        i_profileextra IN VARCHAR2 ,           
        i_isemailverified IN VARCHAR2,     
        i_issmsverified IN VARCHAR2,                    
        i_emailverificationcode IN VARCHAR2,
        i_smsverificationcode IN VARCHAR2,   
        i_passwordrecoverycode IN VARCHAR2,  
        i_action IN NUMBER,
        result out NUMBER
          
                
    )
    AS
      var_temp NUMBER;
      out_custId number;
      newRId number;
      tranID NUMBER;
      
    

  
    BEGIN
         out_custId := 0;
         var_temp:=1;
         result:=109;
         
        -- select MAX(ID) into out_custId from CUSTOMERPROFILE; 
         
         
         IF(i_action=2) THEN
         
         -- out_custId := out_custId + 1;
          
          update CUSTOMERPROFILE set USERNAME=i_loginusername,PASSWORD=i_loginpassword,NAME=i_name,GENDER=i_gender,DOB=to_date(i_dob, 'dd/mm/yyyy'),
EMAIL=i_email,MOBILE=i_mobile,PROFILE_EXTRA=i_profileextra,IS_EMAIL_VERIFIED=i_isemailverified,IS_SMS_VERIFIED=i_issmsverified,EMAIL_VERIFICATION_CODE=i_emailverificationcode,SMS_VERIFICATION_CODE=i_smsverificationcode,
PASSWORD_RECOVERY_CODE=i_passwordrecoverycode,UPDATED_BY=i_loginusername,UPDATED_AT=sysdate  where USERNAME=i_loginusername;
          
         result:=102;            
         
       --  ELSE IF(i_action=2) THEN 
         
         --ELSE IF(i_action=3) THEN
         
        -- ELSE IF(i_action=4) THEN
         
         ELSE
         
            result:=109;
            
         END IF;
         
      
         
     EXCEPTION
       WHEN OTHERS THEN
       result :=101;
       -- Consider logging the error and then re-raise
     --  RAISE;
     rollback;
      
    END UpdateCustomerProfile;   

PROCEDURE SelectCustomerProfile
    (
        i_loginusername IN VARCHAR2,                 
        i_action IN NUMBER,
        result out NUMBER,
        p_cursor OUT SYS_REFCURSOR 
    )
    AS
      var_temp NUMBER;
      out_custId number;
      
    BEGIN
         out_custId := 0;
         var_temp:=1;
         result:=109;
         
         --select MAX(ID) into out_custId from CUSTOMERPROFILE; 
         
         
         IF(i_action=3) THEN
         
          OPEN p_cursor FOR  
          
          select USERNAME as Uname,PASSWORD as pass,NAME as name,GENDER as gender ,DOB as dob,EMAIL as email,MOBILE as  mobile,PROFILE_EXTRA as profExtra,IS_EMAIL_VERIFIED as emailVari,IS_SMS_VERIFIED as smsVari,EMAIL_VERIFICATION_CODE as evCode,
          SMS_VERIFICATION_CODE as svCode,PASSWORD_RECOVERY_CODE as prCode from
          CUSTOMERPROFILE where USERNAME=i_loginusername;
          
          result:=103;            
         
              
         ELSE
         
            result:=109;
            
         END IF;
         
      
         
     EXCEPTION
       WHEN OTHERS THEN
       result :=101;
       -- Consider logging the error and then re-raise
     --  RAISE;
     rollback;
      
    END SelectCustomerProfile;
    
    
END PKG_CUSTOMER_PROFILE;
/

SHOW ERRORS;


CREATE OR REPLACE PACKAGE BODY            PKG_TICKE_PURCHAGE
AS
   PROCEDURE InsertConcessionBookingData (i_itemcode       IN     NUMBER,
                                          i_noofitems      IN     NUMBER,
                                          i_totalamount    IN     NUMBER,
                                          i_mobilenumber   IN     VARCHAR2,
                                          i_showdate       IN     VARCHAR2,
                                          i_customername   IN     VARCHAR2,
                                          i_agentname      IN     VARCHAR2,
                                          result              OUT NUMBER)
   AS
      var_temp           NUMBER;
      out_unitprice      NUMBER;
      total_price        NUMBER;
      newRId             NUMBER;
      tranID             NUMBER;
      out_transId        NUMBER;
      cin_ticketnumber   NUMBER;
      cin_ticketseqid    NUMBER;
      cin_boxofficeid    NUMBER;
      cin_rownum         NUMBER;
      cin_columnnum      NUMBER;
      cin_seatnum        VARCHAR2 (100);
      out_showdate       VARCHAR2 (30);
   BEGIN
      out_transId := 0;
      out_unitprice := 0;
      var_temp := 1;
      result := 101;
      out_showdate := '';



      SELECT   TO_CHAR (SYSDATE, 'mmddyyyyhhmiss') INTO out_transId FROM DUAL;

      SELECT   UNITCOST
        INTO   out_unitprice
        FROM   PRODUCTS@ticketlink
       WHERE   ITEMCODE = i_itemcode;


      IF (LENGTH (out_transId) > 0)
      THEN
         out_transId := out_transId + 1;
         total_price := out_unitprice * i_noofitems;



         FOR i IN 1 .. i_noofitems
         LOOP
            IF (var_temp = 1)
            THEN
               INSERT INTO ONLINECONCESSIONMASTERLOG@ticketlink (
                                                                    onlinetransid,
                                                                    onlinetrasdate,
                                                                    ONLINECONCESSIONQTY,
                                                                    onlineamttendered,
                                                                    status,
                                                                    mobileno,
                                                                    showdate,
                                                                    IS_BOOKED,
                                                                    customer_name,
                                                                    insertedby,
                                                                    inserteddate
                          )
                 VALUES   (out_transId,
                           SYSDATE,
                           i_noofitems,
                           total_price,
                           '0',
                           i_mobilenumber,
                           TO_DATE (i_showdate, 'dd/mm/yyyy'),
                           'Y',
                           i_customername,
                           i_agentname,
                           SYSDATE);
            END IF;

            IF (var_temp <= i_noofitems)
            THEN
               INSERT INTO ONLINECONCESSIONDETAILSLOG@ticketlink (
                                                                     onlinetransid,
                                                                     ONLINECONCESSIONID,
                                                                     onlinecost,
                                                                     status,
                                                                     insertedby,
                                                                     inserteddate
                          )
                 VALUES   (out_transId,
                           i_itemcode,
                           out_unitprice,
                           '0',
                           i_agentname,
                           SYSDATE);
            END IF;

            var_temp := var_temp + 1;
         END LOOP;

         result := out_transId;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END InsertConcessionBookingData;

   PROCEDURE InsertTransactionData (i_programid      IN     NUMBER,
                                    i_nooftickets    IN     NUMBER,
                                    i_totalamount    IN     NUMBER,
                                    i_mobilenumber   IN     VARCHAR2,
                                    i_seattype       IN     NUMBER,
                                    i_showdate       IN     VARCHAR2,
                                    i_customername   IN     VARCHAR2,
                                    result              OUT NUMBER)
   AS
      var_temp           NUMBER;
      out_unitprice      NUMBER;
      newRId             NUMBER;
      tranID             NUMBER;
      out_transId        NUMBER;
      cin_ticketnumber   NUMBER;
      cin_ticketseqid    NUMBER;
      cin_SEATSEQID      NUMBER;
      cin_boxofficeid    NUMBER;
      cin_rownum         NUMBER;
      cin_columnnum      NUMBER;
      cin_seatnum        VARCHAR2 (100);


      CURSOR auth_trx
      IS
           SELECT   tb.ticketnumber,
                    tb.ticketseqid,
                    SP.SEATSEQID,
                    sp.boxofficeid,
                    sp.rowno,
                    sp.columnid,
                    sp.seatnum
             FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp --, ONLINESALEDETAILSLOG@ticketlink dlog
            WHERE       sp.seatseqid = tb.ticketseqid
                    AND sp.classheirarchey = i_seattype
                    AND sp.IsOnLine = 'Y'
                    AND tb.Status = 'B'
                    AND tb.programid = i_programid
                    AND tb.ticketnumber NOT IN
                             (SELECT   ONLINETICKETID
                                FROM   ONLINESALEDETAILSLOG@ticketlink
                               WHERE   is_booked = 'Y')
         ORDER BY   SP.SEATSEQID;
   BEGIN
      out_transId := 0;
      out_unitprice := 0;
      var_temp := 1;
      result := 101;

      IF (i_nooftickets > 4)
      THEN
         result := 104;
      ELSE
         SELECT   MAX (onlinetransId)
           INTO   out_transId
           FROM   onlinesalemaster@ticketlink;

         SELECT   TicketUnitPrice
           INTO   out_unitprice
           FROM   vw_ticketprice@ticketlink
          WHERE   PROGRAMID = i_programid AND CLASSHEIRARCHEY = i_seattype;



         IF (out_transId > 0)
         THEN
            out_transId := out_transId + 1;

            OPEN auth_trx;

            LOOP
               FETCH auth_trx
                  INTO
                            cin_ticketnumber, cin_ticketseqid, cin_SEATSEQID, cin_boxofficeid, cin_rownum, cin_columnnum, cin_seatnum;

               EXIT WHEN auth_trx%NOTFOUND;

               IF (var_temp = 1)
               THEN
                  INSERT INTO onlinesalemaster@ticketlink (onlinetransid,
                                                           onlinetrasdate,
                                                           onlineticketqty,
                                                           onlineamttendered,
                                                           status,
                                                           insertedby,
                                                           inserteddate,
                                                           programid,
                                                           showdate,
                                                           mobileno)
                    VALUES   (out_transId,
                              SYSDATE,
                              i_nooftickets,
                              i_totalamount,
                              '0',
                              i_customername,
                              SYSDATE,
                              i_programid,
                              TO_DATE (i_showdate, 'dd/mm/yyyy'),
                              i_mobilenumber);
               END IF;

               IF (var_temp <= i_nooftickets)
               THEN
                  INSERT INTO ONLINESALEDETAILS@ticketlink (onlinetransid,
                                                            onlineticketid,
                                                            onlinecost,
                                                            status,
                                                            insertedby,
                                                            inserteddate)
                    VALUES   (out_transId,
                              cin_ticketnumber,
                              out_unitprice,
                              '0',
                              i_customername,
                              SYSDATE);

                  UPDATE   ticketbook@ticketlink
                     SET   Status = 'S'
                   WHERE       TICKETNUMBER = cin_ticketnumber
                           AND PROGRAMID = i_programId
                           AND TICKETSEQID = cin_ticketseqid;
               END IF;

               var_temp := var_temp + 1;
            END LOOP;

            CLOSE auth_trx;



            result := out_transId;
         ELSE
            result := 101;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END InsertTransactionData;


   PROCEDURE InsertBookingData_Bak (i_programid      IN     NUMBER,
                                    i_nooftickets    IN     NUMBER,
                                    i_totalamount    IN     NUMBER,
                                    i_mobilenumber   IN     VARCHAR2,
                                    i_seattype       IN     NUMBER,
                                    i_showdate       IN     VARCHAR2,
                                    i_customername   IN     VARCHAR2,
                                    i_agentname      IN     VARCHAR2,
                                    result              OUT NUMBER)
   AS
      var_temp                NUMBER;
      out_unitprice           NUMBER;
      total_price             NUMBER;
      noofavailable_tickets   NUMBER;
      newRId                  NUMBER;
      tranID                  NUMBER;
      out_transId             NUMBER;
      cin_ticketnumber        NUMBER;
      cin_ticketseqid         NUMBER;
      cin_SEATSEQID           NUMBER;
      cin_boxofficeid         NUMBER;
      cin_rownum              NUMBER;
      cin_columnnum           NUMBER;
      cin_seatnum             VARCHAR2 (100);


      CURSOR auth_trx
      IS
           SELECT   tb.ticketnumber,
                    tb.ticketseqid,
                    SP.SEATSEQID,
                    sp.boxofficeid,
                    sp.rowno,
                    sp.columnid,
                    sp.seatnum
             FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
            WHERE       sp.seatseqid = tb.ticketseqid
                    AND sp.classheirarchey = i_seattype
                    AND sp.IsOnLine = 'Y'
                    AND tb.Status = 'B'
                    AND tb.ticketnumber NOT IN
                             (SELECT   ONLINETICKETID
                                FROM   ONLINESALEDETAILSLOG@ticketlink
                               WHERE   is_booked = 'Y')
                    AND tb.programid = i_programid
         ORDER BY   SP.rowno, sp.columnid;
   BEGIN
      out_transId := 0;
      out_unitprice := 0;
      var_temp := 1;
      result := 101;
      noofavailable_tickets := 0;

      IF (i_nooftickets > 4)
      THEN
         result := 104;
      ELSE
           SELECT   COUNT (ticketnumber)
             INTO   noofavailable_tickets
             FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
            WHERE       sp.seatseqid = tb.ticketseqid
                    AND sp.classheirarchey = i_seattype
                    AND sp.IsOnLine = 'Y'
                    AND tb.Status = 'B'
                    AND tb.ticketnumber NOT IN
                             (SELECT   ONLINETICKETID
                                FROM   ONLINESALEDETAILSLOG@ticketlink
                               WHERE   is_booked = 'Y')
                    AND tb.programid = i_programid
         ORDER BY   SP.rowno, sp.columnid;

         IF (i_nooftickets > noofavailable_tickets)
         THEN
            result := 105;
         ELSE
            SELECT   TO_CHAR (SYSDATE, 'mmddyyyyhhmiss')
              INTO   out_transId
              FROM   DUAL;

            SELECT   TicketUnitPrice
              INTO   out_unitprice
              FROM   vw_ticketprice@ticketlink
             WHERE   PROGRAMID = i_programid AND CLASSHEIRARCHEY = i_seattype;



            IF (out_transId > 0)
            THEN
               out_transId := out_transId + 1;
               total_price := out_unitprice * i_nooftickets;



               OPEN auth_trx;

               LOOP
                  FETCH auth_trx
                     INTO
                               cin_ticketnumber, cin_ticketseqid, cin_SEATSEQID, cin_boxofficeid, cin_rownum, cin_columnnum, cin_seatnum;

                  EXIT WHEN auth_trx%NOTFOUND;

                  IF (var_temp = 1)
                  THEN
                     INSERT INTO onlinesalemasterlog@ticketlink (
                                                                    onlinetransid,
                                                                    onlinetrasdate,
                                                                    onlineticketqty,
                                                                    onlineamttendered,
                                                                    status,
                                                                    insertedby,
                                                                    inserteddate,
                                                                    programid,
                                                                    showdate,
                                                                    mobileno,
                                                                    customer_name,
                                                                    seat_type
                                )
                       VALUES   (out_transId,
                                 SYSDATE,
                                 i_nooftickets,
                                 total_price,
                                 '0',
                                 i_agentname,
                                 SYSDATE,
                                 i_programid,
                                 TO_DATE (i_showdate, 'dd/mm/yyyy'),
                                 i_mobilenumber,
                                 i_customername,
                                 i_seattype);
                  END IF;

                  IF (var_temp <= i_nooftickets)
                  THEN
                     INSERT INTO ONLINESALEDETAILSLOG@ticketlink (
                                                                     onlinetransid,
                                                                     onlineticketid,
                                                                     onlinecost,
                                                                     status,
                                                                     insertedby,
                                                                     inserteddate
                                )
                       VALUES   (out_transId,
                                 cin_ticketnumber,
                                 out_unitprice,
                                 '0',
                                 i_agentname,
                                 SYSDATE);
                  --  UPDATE ticketbook@ticketlink SET    Status='S' WHERE TICKETNUMBER=cin_ticketnumber AND PROGRAMID=i_programId AND TICKETSEQID=cin_ticketseqid;

                  END IF;

                  var_temp := var_temp + 1;
               END LOOP;

               CLOSE auth_trx;



               result := out_transId;
            ELSE
               result := 101;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END InsertBookingData_Bak;

   PROCEDURE InsertBookingData (i_programid      IN     NUMBER,
                                i_featureid      IN     NUMBER,
                                i_nooftickets    IN     NUMBER,
                                i_totalamount    IN     NUMBER,
                                i_mobilenumber   IN     VARCHAR2,
                                i_seattype       IN     NUMBER,
                                i_showdate       IN     VARCHAR2,
                                i_customername   IN     VARCHAR2,
                                i_agentname      IN     VARCHAR2,
                                result              OUT NUMBER)
   AS
      var_temp                NUMBER;
      out_unitprice           NUMBER;
      total_price             NUMBER;
      noofavailable_tickets   NUMBER;
      newRId                  NUMBER;
      tranID                  NUMBER;
      out_transId             NUMBER;
      cin_ticketnumber        NUMBER;
      cin_ticketseqid         NUMBER;
      cin_SEATSEQID           NUMBER;
      cin_boxofficeid         NUMBER;
      cin_rownum              NUMBER;
      cin_columnnum           NUMBER;
      cin_seatnum             VARCHAR2 (100);
      out_showdate            VARCHAR2 (30);
      -- USED FRO SEQUENTIAL TICKET CHECKING
      i                       NUMBER := 0;
      firstRow                NUMBER (5);
      firstCol                NUMBER (5);
      seatRow                 VARCHAR2 (5);
      seatNo                  NUMBER (5);
      partSql                 VARCHAR2 (100);
      tick_array              DBMS_SQL.varchar2_table;
   /* CURSOR auth_trx IS
    SELECT  tb.ticketnumber,tb.ticketseqid,SP.SEATSEQID ,sp.boxofficeid,sp.rowno,sp.columnid,sp.seatnum
            from ticketbook@ticketlink tb, seatplan@ticketlink sp
            where sp.seatseqid = tb.ticketseqid
            and sp.classheirarchey = i_seattype
            AND sp.IsOnLine='Y' AND tb.Status='B'
            and tb.ticketnumber not in (select ONLINETICKETID from ONLINESALEDETAILSLOG@ticketlink where is_booked='Y')
            and tb.programid= i_programid order by SP.rowno,sp.columnid ;*/


   BEGIN
      --CHECKING FOR SEQUENTIAL TICKET

      FOR j IN 0 .. i_nooftickets - 1
      LOOP
         tick_array (j) := '';
      END LOOP;

      FOR rec1
      IN (  SELECT   SUBSTR (sp.seatnum, 1, 1) SEATSEQ,
                     COUNT (tb.ticketnumber) AS SEATFREE
              FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
             WHERE       sp.seatseqid = tb.ticketseqid
                     AND sp.classheirarchey = i_seattype
                     AND sp.IsOnLine = 'Y'
                     AND tb.Status = 'B'
                     AND tb.ticketnumber NOT IN
                              (SELECT   ONLINETICKETID
                                 FROM   ONLINESALEDETAILSLOG@ticketlink
                                WHERE   is_booked = 'Y')
                     --order by SP.rowno,sp.columnid
                     AND tb.programid = i_programid
          GROUP BY   SUBSTR (sp.seatnum, 1, 1)
          ORDER BY   SUBSTR (sp.seatnum, 1, 1))
      LOOP
         seatRow := rec1.SEATSEQ;
         seatNo := rec1.SEATFREE;

         IF (seatNo < i_nooftickets)
         THEN
            FOR rec
            IN (  SELECT   tb.ticketnumber,
                           tb.ticketseqid,
                           SP.SEATSEQID,
                           sp.boxofficeid,
                           sp.rowno,
                           sp.columnid,
                           sp.seatnum
                    FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
                   WHERE       sp.seatseqid = tb.ticketseqid
                           AND sp.classheirarchey = i_seattype
                           AND sp.IsOnLine = 'Y'
                           AND tb.Status = 'B'
                           AND SUBSTR (sp.seatnum, 0, 1) != seatRow
                           AND tb.ticketnumber NOT IN
                                    (SELECT   ONLINETICKETID
                                       FROM   ONLINESALEDETAILSLOG@ticketlink
                                      WHERE   is_booked = 'Y')
                           AND tb.programid = i_programid
                ORDER BY   SP.rowno, sp.columnid)
            LOOP
               i := i + 1;

               IF (i <= i_nooftickets)
               THEN
                  IF (i = 1)
                  THEN
                     firstRow := rec.rowno;
                     firstCol := rec.columnid;
                  END IF;

                  IF (firstRow <> rec.rowno)
                  THEN
                     result := 106;
                     RETURN;
                  END IF;

                  IF (i = 1)
                  THEN
                     tick_array (0) := rec.ticketnumber;
                  ELSE
                     firstCol := firstCol + 1;

                     IF (firstCol <> rec.columnid)
                     THEN
                        firstCol := rec.columnid;
                        firstRow := rec.rowno;
                        tick_array (0) := rec.ticketnumber;
                        i := 1;
                     ELSE
                        tick_array (i - 1) := rec.ticketnumber;
                     END IF;
                  END IF;
               END IF;
            END LOOP;

            IF (tick_array (i_nooftickets - 1) IS NULL
                OR tick_array (i_nooftickets - 1) = '')
            THEN
               result := 106;
               RETURN;
            ELSE
               EXIT;
            END IF;
         ELSE
         
          FOR rec
            IN (  SELECT   tb.ticketnumber,
                           tb.ticketseqid,
                           SP.SEATSEQID,
                           sp.boxofficeid,
                           sp.rowno,
                           sp.columnid,
                           sp.seatnum
                    FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
                   WHERE       sp.seatseqid = tb.ticketseqid
                           AND sp.classheirarchey = i_seattype
                           AND sp.IsOnLine = 'Y'
                           AND tb.Status = 'B'
                          -- AND SUBSTR (sp.seatnum, 0, 1) != seatRow
                           AND tb.ticketnumber NOT IN
                                    (SELECT   ONLINETICKETID
                                       FROM   ONLINESALEDETAILSLOG@ticketlink
                                      WHERE   is_booked = 'Y')
                           AND tb.programid = i_programid
                ORDER BY   SP.rowno, sp.columnid)
            LOOP
               i := i + 1;

               IF (i <= i_nooftickets)
               THEN
                  IF (i = 1)
                  THEN
                     firstRow := rec.rowno;
                     firstCol := rec.columnid;
                  END IF;

                  IF (firstRow <> rec.rowno)
                  THEN
                     result := 106;
                     RETURN;
                  END IF;

                  IF (i = 1)
                  THEN
                     tick_array (0) := rec.ticketnumber;
                  ELSE
                     firstCol := firstCol + 1;

                     IF (firstCol <> rec.columnid)
                     THEN
                        firstCol := rec.columnid;
                        firstRow := rec.rowno;
                        tick_array (0) := rec.ticketnumber;
                        i := 1;
                     ELSE
                        tick_array (i - 1) := rec.ticketnumber;
                     END IF;
                  END IF;
               END IF;
            END LOOP;

            IF (tick_array (i_nooftickets - 1) IS NULL
                OR tick_array (i_nooftickets - 1) = '')
            THEN
               result := 106;
               RETURN;
            ELSE
               EXIT;
            END IF;
         
         END IF;
      -- EXIT WHEN tick_array(i_nooftickets-1) IS NOT NULL;

      END LOOP rec1;

      --END CHECKING FOR SEQUENTIAL TICKET
      out_transId := 0;
      out_unitprice := 0;
      var_temp := 1;
      result := 101;
      noofavailable_tickets := 0;
      out_showdate := '';

      IF (i_nooftickets > 4)
      THEN
         result := 104;
      ELSE
           SELECT   COUNT (ticketnumber)
             INTO   noofavailable_tickets
             FROM   ticketbook@ticketlink tb, seatplan@ticketlink sp
            WHERE       sp.seatseqid = tb.ticketseqid
                    AND sp.classheirarchey = i_seattype
                    AND sp.IsOnLine = 'Y'
                    AND tb.Status = 'B'
                    AND tb.ticketnumber NOT IN
                             (SELECT   ONLINETICKETID
                                FROM   ONLINESALEDETAILSLOG@ticketlink
                               WHERE   is_booked = 'Y')
                    AND tb.programid = i_programid
         ORDER BY   SP.rowno, sp.columnid;

         IF (i_nooftickets > noofavailable_tickets)
         THEN
            result := 105;
         ELSE
            SELECT   TO_CHAR (SYSDATE, 'mmddyyyyhhmiss')
              INTO   out_transId
              FROM   DUAL;

            SELECT   TicketUnitPrice
              INTO   out_unitprice
              FROM   vw_ticketprice@ticketlink
             WHERE   PROGRAMID = i_programid AND CLASSHEIRARCHEY = i_seattype;

            SELECT   TO_CHAR (showdate, 'dd/mm/yyyy')
              INTO   out_showdate
              FROM   programedfilm@ticketlink
             WHERE   programid = i_programid AND featureid = i_featureid;

            IF (TO_DATE (out_showdate, 'dd/mm/yyyy') <>
                   TO_DATE (i_showdate, 'dd/mm/yyyy'))
            THEN
               result := 101;
               RETURN;
            END IF;



            IF (out_transId > 0)
            THEN
               out_transId := out_transId + 1;
               total_price := out_unitprice * i_nooftickets;



               FOR i IN tick_array.FIRST .. tick_array.LAST
               LOOP
                  IF (tick_array (i) IS NULL OR tick_array (i) = '')
                  THEN
                     result := 106;
                     ROLLBACK;
                     RETURN;
                  END IF;


                  IF (var_temp = 1)
                  THEN
                     INSERT INTO onlinesalemasterlog@ticketlink (
                                                                    onlinetransid,
                                                                    onlinetrasdate,
                                                                    onlineticketqty,
                                                                    onlineamttendered,
                                                                    status,
                                                                    insertedby,
                                                                    inserteddate,
                                                                    programid,
                                                                    showdate,
                                                                    mobileno,
                                                                    customer_name,
                                                                    seat_type
                                )
                       VALUES   (out_transId,
                                 SYSDATE,
                                 i_nooftickets,
                                 total_price,
                                 '0',
                                 i_agentname,
                                 SYSDATE,
                                 i_programid,
                                 TO_DATE (i_showdate, 'dd/mm/yyyy'),
                                 i_mobilenumber,
                                 i_customername,
                                 i_seattype);
                  END IF;

                  IF (var_temp <= i_nooftickets)
                  THEN
                     INSERT INTO ONLINESALEDETAILSLOG@ticketlink (
                                                                     onlinetransid,
                                                                     onlineticketid,
                                                                     onlinecost,
                                                                     status,
                                                                     insertedby,
                                                                     inserteddate
                                )
                       VALUES   (out_transId,
                                 tick_array (i),
                                 out_unitprice,
                                 '0',
                                 i_agentname,
                                 SYSDATE);
                  --  UPDATE ticketbook@ticketlink SET    Status='S' WHERE TICKETNUMBER=cin_ticketnumber AND PROGRAMID=i_programId AND TICKETSEQID=cin_ticketseqid;

                  END IF;

                  var_temp := var_temp + 1;
               END LOOP;

               result := out_transId;
            ELSE
               result := 101;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END InsertBookingData;

   PROCEDURE confirmConcessionTransData (i_trancode        IN     VARCHAR2,
                                         i_concessionamt   IN     VARCHAR2,
                                         result               OUT NUMBER)
   AS
      var_temp            NUMBER;
      out_unitprice       NUMBER;
      newRId              NUMBER;
      tranID              NUMBER;
      out_transId         NUMBER;
      out_temptransId     NUMBER;
      out_maxdate         NUMBER;
      out_today           NUMBER;
      out_transBid        NUMBER;
      cin_onlinetransid   VARCHAR2 (100);
      cin_itemcode        NUMBER;
      cin_quty            NUMBER;
      cin_unitcost        NUMBER;
      cin_totalcost       NUMBER;
      cin_onlinecost      NUMBER;
      cin_refid           VARCHAR2 (100);
      cin_insertedby      VARCHAR2 (100);
      cin_inserteddate    VARCHAR2 (100);
      cin_updatedby       VARCHAR2 (100);
      cin_updateddate     VARCHAR2 (100);
      cin_status          VARCHAR2 (100);
      cin_itemamt         NUMBER;


      CURSOR book_trx
      IS
         SELECT   onlinetransid,
                  ONLINECONCESSIONID,
                  onlinecost,
                  status,
                  insertedby,
                  inserteddate
           FROM   ONLINECONCESSIONDETAILSLOG@ticketlink
          WHERE   onlinetransid = i_trancode AND is_booked = 'Y';
   BEGIN
      out_temptransId := 0;
      out_transBid := 0;
      out_transId := 0;
      out_maxdate := 0;
      out_today := 0;
      cin_itemamt := 0;
      var_temp := 1;
      result := 101;

      --TRANSACTION AMOUNT VERIFICATION

      SELECT   SUM (onlinecost)
        INTO   cin_itemamt
        FROM   ONLINECONCESSIONDETAILSLOG@ticketlink
       WHERE   onlinetransId = i_trancode;



      IF (TO_NUMBER (i_concessionamt) <> cin_itemamt)
      THEN
         UPDATE   ONLINECONCESSIONMASTERLOG@ticketlink
            SET   is_booked = 'N',
                  updatedby = 'system',
                  updateddate = SYSDATE,
                  Remarks = '106:Amount Does Not Matched'
          WHERE   onlinetransid = i_trancode;

         UPDATE   ONLINECONCESSIONDETAILSLOG@ticketlink
            SET   is_booked = 'N',
                  updatedby = 'system',
                  updateddate = SYSDATE
          WHERE   onlinetransid = i_trancode;

         result := 106;
         RETURN;
      END IF;


      SELECT   COUNT (onlinetransId)
        INTO   out_temptransId
        FROM   ONLINECONCESSIONMASTERLOG@ticketlink
       WHERE   onlinetransId = i_trancode;



      IF (out_temptransId > 0)
      THEN
         -- ONLINE SALE BOOKED TICKET RELEASED OR NOT
         SELECT   COUNT (onlinetransId)
           INTO   out_transBid
           FROM   ONLINECONCESSIONMASTERLOG@ticketlink
          WHERE   onlinetransId = i_trancode AND is_booked = 'Y';


         IF (out_transBid > 0)
         THEN
            SELECT   MAX (onlinetransId)
              INTO   out_transId
              FROM   ONLINESALEVOUCHERMASTER@ticketlink;

            SELECT   SUBSTR (out_transId, -12, 7) INTO out_maxdate FROM DUAL;

            SELECT   SUBSTR (
                        (SELECT   (SELECT   REGEXP_REPLACE (
                                               (SELECT   TO_CHAR (SYSDATE,
                                                                  'yyyymmdd')
                                                  FROM   DUAL),
                                               '(^.{1})(.{1})(.*)$',
                                               '\1\3'
                                            )
                                     FROM   DUAL)
                           FROM   DUAL),
                        -7,
                        7
                     )
              INTO   out_today
              FROM   DUAL;



            IF (out_maxdate <> out_today)
            THEN
               SELECT   CONCAT (
                           (SELECT   REGEXP_REPLACE (
                                        (SELECT   TO_CHAR (SYSDATE,
                                                           'yyyymmdd')
                                           FROM   DUAL),
                                        '(^.{1})(.{1})(.*)$',
                                        '\1\3'
                                     )
                              FROM   DUAL),
                           '00001'
                        )
                 INTO   out_transId
                 FROM   DUAL;
            ELSE
               out_transId := out_transId + 1;
            END IF;



            IF (LENGTH (out_transId) > 0)
            THEN
               INSERT INTO ONLINESALEVOUCHERMASTER@ticketlink (ONLINETRANSID,
                                                               ONLINETRANSDATE,
                                                               TOTALCOST,
                                                               TOTALITEM,
                                                               AMTTENDERED,
                                                               ONLINESALETYPE,
                                                               STATUS,
                                                               MOBILENO,
                                                               INSERTEDBY,
                                                               INSERTEDDATE)
                  SELECT   out_transId,
                           b.ONLINETRASDATE,
                           b.ONLINEAMTTENDERED,
                           b.ONLINECONCESSIONQTY,
                           b.ONLINEAMTTENDERED,
                           'C',
                           b.status,
                           b.mobileno,
                           b.insertedby,
                           b.inserteddate
                    FROM   ONLINECONCESSIONMASTERLOG@ticketlink b
                   WHERE   b.onlinetransid = i_trancode AND b.is_booked = 'Y';

               UPDATE   ONLINECONCESSIONMASTERLOG@ticketlink
                  SET   is_booked = 'S', TRASACTION_ID = out_transId
                WHERE   onlinetransid = i_trancode;

               SELECT   COUNT (onlinecost)
                 INTO   cin_quty
                 FROM   ONLINECONCESSIONDETAILSLOG@ticketlink
                WHERE   onlinetransId = i_trancode;

               SELECT   DISTINCT (ONLINECOST)
                 INTO   cin_unitcost
                 FROM   ONLINECONCESSIONDETAILSLOG@ticketlink
                WHERE   onlinetransId = i_trancode;

               OPEN book_trx;

               LOOP
                  FETCH book_trx
                     INTO
                               cin_onlinetransid, cin_itemcode, cin_onlinecost, cin_status, cin_insertedby, cin_inserteddate;

                  EXIT WHEN book_trx%NOTFOUND;



                  INSERT INTO ONLINESALEVOUCHERDETAILS@ticketlink (
                                                                      onlinetransid,
                                                                      ITEMCODE,
                                                                      QNTY,
                                                                      UNITCOST,
                                                                      TOTALCOST,
                                                                      insertedby,
                                                                      inserteddate,
                                                                      UPDATEDBY,
                                                                      UPDATEDDATE,
                                                                      REFERENCEID
                             )
                    VALUES   (out_transId,
                              cin_itemcode,
                              cin_quty,
                              cin_unitcost,
                              cin_itemamt,
                              cin_insertedby,
                              cin_inserteddate,
                              cin_updatedby,
                              cin_updateddate,
                              cin_refid);

                  UPDATE   ONLINECONCESSIONDETAILSLOG@ticketlink
                     SET   is_booked = 'S'
                   WHERE   onlinetransid = i_trancode
                           AND ONLINECONCESSIONID = cin_itemcode;
               END LOOP;

               CLOSE book_trx;



               result := out_transId;
               COMMIT;
            ELSE
               result := 101;
            END IF;
         ELSE
            result := 105;
         END IF;
      ELSE
         result := 104;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         -- RAISE;
         ROLLBACK;
   END confirmConcessionTransData;

   PROCEDURE confirmTransactionData (i_trancode   IN     VARCHAR2,
                                     i_tickamt    IN     VARCHAR2,
                                     result          OUT NUMBER)
   AS
      var_temp              NUMBER;
      out_unitprice         NUMBER;
      tranID                NUMBER;
      out_transId           NUMBER;
      out_temptransId       NUMBER;
      out_transBid          NUMBER;
      out_ticketavailable   NUMBER;
      cin_onlinetransid     VARCHAR2 (100);
      cin_onlineticketid    VARCHAR2 (100);
      cin_onlinecost        VARCHAR2 (100);
      cin_status            VARCHAR2 (100);
      cin_insertedby        VARCHAR2 (100);
      cin_inserteddate      VARCHAR2 (100);
      cin_seatnum           VARCHAR2 (100);

      cin_tickamt           NUMBER;


      CURSOR book_trx
      IS
         SELECT   onlinetransid,
                  onlineticketid,
                  onlinecost,
                  status,
                  insertedby,
                  inserteddate
           FROM   ONLINESALEDETAILSLOG@ticketlink
          WHERE   onlinetransid = i_trancode AND is_booked = 'Y';
   BEGIN
      out_temptransId := 0;
      out_transBid := 0;
      out_transId := 0;
      out_ticketavailable := 0;
      cin_tickamt := 0;
      var_temp := 1;
      result := 101;

      --TRANSACTION AMOUNT VERIFICATION

      SELECT   SUM (onlinecost)
        INTO   cin_tickamt
        FROM   onlinesaledetailslog@ticketlink
       WHERE   onlinetransId = i_trancode;

      IF (TO_NUMBER (i_tickamt) <> cin_tickamt)
      THEN
         UPDATE   onlinesalemasterlog@ticketlink
            SET   is_booked = 'N',
                  updatedby = 'system',
                  updateddate = SYSDATE,
                  Remarks = '106:Amount Does Not Matched'
          WHERE   onlinetransid = i_trancode;

         UPDATE   onlinesaledetailslog@ticketlink
            SET   is_booked = 'N',
                  updatedby = 'system',
                  updateddate = SYSDATE
          WHERE   onlinetransid = i_trancode;

         result := 106;
         RETURN;
      END IF;


      SELECT   COUNT (onlinetransId)
        INTO   out_temptransId
        FROM   onlinesalemasterlog@ticketlink
       WHERE   onlinetransId = i_trancode;

      IF (out_temptransId > 0)
      THEN
         -- ONLINE SALE BOOKED TICKET RELEASED OR NOT
         SELECT   COUNT (onlinetransId)
           INTO   out_transBid
           FROM   onlinesalemasterlog@ticketlink
          WHERE   onlinetransId = i_trancode AND is_booked = 'Y';

         --TICKETBOOK TABLE TICKET RELEASED OR NOT FROM AGENT DUE TO 3O MIN BUFFER OR ANY OTHER CASE
         SELECT   COUNT (a.ticketnumber)
           INTO   out_ticketavailable
           FROM   ticketbook@ticketlink a, onlinesaledetailslog@ticketlink b
          WHERE       a.ticketnumber = b.onlineticketid
                  AND b.onlinetransId = i_trancode
                  AND b.is_booked = 'Y'
                  AND a.status = 'B';

         IF ( (out_transBid > 0) AND (out_ticketavailable > 0))
         THEN
            SELECT   MAX (onlinetransId)
              INTO   out_transId
              FROM   onlinesalemaster@ticketlink;

            IF (out_transId > 0)
            THEN
               out_transId := out_transId + 1;

               INSERT INTO onlinesalemaster@ticketlink (onlinetransid,
                                                        onlinetrasdate,
                                                        onlineticketqty,
                                                        onlineamttendered,
                                                        status,
                                                        insertedby,
                                                        inserteddate,
                                                        programid,
                                                        showdate,
                                                        mobileno)
                  SELECT   out_transId,
                           b.onlinetrasdate,
                           b.onlineticketqty,
                           b.onlineamttendered,
                           b.status,
                           b.insertedby,
                           b.inserteddate,
                           b.programid,
                           b.showdate,
                           b.mobileno
                    FROM   onlinesalemasterlog@ticketlink b
                   WHERE   b.onlinetransid = i_trancode AND is_booked = 'Y';

               UPDATE   onlinesalemasterlog@ticketlink
                  SET   is_booked = 'S', TRASACTION_ID = out_transId
                WHERE   onlinetransid = i_trancode;

               OPEN book_trx;

               LOOP
                  FETCH book_trx
                     INTO
                               cin_onlinetransid, cin_onlineticketid, cin_onlinecost, cin_status, cin_insertedby, cin_inserteddate;

                  EXIT WHEN book_trx%NOTFOUND;



                  INSERT INTO ONLINESALEDETAILS@ticketlink (onlinetransid,
                                                            onlineticketid,
                                                            onlinecost,
                                                            status,
                                                            insertedby,
                                                            inserteddate)
                    VALUES   (out_transId,
                              cin_onlineticketid,
                              cin_onlinecost,
                              cin_status,
                              cin_insertedby,
                              cin_inserteddate);

                  UPDATE   ticketbook@ticketlink
                     SET   Status = 'S'
                   WHERE   TICKETNUMBER = cin_onlineticketid;

                  UPDATE   ONLINESALEDETAILSLOG@ticketlink
                     SET   is_booked = 'S'
                   WHERE   onlinetransid = i_trancode
                           AND onlineticketid = cin_onlineticketid;
               END LOOP;

               CLOSE book_trx;



               result := out_transId;
            ELSE
               result := 101;
            END IF;
         ELSE
            result := 105;
         END IF;
      ELSE
         result := 104;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END confirmTransactionData;



   PROCEDURE cancelTransaction (i_programid     IN     NUMBER,
                                i_nooftickets   IN     NUMBER,
                                i_totalamount   IN     NUMBER,
                                i_bookingid     IN     NUMBER,
                                i_agentname     IN     VARCHAR2,
                                result             OUT NUMBER)
   AS
      var_temp             NUMBER;
      out_unitprice        NUMBER;
      newRId               NUMBER;
      tranID               NUMBER;
      out_transId          NUMBER;
      out_temptransId      NUMBER;
      out_transBid         NUMBER;
      cin_onlinetransid    VARCHAR2 (100);
      cin_onlineticketid   VARCHAR2 (100);
      cin_onlinecost       NUMBER;
      cin_status           VARCHAR2 (100);
      cin_insertedby       VARCHAR2 (100);
      cin_inserteddate     VARCHAR2 (100);
      cin_seatnum          VARCHAR2 (100);
      cin_onlineqty        NUMBER;
      cin_progid           NUMBER;
      cshowid              NUMBER;
      cshowdate            VARCHAR2 (100);
      cfitureid            NUMBER;
      cshowtime            VARCHAR2 (100);
      cdiffer              NUMBER;



      /*  CURSOR sold_book_trx IS
        SELECT  onlinetransid,onlineticketid,onlinecost,status,insertedby,inserteddate
                from ONLINESALEDETAILSLOG@ticketlink
                where onlinetransid = i_bookingid
                and is_booked='S';*/

      CURSOR sold_trx
      IS
         SELECT   onlinetransid,
                  onlineticketid,
                  onlinecost,
                  status,
                  insertedby,
                  inserteddate
           FROM   ONLINESALEDETAILS@ticketlink
          WHERE   onlinetransid = out_transId AND status = 0;
   BEGIN
      out_temptransId := 0;
      out_transBid := 0;
      out_transId := 0;
      cin_onlinecost := 0;
      cin_onlineqty := 0;
      cin_insertedby := '';
      cin_progid := 0;
      cdiffer := 0;
      var_temp := 1;
      result := 101;
      cin_onlineticketid := 0;


      SELECT   COUNT (onlinetransId)
        INTO   out_temptransId
        FROM   onlinesalemasterlog@ticketlink
       WHERE       onlinetransId = i_bookingid
               AND is_booked = 'S'
               AND PROGRAMID = i_programid;

      IF (out_temptransId > 0)
      THEN
         SELECT   ONLINEAMTTENDERED,
                  ONLINETICKETQTY,
                  INSERTEDBY,
                  PROGRAMID,
                  TRASACTION_ID
           INTO   cin_onlinecost,
                  cin_onlineqty,
                  cin_insertedby,
                  cin_progid,
                  out_transId
           FROM   onlinesalemasterlog@ticketlink
          WHERE   onlinetransId = i_bookingid AND is_booked = 'S';

         IF (TRIM (i_agentname) = TRIM (cin_insertedby))
         THEN
            SELECT   p.SHOWTIMEID,
                     TO_CHAR (p.SHOWDATE, 'dd-mm-yyyy') AS showdate,
                     P.FEATUREID,
                     TO_CHAR (S.SHOWTIME, 'hh24:mi:ss') AS showtime,
                     24
                     * (TO_DATE (
                           (   TO_CHAR (p.SHOWDATE, 'MM/DD/YYYY')
                            || ' '
                            || TO_CHAR (S.SHOWTIME, 'hh24:mi:ss')),
                           'MM/DD/YYYY hh24:mi:ss'
                        )
                        - TO_DATE (
                             TO_CHAR (SYSDATE, 'MM/DD/YYYY hh24:mi:ss'),
                             'MM/DD/YYYY hh24:mi:ss'
                          ))
                        AS diff_hours
              INTO   cshowid,
                     cshowdate,
                     cfitureid,
                     cshowtime,
                     cdiffer
              FROM   programedfilm@ticketlink p, showtime@ticketlink s
             WHERE       P.SHOWTIMEID = S.SHOWTIMEID
                     AND P.BOXOFFICEID = S.BOXOFFICEID
                     AND P.PROGRAMID = cin_progid
                     AND P.ISPROSPONED = 'N'
                     AND P.ISONLINE = 'Y'
                     AND P.STATUS = 'N';

            IF (cdiffer >= 4)
            THEN
               UPDATE   onlinesalemaster@ticketlink
                  SET   status = 2,
                        UPDATEDBY = i_agentname,
                        UPDATEDDATE = SYSDATE
                WHERE   ONLINETRANSID = out_transId AND status = 0;

               OPEN sold_trx;

               LOOP
                  FETCH sold_trx
                     INTO
                               cin_onlinetransid, cin_onlineticketid, cin_onlinecost, cin_status, cin_insertedby, cin_inserteddate;

                  EXIT WHEN sold_trx%NOTFOUND;

                  UPDATE   ONLINESALEDETAILS@ticketlink
                     SET   status = 2,
                           UPDATEDBY = i_agentname,
                           UPDATEDDATE = SYSDATE
                   WHERE       ONLINETRANSID = out_transId
                           AND status = 0
                           AND ONLINETICKETID = cin_onlineticketid;

                  UPDATE   ticketbook@ticketlink
                     SET   Status = 'B'
                   WHERE   TICKETNUMBER = cin_onlineticketid;
               --update ONLINESALEDETAILSLOG@ticketlink set is_booked='N' WHERE onlinetransid = i_trancode and onlineticketid=cin_onlineticketid;



               END LOOP;

               CLOSE sold_trx;

               --BELOW COMMAND COMMENTED DUE TO ERROR OF CANCELEDBY AND CANCELEDDATE. BY AMIT
               --update onlinesalemasterlog@ticketlink set is_booked = 'C',status =2,CANCELEDBY=i_agentname,CANCELEDDATE=SYSDATE where ONLINETRANSID = i_bookingid and  is_booked='S' ;
               UPDATE   onlinesalemasterlog@ticketlink
                  SET   is_booked = 'C', status = 2
                WHERE   ONLINETRANSID = i_bookingid AND is_booked = 'S';

               UPDATE   ONLINESALEDETAILSLOG@ticketlink
                  SET   is_booked = 'C'
                WHERE   onlinetransid = i_bookingid AND is_booked = 'S';

               result := 100;                             -- successful cancel
            ELSE
               result := 109;                      -- not available for cancel
            END IF;
         ELSE
            result := 105;                         --invalid marchange request
         END IF;
      ELSE
         result := 104;                                       --invalid tranID
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         result := 101;
         -- Consider logging the error and then re-raise
         --  RAISE;
         ROLLBACK;
   END cancelTransaction;
END PKG_TICKE_PURCHAGE;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "ADDONLINESALESMASTER" (i_onlinetransid IN NUMBER,i_onlinetrasdate IN VARCHAR,i_onlineticketqty IN NUMBER,i_onlineamttendered IN NUMBER,i_insertedby IN VARCHAR,i_showdate IN VARCHAR,i_programid IN NUMBER,i_mobileno IN VARCHAR, row OUT NUMBER)
AS
BEGIN  
  insert into onlinesalemaster@ticketlink(onlinetransid,onlinetrasdate,onlineticketqty,onlineamttendered,status,insertedby,inserteddate,programid,showdate,mobileno)
                    values(i_onlinetransid,to_date(i_onlinetrasdate, 'yyyy-mm-dd'),i_onlineticketqty,i_onlineamttendered,'0',i_insertedby,to_date(i_onlinetrasdate, 'yyyy-mm-dd'),i_programid,to_date(i_showdate, 'yyyy-mm-dd'),i_mobileno);
   IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
        row:=1;
      END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE "ADDONLINETICKETTRANSACTION" (
i_ticketNumber IN VARCHAR,
i_programId IN VARCHAR,
i_status IN VARCHAR,
i_ticketSeqId IN VARCHAR,
i_saleDate IN VARCHAR,
i_autoCardNum IN VARCHAR,
i_insertedBy IN VARCHAR,
i_insertedDate IN VARCHAR,
i_ticketUnitPrice IN NUMBER,
i_onlinetransid IN NUMBER,
row OUT NUMBER)
AS
BEGIN  
 --insert into ticketbook(TICKETNUMBER,PROGRAMID,STATUS,TICKETSEQID,INSERTEDBY,INSERTEDDATE,UPDATEDBY,UPDATEDDATE) values   (i_ticketNumber,i_programId,i_status,i_ticketSeqId,i_insertedBy,i_insertedDate,i_insertedBy,i_insertedDate);

  insert into TICKETSALEBYSCARD@ticketlink(CARDNUM,SALEDATE,TICKQTY,TICKETNUMBER,TICKPRICE,CARDPRICE,INSERTEDBY,INSERTEDDATE,UPDATEDBY,UPDATEDDATE)
     values(i_autoCardNum,to_date(i_saleDate, 'yyyy-mm-dd'),1,i_ticketNumber,i_ticketUnitPrice,i_ticketUnitPrice,i_insertedBy,to_date(i_insertedDate, 'yyyy-mm-dd'),i_insertedBy,to_date(i_insertedDate, 'yyyy-mm-dd'));

  insert into ONLINESALEDETAILS@ticketlink(onlinetransid,onlineticketid,onlinecost,status,insertedby,inserteddate) 
            values(i_onlinetransid,i_ticketNumber,i_ticketUnitPrice,'0',i_insertedBy,to_date(i_insertedDate, 'yyyy-mm-dd'));

  UPDATE ticketbook@ticketlink SET    Status='S' WHERE TICKETNUMBER=i_ticketNumber AND PROGRAMID=i_programId AND TICKETSEQID=i_ticketSeqId;    
               
   IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
        row:=1;
      END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            ADDSCARDPROFILE(i_actcardno IN VARCHAR2,i_firstname IN VARCHAR2,i_middlename IN VARCHAR2,i_lastname IN VARCHAR2,i_email IN VARCHAR2,i_birthdate IN VARCHAR,i_gender IN VARCHAR2,i_insertdate IN VARCHAR,i_mobileno IN CHAR,i_status IN CHAR, row OUT NUMBER)
AS
BEGIN  
  insert into scardprofile@ticketlink(actcardno,firstname,middlename,lastname,email,birthdate,gender,inserteddate,mobileno,status)
                    values(i_actcardno,i_firstname,i_middlename,i_lastname,i_email,to_date(i_birthdate, 'yyyy-mm-dd'),i_gender,to_date(i_insertdate, 'yyyy-mm-dd'),i_mobileno,i_status);
   IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
        row:=1;
      END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "CHANGEPASSWORDBYCARDNO" (thisCardNo IN VARCHAR, pass IN VARCHAR,thisUpdatedDate IN DATE,row OUT NUMBER) 
  IS
   BEGIN
      UPDATE scardbox@ticketlink SET CardPass=pass,ispasschanged='Y',updatedby=thisCardNo,updateddate=thisUpdatedDate WHERE actcardno=thisCardNo;
    
      IF SQL%NOTFOUND THEN
         row:=0;
         
      ELSE
    row:=1;
      END IF;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "CHECKSEATBYCTYPEANDPROGRAMID" (i_cardType IN INT, i_programId IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT  *
            from ticketbook@ticketlink tb, seatplan@ticketlink sp
            where sp.seatseqid = tb.ticketseqid
            and sp.classheirarchey = i_cardType
            AND sp.IsOnLine='Y' AND tb.Status='B'
            and tb.ticketnumber not in (select ONLINETICKETID from ONLINESALEDETAILSLOG@ticketlink where is_booked='Y')
            and tb.programid= i_programId order by SP.SEATSEQID;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "CHECKTICKBOOKBYPRGID" (i_programId IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT * from ticketbook@ticketlink where Status='S' AND programid= i_programId;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "CHECKUSERSBYCARDNO" (CARDNO IN CHAR,outCARDNUM OUT VARCHAR,outPASSWORD OUT VARCHAR,outSCARDSTATUS OUT VARCHAR,outISBLOCKED OUT VARCHAR,outISONLINE OUT VARCHAR,outSALT OUT VARCHAR,outISPASSCHANGED OUT VARCHAR)
AS
BEGIN
--SELECT CARDNUM,CARDPASS,SCARDSTATUS,ISBLOCKED,ISONLINE,SALT,ISPASSCHANGED INTO outCARDNUM,outPASSWORD,outSCARDSTATUS,outISBLOCKED,outISONLINE,outSALT,outISPASSCHANGED from SCARDBOX@ticketlink where actcardno=CARDNO and DURFROM <= SYSDATE and DURTO>= SYSDATE  and ISONLINE = 'Y';
SELECT ACTCARDNO,CARDPASS,SCARDSTATUS,ISBLOCKED,ISONLINE,SALT,ISPASSCHANGED INTO outCARDNUM,outPASSWORD,outSCARDSTATUS,outISBLOCKED,outISONLINE,outSALT,outISPASSCHANGED from SCARDBOX@ticketlink where CARDNUM=CARDNO and DURFROM <= SYSDATE and DURTO>= SYSDATE  and ISONLINE = 'Y';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outISONLINE:=null;
 END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            COUNTPURCHAGEDTICKET(
       c_cardno IN varchar,
       i_date IN varchar,
       c_QTY OUT varchar)
IS
BEGIN
 
  SELECT count(TICKQTY) as QTY 
  INTO c_QTY 
  FROM  TICKETSALEBYSCARD@ticketlink 
  WHERE trim(CARDNUM) = trim(c_cardno)
  AND showdate = to_date(i_date, 'yyyy-mm-dd');
 
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            COUNTTICKETALL(
       c_cardno IN varchar,
       i_date IN varchar,
       c_QTY OUT varchar)
IS
BEGIN
 
  SELECT SUM(ONLINETICKETQTY) as QTY 
  INTO c_QTY 
  FROM  ONLINESALEMASTER@ticketlink 
  WHERE trim(INSERTEDBY) = trim(c_cardno)
  AND SHOWDATE = to_date(i_date, 'yyyy-mm-dd');
 
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETALLSHOWTIMELISTBYMOVIE" (i_movieId IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  
    OPEN p_cursor FOR SELECT prg.showdate as showdate, to_char(st.showtime,'hh24:mi') as showtime,
                                st.showtimeid as showtimeid, prg.programid as programid, prg.boxofficeid as boxofficeid
                                from programedfilm@ticketlink prg,showtime@ticketlink st
                                where prg.showtimeid = st.showtimeid
                                and prg.boxofficeid = st.boxofficeid
                                and prg.featureid = i_movieId
                                and prg.IsOnline='Y' AND prg.Status='N'
                                --and prg.showdate=to_date(i_date, 'yyyy-mm-dd');
                                --and prg.showdate >= to_date(sysdate) and prg.showdate <= to_date(sysdate + 7) ;
                                and prg.showdate >= to_date(sysdate) and prg.showdate < to_date(sysdate+7) order by showdate,showtime asc; 
    
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETAVAILABLEMOVIES" (i_optionValue IN INT, i_date IN VARCHAR,i_isToday IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
  IF (i_isToday=1) THEN 
     BEGIN
      OPEN p_cursor FOR select distinct(f.featureid) as id , f.longtitle as name 
                from programedfilm@ticketlink pf,features@ticketlink f,showtime@ticketlink st
                where pf.featureid = f.featureid
                and pf.showtimeid = st.showtimeid
                and pf.status = 'N'
                and pf.isprosponed='N'
                and pf.IsOnline='Y'
                and pf.showdate = to_date(i_date, 'yyyy-mm-dd')
                and to_char(st.showtime,'hh24:mi:ss') >= to_char((SYSDATE + i_optionValue/1440), 'hh24:mi:ss');  
     END; 
  ELSE
      BEGIN  
          OPEN p_cursor FOR select distinct(f.featureid) as id, f.longtitle as name 
                    from programedfilm@ticketlink pf,features@ticketlink f,showtime@ticketlink st
                    where pf.featureid = f.featureid
                    and pf.showtimeid = st.showtimeid
                    and pf.status = 'N'
                    and pf.isprosponed='N'
                    and pf.IsOnline='Y'
                    and pf.showdate = to_date(i_date, 'yyyy-mm-dd');   
      END;
  END IF;
       
   
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETAVAILABLEMOVIESHOWTIME" (i_movieId IN INT,i_showdate IN VARCHAR, i_showtimeId IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT prg.programid as programid, prg.boxofficeid as boxofficeid,to_char(st.showtime,'hh24:miAM') as showtime
            from features@ticketlink ftr, programedfilm@ticketlink prg, showtime@ticketlink st
            where ftr.featureid = prg.featureid
            and prg.showtimeid = st.showtimeid
            and prg.showdate = to_date(i_showdate, 'yyyy-mm-dd')
            and st.showtimeid = i_showtimeId
            and ftr.featureid = i_movieId;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETAVAILABLEMOVIESONLINE" (i_optionValue IN INT, fromdate IN VARCHAR,todate IN VARCHAR,i_isToday IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
  IF (i_isToday=1) THEN 
     BEGIN
      OPEN p_cursor FOR select distinct(f.featureid) as id ,f.TRAILERURL as trailerurl, f.longtitle as longname,f.shorttitle as shortname, f.flength, f.synopsis
                from programedfilm@ticketlink pf,features@ticketlink f,showtime@ticketlink st
                where pf.featureid = f.featureid
                and pf.showtimeid = st.showtimeid
                and pf.status = 'N'
                and pf.isprosponed='N'
                and pf.showdate = to_date(fromdate, 'yyyy-mm-dd')
                and to_char(st.showtime,'hh24:mi:ss') >= to_char((SYSDATE + i_optionValue/1440), 'hh24:mi:ss');  
     END; 
  ELSE
      BEGIN  
          OPEN p_cursor FOR select distinct(f.featureid) as id,f.TRAILERURL as trailerurl, f.longtitle as longname,f.shorttitle as shortname, f.flength as flength , f.synopsis as synopsis  
                    from programedfilm@ticketlink pf,features@ticketlink f,showtime@ticketlink st
                    where pf.featureid = f.featureid
                    and pf.showtimeid = st.showtimeid
                    and pf.status = 'N'
                    and pf.isprosponed='N'
                    and pf.showdate between to_date(fromdate, 'yyyy-mm-dd') and to_date(todate, 'yyyy-mm-dd');   
      END;
  END IF;
       
   
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETBLOCKTIME" (i_optionId IN VARCHAR, o_optValue OUT VARCHAR)
    AS
    BEGIN
       select optvalue INTO o_optValue from optionbag@ticketlink 
       where optid= i_optionId;       
    END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETBOXOFFICEIDBYPROGRAMID" (i_programId IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT boxofficeid from programedfilm@ticketlink where programid = i_programId;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETBOXOFFICENAME" (BOXOFFICEID IN VARCHAR,outSCREENNAME OUT VARCHAR)
AS
BEGIN
SELECT SCREENNAME INTO outSCREENNAME from BOXOFFICE@ticketlink where SCREENID=BOXOFFICEID;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outSCREENNAME:=null;
    
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETCARDBYMOBILE" (mobile IN varchar,outCard OUT CHAR)
AS
BEGIN
SELECT cardnum INTO outCard from SCARDBOX@ticketlink where mobileno=mobile and isonline='Y' and isblocked = 'N';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outCard:=null;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETCARDDETAILSBYCARDNO" (i_cardNo IN VARCHAR, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT actcardno,ticketunitprice,atatimeallowed,perdayallowd,cardtype,CardNum
                from vw_ticketprice@ticketlink
                where actcardno = i_cardNo;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETCARDPERMISSIONINFO" (i_cardno IN varchar, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT ATATIMEALLOWED,PERDAYALLOWD
                from vw_card@ticketlink
                where ACTCARDNO = i_cardno;      
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            getCardUserByCardNo(
       c_cardno IN CHAR,
       c_cardbalance OUT NUMBER)
       
IS
BEGIN
 
  SELECT CARDBALANCE 
  INTO c_cardbalance
  FROM  SCARDBOX@ticketlink WHERE ACTCARDNO = c_cardno;
 
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETETICKETMSG" (in_MSGID IN NUMBER,thisMsgText OUT VARCHAR)
AS
BEGIN
SELECT MSGTEXT INTO thisMsgText from ETICKET_MSG@ticketlink 
where MSGID=in_MSGID;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  thisMsgText:=null;        
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETFEATUREIMAGE" (in_FEATUREID IN NUMBER,thisFEATUREIMAGE OUT BLOB)
AS
BEGIN
INSERT INTO FEATURESTMP SELECT FEATUREID,FEATUREIMAGE FROM FEATURES@ticketlink WHERE FEATUREID=in_FEATUREID;
COMMIT;
SELECT FEATUREIMAGE INTO thisFEATUREIMAGE from FEATURESTMP 
where FEATUREID=in_FEATUREID;

DELETE from FEATURESTMP;
COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  thisFEATUREIMAGE:=null;        
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETLASTTRANIDFROMMASTERDETAILS" (initialValueForTranId IN VARCHAR,onlinetransId OUT NUMBER) 
  AS
   BEGIN
      select MAX(onlinetransId) into onlinetransId from onlinesalemaster@ticketlink where ONLINETRANSID like upper(initialValueForTranId)||'%';
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETMAXTRANIDFROMMASTER" (in_lower IN NUMBER,in_upper IN NUMBER,out_transId OUT NUMBER) 
  AS
   BEGIN
      select MAX(onlinetransId) into out_transId from onlinesalemaster@ticketlink where ONLINETRANSID BETWEEN in_lower AND in_upper ;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETMOVIEINFO" (movieID IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
       OPEN p_cursor FOR select distinct(f.featureid) as id , f.trailerurl, f.longtitle as longname,f.shorttitle as shortname, f.flength, f.synopsis
                from programedfilm@ticketlink pf,features@ticketlink f
                where pf.featureid=f.featureid and pf.featureid = movieID
                and pf.status = 'N'
                and pf.isprosponed='N';
                
        
     END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETMOVIESBYDATE" (i_optionValue IN VARCHAR2,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
   
          OPEN p_cursor FOR select distinct(f.featureid) as id,to_char(st.showtime,'hh24:mi:ss') as showtime , f.TRAILERURL as trailerurl, pf.showdate as showdate, f.longtitle as longname,f.shorttitle as shortname, f.flength as flength , f.synopsis as synopsis  
                    from programedfilm@ticketlink pf,features@ticketlink f,showtime@ticketlink st
                    where pf.featureid = f.featureid
                    and pf.showtimeid = st.showtimeid
                    and pf.boxofficeid = st.boxofficeid
                    and pf.status = 'N' and pf.IsOnline='Y'
                    and pf.isprosponed='N'
                     and pf.showdate >= to_date(sysdate) and pf.showdate <= to_date(sysdate+7);   
            
   
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETMOVIEUNITPRICE" (i_boxofficeid IN INT,i_programid IN INT,i_classheirarchey IN INT,i_featureid IN INT,i_showimeid IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT TicketUnitPrice
                from vw_ticketprice@ticketlink
                where BOXOFFICEID = i_boxofficeid
                AND PROGRAMID = i_programid  
                AND CLASSHEIRARCHEY = i_classheirarchey 
                AND FEATUREID = i_featureid 
                AND SHOWTIMEID = i_showimeid;      
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETONLINEMOVIESHOWTIME" (i_movieId IN INT,fromdate IN VARCHAR,todate IN VARCHAR, i_optionValue IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT prg.showdate as showdate, to_char(st.showtime,'hh24:miAM') as showtime,
                                st.showtimeid as showtimeid, prg.programid as programid, prg.boxofficeid as boxofficeid
                                from programedfilm@ticketlink prg,showtime@ticketlink st
                                where prg.showtimeid = st.showtimeid
                                and prg.boxofficeid = st.boxofficeid
                                and prg.featureid = i_movieId
                                and prg.IsOnline='Y' AND prg.Status='N'
            and prg.showdate  between to_date(fromdate, 'yyyy-mm-dd') and to_date(todate, 'yyyy-mm-dd');
            
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETONLINESEATS" (i_cardType IN INT, i_boxofficeId IN VARCHAR, i_programId IN INT,isLinkedPrg IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_cursor FOR SELECT count(sp.seatseqid) qty
            from seatplan@ticketlink sp, programedFilm@ticketlink pf,TicketBook@ticketlink tb
            where sp.boxofficeid = pf.boxofficeid
            AND pf.ProgramId=tb.ProgramId AND sp.SeatSeqId=tb.TicketSeqId
            and sp.isonline='Y' AND pf.IsOnline='Y' AND tb.Status='B'
            and tb.ticketnumber not in (select ONLINETICKETID from ONLINESALEDETAILSLOG@ticketlink where is_booked='Y')
            and sp.classheirarchey= i_cardType
            and pf.programId = i_programId;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETPROFILECARDBYEMAIL" (EMAILID IN VARCHAR2,outCARD OUT VARCHAR2)
AS
BEGIN
SELECT actcardno INTO outCARD from SCARDPROFILE@ticketlink where EMAIL=EMAILID and STATUS='Y';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outCARD:=null;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETPROFILEEMAILBYCARDNO" (CARDNO IN VARCHAR,outEMAIL OUT VARCHAR)
AS
BEGIN
SELECT EMAIL INTO outEMAIL from SCARDPROFILE@ticketlink where actcardno=CARDNO and STATUS='Y';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outEMAIL:=null;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSCARDBOXBYCARDNO" (i_cardNo IN VARCHAR,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  OPEN p_cursor FOR SELECT cardbalance,tikbalance,isblocked,scardstatus 
  from scardbox@ticketlink 
  where actcardno=i_cardNo and scardStatus='S' and isblocked='N';
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSCARDBOXMOBILENO" (cardNo IN CHAR,outMobile OUT VARCHAR2)
AS
BEGIN
SELECT mobileno INTO outMobile from SCARDBOX@ticketlink where cardnum=cardNo and isonline='Y' and isblocked = 'N';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outMobile:=null;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSCARDPROFILE" (CARDNO IN VARCHAR,outFIRSTNAME OUT VARCHAR,outMIDDLENAME OUT VARCHAR,outLASTNAME OUT VARCHAR,outEMAIL OUT VARCHAR,outGENDER OUT VARCHAR,outBIRTHDATE OUT VARCHAR,outMOBILENO OUT VARCHAR,outSTATUS OUT CHAR)
AS
BEGIN
SELECT FIRSTNAME,MIDDLENAME,LASTNAME,EMAIL,GENDER,BIRTHDATE,MOBILENO,STATUS INTO outFIRSTNAME,outMIDDLENAME,outLASTNAME,outEMAIL,outGENDER,outBIRTHDATE,outMOBILENO,outSTATUS from SCARDPROFILE@ticketlink where actcardno=CARDNO  and STATUS='Y';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  outFIRSTNAME:=null;
  outMIDDLENAME:=null;
  outLASTNAME:=null;
  outEMAIL:=null;
  outGENDER:=null;
  outBIRTHDATE:=null;
  outMOBILENO:=null; 
  outSTATUS:=null;  
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSEATCOUNT" (i_cardType IN INT, i_boxofficeId IN VARCHAR, i_programId IN INT,isLinkedPrg IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
  IF (isLinkedPrg = 1) THEN
    BEGIN 
      OPEN p_cursor FOR SELECT tbl1.cnt1-tbl2.cnt2 as qty from (select count(sp.seatseqid) as cnt1
            from seatplan@ticketlink sp
            where sp.isonline='Y'
            and sp.classheirarchey= i_cardType
            and sp.boxofficeid = i_boxofficeId) tbl1,
            (select count(sp.seatseqid) as cnt2
            from seatplan@ticketlink sp, ticketbook@ticketlink tb
            where sp.seatseqid = tb.ticketseqid
            and sp.isonline='Y' and tb.Status='S'
            and sp.classheirarchey= i_cardType
            and sp.boxofficeid = i_boxofficeId
            and tb.programid = i_programId) tbl2;
    END;
  ELSE
    BEGIN
    OPEN p_cursor FOR SELECT count(sp.seatseqid) qty
            from seatplan@ticketlink sp, programedFilm@ticketlink pf,TicketBook@ticketlink tb
            where sp.boxofficeid = pf.boxofficeid
            AND pf.ProgramId=tb.ProgramId AND sp.SeatSeqId=tb.TicketSeqId
            and sp.isonline='Y' AND pf.IsOnline='Y' AND tb.Status='B'
            and tb.ticketnumber not in (select ONLINETICKETID from ONLINESALEDETAILSLOG@ticketlink where is_booked='Y')
            and sp.classheirarchey= i_cardType
            and pf.programId = i_programId;
    END; 
  END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSEATSEQIDS" (i_cardType IN INT,i_boxofficeId IN VARCHAR,i_programId IN INT,isLinkedPrg IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN 
  IF (isLinkedPrg = 1) THEN 
   BEGIN
      OPEN p_cursor FOR SELECT sp.seatseqid as seatseqids
                from seatplan@ticketlink sp, programedFilm@ticketlink pf
                where sp.boxofficeid = pf.boxofficeid
                and sp.isonline='Y'
                and sp.classheirarchey= i_cardType
                and sp.boxofficeid = i_boxofficeId
                and pf.programId = i_programId
                minus
                select tb.ticketseqid as seatseqids
                from ticketbook@ticketlink tb,programedFilm@ticketlink pf 
                where tb.PROGRAMID=pf.PROGRAMID  AND pf.IsOnline='Y' AND tb.STATUS='S'
                AND tb.programid = i_programId;
   END;
  ELSE
   BEGIN
      OPEN p_cursor FOR SELECT sp.seatseqid as seatseqids
            from seatplan@ticketlink sp, programedFilm@ticketlink pf
            where sp.boxofficeid = pf.boxofficeid
            and sp.isonline='Y'
            and sp.classheirarchey= i_cardType
            and pf.programId = i_programId ;
   END;
  END IF;
  
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSHOWTIMELISTBYMOVIE" (i_movieId IN INT, i_date IN VARCHAR, i_optionValue IN INT,i_isToday IN INT,p_cursor OUT SYS_REFCURSOR)
AS
BEGIN  
  IF (i_isToday=1) THEN 
     BEGIN 
      OPEN p_cursor FOR SELECT prg.showdate as showdate, to_char(st.showtime,'hh24:miAM') as showtime,
                st.showtimeid as showtimeid, prg.programid as programid, prg.boxofficeid as boxofficeid
                from programedfilm@ticketlink prg,showtime@ticketlink st
                where prg.showtimeid = st.showtimeid
                and prg.boxofficeid = st.boxofficeid
                and prg.featureid = i_movieId
                and prg.IsOnline='Y' AND prg.Status='N'
                AND prg.ISPROSPONED = 'N'
                and prg.showdate=to_date(i_date, 'yyyy-mm-dd')
                and to_char(st.showtime,'hh24:mi:ss') >= to_char((SYSDATE + i_optionValue/1440), 'hh24:mi:ss'); 
    END;
  ELSE
     BEGIN
    OPEN p_cursor FOR SELECT prg.showdate as showdate, to_char(st.showtime,'hh24:miAM') as showtime,
                                st.showtimeid as showtimeid, prg.programid as programid, prg.boxofficeid as boxofficeid
                                from programedfilm@ticketlink prg,showtime@ticketlink st
                                where prg.showtimeid = st.showtimeid
                                and prg.boxofficeid = st.boxofficeid
                                and prg.featureid = i_movieId
                                and prg.IsOnline='Y' AND prg.Status='N'
                                AND prg.ISPROSPONED = 'N'
                                and prg.showdate=to_date(i_date, 'yyyy-mm-dd');
     END; 
  END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSOLDONLINESEATS" (i_cardType IN INT, i_boxofficeId IN VARCHAR, i_programId IN INT,isLinkedPrg IN INT, p_cursor OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_cursor FOR select count(sp.seatseqid) as QTY
            from seatplan@ticketlink sp, ticketbook@ticketlink tb
            where sp.seatseqid = tb.ticketseqid
            and sp.isonline='Y' and tb.Status='S'
            and sp.classheirarchey= i_cardType
            and sp.boxofficeid = i_boxofficeId
            and tb.programid = i_programId;
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "GETSTATUS" (CARDNO IN VARCHAR,currentDate IN DATE,thisCardBal OUT NUMBER,thisTikBal OUT NUMBER,thisActCardNo OUT VARCHAR)
AS
BEGIN
SELECT cardBalance,tikBalance,actCardNo INTO thisCardBal,thisTikBal,thisActCardNo from SCARDBOX@ticketlink where actcardno=CARDNO and DURFROM <= currentDate and DURTO>= currentDate and SCARDSTATUS='S';
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  thisCardBal:=null;
  thisTikBal:=null;
  thisActCardNo:=null;         
END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE "GETUSERBYCARDMOBILE" (card IN CHAR,mobile IN VARCHAR,outCARD OUT VARCHAR)
AS
BEGIN

SELECT CARDNUM INTO outCARD from SCARDBOX@ticketlink where cardnum=card and mobileno = mobile and isonline='Y' and isblocked = 'N';
--SELECT CARDNUM INTO outCARD from SCARDBOX@ticketlink where cardnum=card;
--SELECT CARDNUM INTO outCARD from SCARDBOX@ticketlink where cardnum=card and mobileno = mobile and isonline='Y' and isblocked = 'N';
-- and MOBILENO = mobile and ISONLINE='Y'and ISBLOCKED= 'N';
EXCEPTION
 WHEN NO_DATA_FOUND THEN
  outCARD:=null;
END;



--SELECT CARDNUM from SCARDBOX@ticketlink where cardnum='EC4000' and MOBILENO = '1713144221' and ISONLINE='Y'and ISBLOCKED= 'N';
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "UPDATESCARDBOXBALANCE" (thisCardNo IN VARCHAR,inCardBalance IN NUMBER, inUpdatedDate IN VARCHAR,row OUT NUMBER) 
  IS
   BEGIN
      UPDATE scardbox@ticketlink SET cardBalance=inCardBalance,updatedby=thisCardNo,updateddate=to_date(inUpdatedDate, 'yyyy-mm-dd') WHERE actcardno=thisCardNo;
    
      IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
    row:=1;
      END IF;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "UPDATESCARDBOXPASSCHANGESTATUS" (thisCardNo IN CHAR,thisCardPass IN VARCHAR,inUpdatedDate IN VARCHAR,inSalt IN VARCHAR,row OUT NUMBER)
  IS
   BEGIN
      --UPDATE scardbox@ticketlink SET CARDPASS = thisCardPass, ISPASSCHANGED='Y',updatedby=thisCardNo,salt=inSalt,updateddate=to_date(inUpdatedDate, 'yyyy-mm-dd') WHERE ACTCARDNO=thisCardNo and isblocked='N' and ISONLINE='Y';
        UPDATE scardbox@ticketlink SET CARDPASS = thisCardPass, ISPASSCHANGED='Y',updatedby=thisCardNo,salt=inSalt,updateddate=to_date(inUpdatedDate, 'yyyy-mm-dd') WHERE CARDNUM=thisCardNo and isblocked='N' and ISONLINE='Y';
      IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
    row:=1;
      END IF;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "UPDATESCARDBOXSTATUS" (thisCardNo IN VARCHAR,inUpdatedDate IN VARCHAR,row OUT NUMBER) 
  IS
   BEGIN
      UPDATE scardbox@ticketlink SET scardstatus='S',updatedby=thisCardNo,updateddate=to_date(inUpdatedDate, 'yyyy-mm-dd') WHERE actcardno=thisCardNo and isblocked='N';
    
      IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
    row:=1;
      END IF;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE PROCEDURE            "UPDATESCARDPROFILE" (thisCardNo IN VARCHAR2,thisFIRSTNAME IN VARCHAR2,thisMIDDLENAME IN VARCHAR2,thisLASTNAME IN VARCHAR2,thisEMAIL IN VARCHAR2,thisBIRTHDATE IN VARCHAR,thisGENDER IN VARCHAR2,thisINSERTEDDATE IN VARCHAR,thisMOBILENO IN VARCHAR2,thisSTATUS IN CHAR, row OUT NUMBER)
  IS
   BEGIN
      UPDATE SCARDPROFILE@ticketlink SET FIRSTNAME=thisFIRSTNAME,MIDDLENAME=thisMIDDLENAME,LASTNAME=thisLASTNAME,EMAIL=thisEMAIL,BIRTHDATE=to_date(thisBIRTHDATE,'yyyy-mm-dd'),GENDER=thisGENDER,INSERTEDDATE=to_date(thisINSERTEDDATE,'yyyy-mm-dd'),MOBILENO=thisMOBILENO,STATUS=thisSTATUS WHERE actcardno=thisCardNo and STATUS='Y';    
      IF SQL%NOTFOUND THEN
         row:=0;
      ELSE
    row:=1;
      END IF;
   END;
/

SHOW ERRORS;


CREATE OR REPLACE VIEW VW_CARD
AS 
SELECT   SCB.ACTCARDNO,
            SCB.CARDBALANCE,
            SC.MAXTIKPURALLOWED AS atatimeallowed,
            SC.MaxTicRestriction AS perdayallowd,
            SC.SCARDNO AS CARDTYPE,
            SCB.CARDNUM
     FROM   SEASONCARD@ticketlink SC, SCARDBOX@ticketlink SCB
    WHERE   SC.SCARDNO = SCB.SCARDID AND SCB.ISONLINE = 'Y';


CREATE OR REPLACE VIEW VW_TICKETPRICE
AS 
SELECT   CWC.SUBTOTALS AS TicketUnitPrice,
            CWC.BOXOFFICEID,
            PF.PROGRAMID,
            CWC.PROFILEID,
            CWC.CLASSHEIRARCHEY,
            PF.FEATUREID,
            PF.SHOWTIMEID
     FROM   CLASSWISECOST@ticketlink CWC, PROGRAMEDFILM@ticketlink PF
    WHERE       PF.ISONLINE = 'Y'
            AND CWC.BOXOFFICEID = PF.BOXOFFICEID
            AND CWC.PROFILEID = PF.PROFILEID;


ALTER TABLE AUDIT_INFO ADD (
  CONSTRAINT AUDIT_INFO_PK
 PRIMARY KEY
 (AUDIT_INFO_ID));

ALTER TABLE AUDIT_LOG ADD (
  CONSTRAINT AUDIT_LOG_PK
 PRIMARY KEY
 (AUDIT_ID));

ALTER TABLE USER_INFO ADD (
  CONSTRAINT USER_INFO_PK
 PRIMARY KEY
 (USER_ID));


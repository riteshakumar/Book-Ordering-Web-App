 CREATE OR REPLACE EDITIONABLE TRIGGER "CARDS_BI" 
    BEFORE INSERT
    ON CARDS
    FOR EACH ROW
BEGIN
        IF  :NEW.CD_NUM is null then

            :NEW.CD_NUM := CD_NUM_SEQ.NEXTVAL;
        end if;
        :NEW.ISSUE_DT := sysdate;
        select add_months(sysdate, 48 )-1 into :NEW.EXPIRY_DT from dual;

END;

/
ALTER TRIGGER "CARDS_BI" ENABLE; 



create or replace TRIGGER "BORROWS_BIU" 
    BEFORE INSERT or UPDATE
    ON BORROWS
    FOR EACH ROW
declare
l_checkout_days number;
BEGIN

    IF INSERTING THEN

        :NEW.ISSUE_DT := SYSDATE;

        select DAYS_DUE
          into l_checkout_days
          from MEMBER_TYPE mt,
               MEMBER m
         where mt.MEM_TYPE_ID = m.MEM_TYPE_ID
           and m.ssn = :NEW.MSSN;

        :NEW.DUE_DT := SYSDATE + l_checkout_days;

        :NEW.BORROW_STATUS := 'Issued';
    END IF;

    IF UPDATING THEN
        IF :NEW.RETURN_DT is not null then
            :NEW.BORROW_STATUS := 'Returned';
        END IF;
        
        IF :NEW.DUE_DT < sysdate then
            :NEW.BORROW_STATUS := 'Overdue';
        END IF;
    END IF;
    
END;


/
ALTER TRIGGER "BORROWS_BIU" ENABLE;


  CREATE OR REPLACE EDITIONABLE TRIGGER "MEMBER_TYPE_BI" 
    BEFORE INSERT 
    ON MEMBER_TYPE
    FOR EACH ROW
BEGIN
    IF :NEW.MEM_TYPE_ID IS NULL THEN
        :NEW.MEM_TYPE_ID := TO_NUMBER(SYS_GUID(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    END IF;
END;
/

ALTER TRIGGER "MEMBER_TYPE_BI" ENABLE;
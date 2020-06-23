
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "RETURN_SUMMARY" ("BOOK_ID", "ISBN", "TITLE", "SUBJ_AREA", "AUTHOR", "BINDING", "EDITION", "LANGUAGE", "BOOK_TYPE", "ISSUEDATE", "RETURNDATE", "BORROW_TO", "ISSUE_BY") AS 
  select b.book_id,
        t.ISBN,
        t.TITLE,
        t.SUBJ_AREA,
        t.AUTHOR,
        t.BINDING,
        t.EDITION,
        t.LANGUAGE,
        t.BOOK_TYPE,
        to_char(b.ISSUE_DT,'MON-DD-YYYY HH:MI:SS AM') ISSUEDATE,
        to_char(b.return_dt,'MON-DD-YYYY HH:MI:SS AM') RETURNDATE,
        library_pkg.member_full_name_c(m.cd_num) borrow_to,
        library_pkg.member_full_name_s(b.ISSUED_BY) issue_by
  from BORROWS B,
       TITLE t,
       VOLUMEs V,
       MEMBER M
where b.RETURN_DT is not  null
  and b.book_id = v.book_id
  and v.isbn = t.isbn
  and b.mssn = m.ssn
  order by b.return_dt desc;



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "RENEW_MEMBERSHIPS" ("NAME", "PHONE", "CAMPUS_ADDR", "MAIL_ADDR", "CD_NUM", "EXPIRY_DT") AS 
  select library_pkg.member_full_name_s(m.ssn) as Name,PHONE,CAMPUS_ADDR,MAIL_ADDR,m.CD_NUM,mt.EXPIRY_DT
  from MEMBER m,
       CARDS mt
 where m.CD_NUM = mt.CD_NUM
   and mt.CD_STATUS = 'I';



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "OVERDUE_BOOKS" ("TITLE", "AUTHOR", "EDITION", "BORROWER", "ISSUED_BY", "BORROW_STATUS", "DUE_DT", "GRACE_PERIOD", "ISSUE_DT") AS 
  select t.TITLE,
        t.AUTHOR,
        t.EDITION,
        library_pkg.member_full_name_s(b.MSSN) borrower,
        library_pkg.member_full_name_s(b.ISSUED_BY) issued_by,
        b.BORROW_STATUS,
        b.DUE_DT,
        b.GRACE_PERIOD,
        b.ISSUE_DT
  from TITLE t,
       VOLUMES V,
       BORROWS b
where t.isbn = v.isbn
 and v.book_id = b.book_id
 and b.BORROW_STATUS = 'Overdue'
 and b.RETURN_DT is null;



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CURRENT_BORROW_BOOKS" ("BOOK_ID", "ISBN", "TITLE", "SUBJ_AREA", "AUTHOR", "BINDING", "EDITION", "LANGUAGE", "BOOK_TYPE", "BORROW_TO", "ISSUE_BY") AS 
  select b.book_id,
        t.ISBN,
        t.TITLE,
        t.SUBJ_AREA,
        t.AUTHOR,
        t.BINDING,
        t.EDITION,
        t.LANGUAGE,
        t.BOOK_TYPE,
        library_pkg.member_full_name_c(m.cd_num) borrow_to,
        library_pkg.member_full_name_s(b.ISSUED_BY) issue_by
  from BORROWS B,
       TITLE t,
       VOLUMEs V,
       MEMBER M
where b.RETURN_DT is  null
  and b.book_id = v.book_id
  and v.isbn = t.isbn
  and b.mssn = m.ssn;



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "BORROW_ACTIVITY" ("BOOK_ID", "ISBN", "TITLE", "SUBJ_AREA", "AUTHOR", "BINDING", "EDITION", "LANGUAGE", "BOOK_TYPE", "BORROW_TO", "ISSUE_BY", "DUE_DT", "ISSUE_DT", "RETURN_DT") AS 
  select b.book_id,
        t.ISBN,
        t.TITLE,
        t.SUBJ_AREA,
        t.AUTHOR,
        t.BINDING,
        t.EDITION,
        t.LANGUAGE,
        t.BOOK_TYPE,
        library_pkg.member_full_name_c(m.cd_num) borrow_to,
        library_pkg.member_full_name_s(b.ISSUED_BY) issue_by,
        b.DUE_DT,
        b.ISSUE_DT,
        b.RETURN_DT
  from BORROWS B,
       TITLE t,
       VOLUMEs V,
       MEMBER M
where b.book_id = v.book_id
  and v.isbn = t.isbn
  and b.mssn = m.ssn;



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ALL_MEMBERS" ("NAME", "PHONE", "CAMPUS_ADDR", "MAIL_ADDR", "EMP_TYPE", "CD_NUM") AS 
  select F_NAME ||' '||nvl2(M_NAME,M_NAME||' ','')|| L_NAME as Name,PHONE,CAMPUS_ADDR,MAIL_ADDR,EMP_TYPE,m.CD_NUM
  from MEMBER m,
       MEMBER_TYPE mt
 where m.MEM_TYPE_ID = mt.MEM_TYPE_ID;



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ALL_BOOKS" ("ISBN", "TITLE", "BOOK_DESC", "SUBJ_AREA", "AUTHOR", "BINDING", "EDITION", "LANGUAGE", "BOOK_TYPE", "IS_LENDABLE", "NUMBER_OF_BOOKS", "BOOKS_AVAILABLE") AS 
  select  t.ISBN,
        t.TITLE,
        t.BOOK_DESC,
        t.SUBJ_AREA,
        t.AUTHOR,
        t.BINDING,
        t.EDITION,
        t.LANGUAGE,
        t.BOOK_TYPE,
        t.IS_LENDABLE,
        (select count(*) from VOLUMES v where t.ISBN = v.ISBN and VOL_STATUS = 'Available') number_of_books,
        (select count(*) from VOLUMES v where  t.ISBN = v.ISBN and VOL_STATUS = 'Available' and not exists (select 1 from borrows b where v.book_id =b.book_id and RETURN_DT is null  )) books_available
  from TITLE t;

create or replace package body library_pkg
as

    s constant CHAR(1) := 'S'; -- success status
    f constant CHAR(1) := 'F'; -- failed status

    function volumes_available(p_isbn NUMBER)
        return number
    as
    l_count NUMBER;
    BEGIN
        select count(*)
          into l_count
           from volumes v,title t
         where v.ISBN = p_isbn
           and v.ISBN = t.ISBN
           and v.VOL_STATUS = 'Available'
           and t.is_lendable = 'Y' ;


        return l_count;
    END volumes_available;

    function get_avail_vol(p_isbn NUMBER)
        return number
    as
    l_BOOK_ID NUMBER;
    BEGIN
        select BOOK_ID
          into l_BOOK_ID
          from volumes
         where ISBN = p_isbn
           and VOL_STATUS = 'Available'
           and rownum = 1;

        return l_BOOK_ID;
    END get_avail_vol;

    function get_user_brw_vol(p_isbn NUMBER,
                          p_mssn NUMBER)
        return number
    as
    l_BOOK_ID NUMBER;
    BEGIN
        select b.BOOK_ID
          into l_BOOK_ID
          from volumes v,
               borrows b
         where v.ISBN       = p_isbn
           and v.BOOK_ID    = b.BOOK_ID
           and b.RETURN_DT  is null
           and VOL_STATUS != 'Available';

        return l_BOOK_ID;
    END get_user_brw_vol;

    function get_active_card_num(p_ssn NUMBER)
        return number
    as
    l_cd_num NUMBER;
    begin
        select CD_NUM
          into l_cd_num
          from MEMBER
         where ssn = p_ssn;

        return l_cd_num;
    end get_active_card_num;



    function create_card(p_photo blob default null, x_message out VARCHAR2)
    return number
    as
        l_cd_number CARDS.CD_NUM%TYPE;
    begin
        insert into CARDS (PHOTO,CD_STATUS) values (p_photo,'Y') returning  cd_num into l_cd_number;
        commit;
        return l_cd_number;
    exception when others then
        x_message := SQLERRM;
        return -1;
    end create_card;



    function isbn_exist(p_ISBN IN NUMBER)
    return number
    as
    l_count NUMBER;
    begin
        select count(*)
            into l_count
            from TITLE
         where ISBN = p_ISBN;

        if l_count > 0 then
            return 1;
        else
            return 0;
        end if;
    end isbn_exist;

    procedure add_copies(p_copies NUMBER,
                         p_ISBN NUMBER,
                         p_ACQ_FLAG CHAR DEFAULT NULL,
                         p_ACQ_DT DATE DEFAULT NULL,
                         p_OLD_BOOK_ID NUMBER DEFAULT NULL
                        )
    as
    begin

        for i in 1..p_copies
        loop
        insert into VOLUMES VALUES(TO_NUMBER(SYS_GUID(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                                    p_ISBN,
                                    p_ACQ_FLAG,
                                    p_ACQ_DT,
                                    p_OLD_BOOK_ID,
                                    'Available'
                                    );
        end loop;
        commit;

    end add_copies;



    procedure create_member(p_SSN NUMBER,
                            p_MEM_TYPE_ID NUMBER,
                            p_F_NAME VARCHAR2,
                            p_M_NAME VARCHAR2 default null,
                            p_L_NAME VARCHAR2,
                            p_PHONE VARCHAR2,
                            p_CAMPUS_ADDR VARCHAR2,
                            p_MAIL_ADDR VARCHAR2,
                            p_photo blob default null,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2
                        )
    as
    l_cd_number CARDS.CD_NUM%TYPE;
    l_status VARCHAR2(1);
    l_message VARCHAR2(1000);
    l_c_message VARCHAR2(1000);
    begin
        l_cd_number := create_card(p_photo,l_c_message);

        if l_cd_number = -1 then
            l_status  := f;
            l_message := 'Unable to create Member Cards '||l_cd_number|| l_c_message;
        else
            insert into MEMBER VALUES(p_SSN,p_MEM_TYPE_ID,p_F_NAME,p_M_NAME,p_L_NAME,p_PHONE,p_CAMPUS_ADDR,p_MAIL_ADDR,l_cd_number);
            l_status := s;
            l_message := 'MEMBER Created';
            commit;
        end if;
        x_status  := l_status;
        x_message := l_message;

    EXCEPTION WHEN OTHERS THEN
        x_status  := f;
        x_message := SQLERRM;
    end create_member;


    procedure create_book(p_ISBN NUMBER,
                            p_TITLE VARCHAR2,
                            p_BOOK_DESC VARCHAR2,
                            p_SUBJ_AREA VARCHAR2,
                            p_AUTHOR VARCHAR2,
                            p_BINDING VARCHAR2,
                            p_EDITION VARCHAR2,
                            p_LANGUAGE VARCHAR2,
                            p_BOOK_TYPE VARCHAR2,
                            p_copies NUMBER,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2               
                        )
    as
    l_count NUMBER;
    l_lendable_type VARCHAR2(5);
    begin
        l_count := isbn_exist(p_ISBN );
        if l_count > 0 then
            if p_BOOK_TYPE = 'Normal' then
                l_lendable_type := 'Y';
            else
                l_lendable_type := 'N';
            END if;
            insert into TITLE VALUES (p_ISBN,
                        p_TITLE,
                        p_BOOK_DESC,
                        p_SUBJ_AREA,
                        p_AUTHOR,
                        p_BINDING,
                        p_EDITION,
                        p_LANGUAGE,
                        p_BOOK_TYPE,
                        l_lendable_type);

            commit;

            add_copies(p_copies         => p_copies,
                       p_ISBN           => p_ISBN,
                       p_ACQ_FLAG       => NULL,
                       p_ACQ_DT         => NULL,
                       p_OLD_BOOK_ID    => NULL);

            x_status := s;          
            commit;
        else
            x_status := f;
        end if;
    EXCEPTION WHEN OTHERS THEN
        x_status  := f;
        x_message := SQLERRM;
    end create_book;


    procedure volume_borrow(p_ISBN NUMBER,
                            p_MSSN NUMBER,
                            p_ISSUED_BY NUMBER,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2
                            )
    as
    l_book_id NUMBER;
    l_status VARCHAR2(1);
    l_message VARCHAR2(1000);
    l_lendable_type VARCHAR2(1000);
    begin


            --book available so checkout
            if volumes_available(p_ISBN) > 0 then
                l_book_id := get_avail_vol(p_ISBN);
                insert into BORROWS VALUES(l_book_id,
                                            p_MSSN,
                                            p_ISSUED_BY,
                                            NULL,
                                            NULL,
                                            NULL,
                                            NULL,
                                            NULL
                                            );
                l_status  := s;
                l_message := 'Book checkout completed';
            --book not available so error
            else
                l_status  := f;
                l_message := 'Book Not Available';
            end if;

        x_status  := l_status;
        x_message := l_message;
        commit;
    EXCEPTION WHEN OTHERS THEN
        x_status  := f;
        x_message := SQLERRM;
    END volume_borrow;

    procedure volume_return(p_book_id NUMBER,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2
                            )
    as
    l_book_id NUMBER;
    l_status VARCHAR2(1);
    l_message VARCHAR2(1000);

    begin

            update BORROWS
               set RETURN_DT = sysdate 
             where book_id = p_book_id;
                l_status  := s;
                l_message := 'Book return completed';
        x_status  := l_status;
        x_message := l_message;
        commit;
    EXCEPTION WHEN OTHERS THEN
        x_status  := f;
        x_message := SQLERRM;
    END volume_return;


    procedure renew_membership(p_ssn NUMBER,
                              p_years NUMBER,
                              x_status OUT VARCHAR2,
                              x_message OUT VARCHAR2  )
    as
    l_cd_num NUMBER;
    l_status VARCHAR2(1);
    l_message VARCHAR2(1000);
    begin

        update CARDS
           set EXPIRY_DT = add_months(EXPIRY_DT, p_years*12 )-1,
               CD_STATUS = 'Y'
        where CD_NUM = p_ssn;

        l_status := s;

        commit;

        x_status  := l_status;
        x_message := l_message;

    EXCEPTION WHEN OTHERS THEN
        x_status  := f;
        x_message := SQLERRM;
    end renew_membership; 



    function member_full_name_c(p_member_id NUMBER) return VARCHAR2
    as
    l_name VARCHAR2(100);
    begin
          select nvl2(F_NAME,F_NAME||' ','') ||nvl2(M_NAME,M_NAME||' ','')|| nvl2(L_NAME,L_NAME||' ','') as Name
            into l_name
          from MEMBER m
         where CD_NUM = p_member_id ;
         return l_name;
    end ;

    function member_full_name_s(p_member_id NUMBER) return VARCHAR2
    as
    l_name VARCHAR2(100);
    begin
          select nvl2(F_NAME,F_NAME||' ','') ||nvl2(M_NAME,M_NAME||' ','')|| nvl2(L_NAME,L_NAME||' ','') as Name
            into l_name
          from MEMBER m
         where SSN = p_member_id ;
         return l_name;
    end member_full_name_s;


        procedure check_overdue
        as
        begin
            for c in (select c.*,rowid from borrows c)
                loop
                    if c.GRACE_PERIOD - c.DUE_DT = 14 THEN
                        if trunc(sysdate) = trunc(c.DUE_DT) then
                            update borrows
                              set BORROW_STATUS = 'Overdue'
                            where rowid = c.rowid;
                        end if;
                    elsif c.GRACE_PERIOD - c.DUE_DT = 7 THEN
                        if trunc(sysdate) = trunc(c.DUE_DT) then
                            update borrows
                              set BORROW_STATUS = 'Overdue'
                            where rowid = c.rowid;
                        end if;
                    end if;
                end loop;
        end;



       procedure check_renew_membership
               as
        begin
            for c in (select c.*,c.rowid rwid1,cc.rowid rwid2,cc.EXPIRY_DT  from MEMBER c, CARDS cc where c.cd_num = cc.cd_num)
                loop

                        if c.EXPIRY_DT - sysdate <= 30 then
                            update CARDS
                              set CD_STATUS = 'I'
                            where rowid = c.rwid2;
                        end if;

                end loop;
        end;
end library_pkg;
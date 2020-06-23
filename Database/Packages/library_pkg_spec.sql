create or replace package library_pkg
as
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
                        );
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
                        );
    procedure volume_borrow(p_ISBN NUMBER,
                            p_MSSN NUMBER,
                            p_ISSUED_BY NUMBER,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2
                            );

    procedure volume_return(p_book_id NUMBER,
                            x_status OUT VARCHAR2,
                            x_message OUT VARCHAR2
                            );

    procedure renew_membership(p_ssn NUMBER,
                              p_years NUMBER,
                              x_status OUT VARCHAR2,
                              x_message OUT VARCHAR2  );
    function member_full_name_c(p_member_id NUMBER) return VARCHAR2;
    function member_full_name_s(p_member_id NUMBER) return VARCHAR2;
    
    procedure check_overdue;
    procedure check_renew_membership;
end library_pkg;
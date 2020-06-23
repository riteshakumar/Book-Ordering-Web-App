<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  
  //initialize driver class
  try {    
    Class.forName("oracle.jdbc.driver.OracleDriver");
  } catch (Exception e) {
    out.println("Fail to initialize Oracle JDBC driver: " + e.toString() + "<P>");
  }
  
String dbUser = "rxk2622";
String dbPasswd = "Rits55002307";
String dbURL = "jdbc:oracle:thin:@acaddbprod-1.uta.edu:1523/pcse1p.data.uta.edu";

  //connect
  Connection conn = null;
  try {
    conn = DriverManager.getConnection(dbURL,dbUser,dbPasswd);

  } catch(Exception e) {
    out.println("Connection failed: " + e.toString() + "<P>");      
  }
String isbn=request.getParameter("isbn");
String title=request.getParameter("title");
String book_desc=request.getParameter("book_desc");
String subj_area=request.getParameter("subj_area");
String author=request.getParameter("author");
String binding=request.getParameter("binding");
String edition=request.getParameter("edition");
String language=request.getParameter("language");
String book_type=request.getParameter("book_type");
String copies=request.getParameter("copies");


String x_status ="", x_message =""; 

        try{
            CallableStatement proc = conn.prepareCall ("begin library_pkg.create_book(?,?,?,?,?,?,?,?,?,?,?,?); end;");
            proc.setString (1, isbn);
            proc.setString (2, title);
            proc.setString (3, book_desc);
            proc.setString (4, subj_area);
            proc.setString (5, author);
            proc.setString (6, binding);
            proc.setString (7, edition);
            proc.setString (8, language);
            proc.setString (9, book_type);
            proc.setString (10, copies);



            proc.registerOutParameter(11, java.sql.Types.VARCHAR);
            proc.registerOutParameter(12, java.sql.Types.VARCHAR);
            proc.execute ();
            x_status  = proc.getString(11);
            x_message = proc.getString(12);
            proc.close();

            %>
            <h1>Book Created</h1>
            <a href="index.html">Home</a>
<%
        }
        catch(Exception e) {
            conn.close(); 
            out.println("Error " + e.toString() + "<P>");      
          }
  %>
   <%
      conn.close(); 
    %>
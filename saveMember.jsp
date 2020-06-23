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
String ssn=request.getParameter("ssn");
String f_name=request.getParameter("f_name");
String m_name=request.getParameter("m_name");
String l_name=request.getParameter("l_name");
String phone=request.getParameter("phone");
String cadd=request.getParameter("cadd");
String madd=request.getParameter("madd");
String mtype=request.getParameter("mtype");
InputStream inputStream = null;
String x_status ="", x_message =""; 

        try{
            CallableStatement proc = conn.prepareCall ("begin library_pkg.create_member(?,?,?,?,?,?,?,?,?,?,?); end;");
            proc.setString (1, ssn);
            proc.setString (2, mtype);
            proc.setString (3, f_name);
            proc.setString (4, m_name);
            proc.setString (5, l_name);
            proc.setString (6, phone);
            proc.setString (7, cadd);
            proc.setString (8, madd);
            proc.setBlob (9,inputStream );

            proc.registerOutParameter(10, java.sql.Types.VARCHAR);
            proc.registerOutParameter(11, java.sql.Types.VARCHAR);
            proc.execute ();
            x_status  = proc.getString(10);
            x_message = proc.getString(11);
            proc.close();

            %>
            <h1>Member Created</h1>
            <a href="index.html">Home</a>
<%
        }
        catch(Exception e) {
            conn.close(); 
            out.println("Error " + e.toString() + "<P>");      
          }

      conn.close(); 
    %>
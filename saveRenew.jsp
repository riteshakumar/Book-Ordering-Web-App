<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
            
            <a href="index.html">Home</a>
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
 %>
<%

    
    String memid=request.getParameter("memid");
    String yrs=request.getParameter("yrs");
    
%><%
String x_status ="", x_message =""; 

        try{
            CallableStatement proc = conn.prepareCall ("begin library_pkg.renew_membership(?,?,?,?); end;");
            proc.setString (1, memid);
            proc.setString (2, yrs);
            
            
            proc.registerOutParameter(3, java.sql.Types.VARCHAR);
            proc.registerOutParameter(4, java.sql.Types.VARCHAR);
            proc.execute ();
            x_status  = proc.getString(3);
            x_message = proc.getString(4);


            %>
            
            <h1>Membership Renewed </h1>
            <br><br>


            <%
                            }
            catch(Exception e) {
                out.println("Error " + e.toString() + "<P>");      
            }
%>
  
  <%
            conn.close(); 
    %>

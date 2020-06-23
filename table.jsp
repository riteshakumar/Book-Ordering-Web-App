<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
  <table width="59%" border="1">
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
        Statement statement;
        ResultSet r;
        String q = "select * from MEMBER_TYPE";
        statement = conn.createStatement();
        r = statement.executeQuery(q);
        while(r.next())
        {
            %>
                <tr>
                     <td><%= r.getString(2)%></td>                                      
                </tr>
            <% 
        }
  %>
  </table>
    </body>
<%
    conn.close(); 
%>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
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
  }%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <style>
		body {
	    	background-image: url("images/background.jpg");
		}
		.no-background {
	    background-image: url("images/blank.jpg");
		}
		</style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
       <h1>Library Management System </h1>
        <a href="newMember.jsp">Add Member</a> |
        <a href="newBook.jsp">Add Book</a> |
        <a href="borrow.jsp">Borrow Book</a> |
        <a href="returnBook.jsp">Return Book</a> |
        <a href="renewMembership.jsp">Renew Membership</a> |
        <a href="AllMembers.jsp">All Members</a> |
        <a href="AllBooks.jsp">All Books</a> |
        <a href="viewRenewRequest.jsp">Membership Renew Notifications</a> |
        <a href="overduesummary.jsp">Overdue Books</a> |
        <a href="weeklyActivity.jsp">Weekly Activity</a> |
        <br></br>
        <table  border="1" cellspacing="0" cellpadding="5">
            <tr>
                <td>
                    Title
                </td>
                <td>
                    Author
                </td>
                <td>
                    Edition
                </td>
                <td>
                    Borrow by
                </td>
                <td>
                    Issue by
                </td>
                <td>
                    Borrow Status
                </td>
                <td>
                    Due Date
                </td>
                <td>
                    Grace Date
                </td>
                <td>
                    Issue Date
                </td>
                
            </tr>
            <%
                    Statement statement;
                    ResultSet r;
                    String q = "select * from OVERDUE_BOOKS";
                    statement = conn.createStatement();
                    r = statement.executeQuery(q);
                    while(r.next())
                    {
                        %>
                            <tr>
                             <%
                             for(int i = 1; i<=9;i++)
                                { %>
                                 <td>
                                 <%= r.getString(i)%>
                                 </td>
                            <% 
                                }
                            %>                   
                            </tr>
                        <% 
                    }
              %>
        </table>
      <%
      conn.close(); 
      %>
    </body>
</html>

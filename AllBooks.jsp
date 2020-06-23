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
                    ISBN
                </td>
                <td>
                    TITLE
                </td>
                <td>
                    BOOK Description
                </td>
                <td>
                    Subject
                </td>
                <td>
                    Author
                </td>
                <td>
                    Binding
                </td>
                <td>
                    Edition
                </td>
                <td>
                    Language
                </td>
                <td>
                    Book Type
                </td>
                <td>
                    Allow to Borrow
                </td>
                <td>
                    No of Total Books
                </td>
                <td>
                    No of Books Available to Borrow
                </td>
            </tr>
            <%
                    Statement statement;
                    ResultSet r;
                    String q = "select * from all_books";
                    statement = conn.createStatement();
                    r = statement.executeQuery(q);
                    while(r.next())
                    {
                        %>
                            <tr>
                             <%
                             for(int i = 1; i<=12;i++)
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

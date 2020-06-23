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

    
    String bookid=request.getParameter("bookid");
%><%
String x_status ="", x_message =""; 

        try{
            CallableStatement proc = conn.prepareCall ("begin library_pkg.volume_return(?,?,?); end;");
            proc.setString (1, bookid);
            
            
            proc.registerOutParameter(2, java.sql.Types.VARCHAR);
            proc.registerOutParameter(3, java.sql.Types.VARCHAR);
            proc.execute ();
            x_status  = proc.getString(2);
            x_message = proc.getString(3);


            %>
            
            <h1>Book Returned</h1>
            <br><br>
            <h2>Book Return Summary</h2>

            <%
                            }
            catch(Exception e) {
                out.println("Error " + e.toString() + "<P>");      
            }
%>
        <table  border="1" cellspacing="0" cellpadding="5">
            <tr>
                <td>
                    ISBN
                </td>
                <td>
                    TITLE
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
                    Issue Date
                </td>
                <td>
                    Issue By
                </td>
                <td>
                    Return Date
                </td>
            </tr>
            <%
                    Statement statement;
                    ResultSet r;
                    String q = "select * from RETURN_SUMMARY WHERE book_id = "+bookid+" and rownum = 1";
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
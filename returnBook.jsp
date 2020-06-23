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
  

<html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/css/select2.min.css" rel="stylesheet" />

        <style>
		body {
	    	background-image: url("images/background.jpg");
		}
		.no-background {
	    background-image: url("images/blank.jpg");
		}
input[type=text], select, textarea,input[type=number] ,input[type=textarea] {
  width: 100%; /* Full width */
  padding: 12px; /* Some padding */ 
  border: 1px solid #ccc; /* Gray border */
  border-radius: 4px; /* Rounded borders */
  box-sizing: border-box; /* Make sure that padding and width stays in place */
  margin-top: 6px; /* Add a top margin */
  margin-bottom: 16px; /* Bottom margin */
  resize: vertical /* Allow the user to vertically resize the textarea (not horizontally) */
}

/* Style the submit button with a specific background color etc */
input[type=submit] {
  background-color: #4CAF50;
  color: white;
  padding: 12px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

/* When moving the mouse over the submit button, add a darker green color */
input[type=submit]:hover {
  background-color: #45a049;
}

/* Add a background color and some padding around the form */
.form-inline button {
  padding: 10px 20px;
  background-color: dodgerblue;
  border: 1px solid #ddd;
  color: white;
}

.form-inline button:hover {
  background-color: royalblue;
}
        </style>
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
        <br></br>
    <div class="container">
        <form class="form-inline" method="post" action="saveReturnBook.jsp">
            
        <label for="bookid">Borrowed Books</label>	
        <select id="bookid" name="bookid" class="js-example-basic-single1" required>
            <option value=""></option>
            <%
                    Statement statement;
                    ResultSet r;
                    String q = "select * from CURRENT_BORROW_BOOKS";
                    statement = conn.createStatement();
                    r = statement.executeQuery(q);
                    while(r.next())
                    {
                        %>

                            <option value='<%= r.getString(1)%>'>Borrow to <%= r.getString(10)%>, Book Details - <%= r.getString(3)%> by  <%= r.getString(5)%></option>
                        <% 
                    }
              %>
        </select>
  <br> <br>
  <button type="submit">Submit</button>
</form>
    </div>
        <script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/js/select2.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.0.12/dist/js/select2.min.js"></script>
        <script>
            $(document).ready(function() {
                $('.js-example-basic-single1').select2();
                $('.js-example-basic-single2').select2();
                $('.js-example-basic-single3').select2();
            });
        </script>
    <%
      conn.close(); 
    %>
</body>
</html>

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
        <a href="weeklyActivity.jsp">Weekly Activity</a> |
        <br></br>
    <div class="container">
        <form class="form-inline" method="post" action="saveBook.jsp">
            
<label for="isbn">ISBN</label>	
<input type="number" id="isbn" placeholder="Enter ISBN" name="isbn" required>
<label for="title">TITLE</label>	
<input type="text" id="title" placeholder="Enter TITLE" name="title" required>
<label for="book_desc">BOOK Description</label>	
<input type="text" id="book_desc" placeholder="Enter BOOK Description" name="book_desc" required>
<label for="subj_area">SUBJECT</label>	
<input type="text" id="subj_area" placeholder="Enter SUBJECT" name="subj_area" required>
<label for="author">AUTHOR</label>	
<input type="text" id="author" placeholder="Enter AUTHOR" name="author" required>
<label for="binding">BINDING</label>	
<input type="text" id="binding" placeholder="Enter BINDING" name="binding" required>
<label for="edition">EDITION</label>	
<input type="text" id="edition" placeholder="Enter EDITION" name="edition" required>
<label for="language">LANGUAGE</label>	
<input type="text" id="language" placeholder="Enter LANGUAGE" name="language" required>
<label for="book_type">BOOK_TYPE</label>	
<select id="book_type" name="book_type" required>
    <option value='Normal'>Normal</option>
    <option value='Reference'>Reference</option>
    <option value='Rare'>Rare</option>
    <option value='Map '>Map </option>
</select>
<label for="copies">Volumes</label>	
<input type="number" id="copies" placeholder="Enter copies" name="copies" required>


  <br>
  <button type="submit">Submit</button>
</form>
    </div>
    <%
      conn.close(); 
    %>
</body>
</html>

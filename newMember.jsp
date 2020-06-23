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
/* .container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
} */
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
        <form class="form-inline" method="post" action="saveMember.jsp">
  <label for="ssn">SSN</label>
  <input type="number" id="ssn" placeholder="Enter SSN" name="ssn" maxlength="10" size="10" required>
  <label for="photo">Photo</label><br></br>
  <input type="file" id="photo" placeholder="Upload Photo" name="photo" size="50" required>
  <br></br>
  <label for="f_name">First name</label>
  <input type="text" id="f_name" placeholder="Enter First name" name="f_name" required>
  <br>
  <label for="m_name">Middle name</label>
  <input type="text" id="m_name" placeholder="Enter Middle name" name="m_name">
  <br>
  <label for="l_name">Last name</label>
  <input type="text" id="l_name" placeholder="Enter Last name" name="l_name" required>
  <br>
  <label for="phone">Phone</label>
  <input type="number" id="phone" placeholder="Enter Phone" name="phone" maxlength="10" size="10" required>
  <br>
  <label for="cadd">Campus Address</label>
  <input type="textarea" id="cadd" placeholder="Enter Campus Address" name="cadd" required>
  <br>
  <label for="madd">Mail Address</label>
  <input type="textarea" id="madd" placeholder="Enter Mailing Address" name="madd" required>
  <br>
  <label for="mtype">Member Type</label>
  <select id="mtype" name="mtype" required>
<option value=""></option>
<%
        Statement statement;
        ResultSet r;
        String q = "select * from MEMBER_TYPE";
        statement = conn.createStatement();
        r = statement.executeQuery(q);
        while(r.next())
        {
            %>
                
                <option value='<%= r.getString(1)%>'><%= r.getString(3)%></option>
            <% 
        }
  %>

    </select>
  <br>
  <button type="submit">Submit</button>
</form>
    </div>
    <%
      conn.close(); 
    %>
</body>
</html>

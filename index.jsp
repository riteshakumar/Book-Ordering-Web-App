<%-- 
    Document   : index.jsp
    Created on : Apr 10, 2020, 20:01:19
    Author     : Ritesh Kumar
--%>


<!DOCTYPE html>

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
        <title>Library Management System </title>
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

    </body>
</html>

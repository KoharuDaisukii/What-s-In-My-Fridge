<%@page import="java.sql.Statement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Phase3Package.JDBCDriver"%>
<%@page import="java.sql.Connection"%>
<%@page import="Phase3Package.Configure"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://kit.fontawesome.com/7b62cb3616.js" crossorigin="anonymous"></script>
<style>
nav {
	background-color: #57cc99;
	overflow: hidden;
}

nav a {
	float: left;
	display: block;
	color: white;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
}

nav a:hover {
	background-color: #ddd;
	color: black;
}

.signup-wrapper {
	width: 500px;
	height: auto;
	padding: 40px;
	box-sizing: border-box;
	margin: auto;
}

.signup-wrapper>h2 {
	font-size: 24px;
	color: #57cc99;
	margin-bottom: 20px;
}

#signup-form>input {
	width: 100%;
	height: 48px;
	padding: 0 10px;
	box-sizing: border-box;
	margin-bottom: 16px;
	border-radius: 6px;
	background-color: #F8F8F8;
}

#signup-form>input::placeholder {
	color: #D2D2D2;
}

#signup-form>input[type="submit"] {
	color: #fff;
	font-size: 16px;
	background-color: #551A8B;
	margin-top: 20px;
}

#signup-form>select {
	width: 100%;
	height: 48px;
	padding: 0 10px;
	box-sizing: border-box;
	margin-bottom: 16px;
	border-radius: 6px;
	background-color: #F8F8F8;
}
</style>
</head>
<body>
	<!-- Page Top -->
	<div id="pagetop" style="border: 1px solid black;">
		<a id="wif-logo" href="/WIF/index.jsp" title="WIF 홈" style="text-decoration-line: none;">
			<!-- 상 우 하 좌 -->
			<i class="fa-solid fa-plate-wheat fa-2x" style="margin: 10px 10px 10px 10px;"> What's in my Fridge?</i>
		</a>
		<form id="search-container" action="/WIF/search-result.jsp" style="border: 1px solid black; display: inline;">
			<input name="search-keyword" type="text" placeholder="검색창임" required><input type="submit" value="검색">
		</form>
		<jsp:include page="./login-include.jsp" />
	</div>

	<nav>
		<a href="index.jsp">홈</a>
		<a href="all_cuisine.jsp">요리</a>
		<a>레시피</a>
		<a>냉장고</a>
	</nav>

	<hr>

	<div class="signup-wrapper">
		<h2>회원가입</h2>
		<form action="/WIF/signup.jsp" method="post" id="signup-form">
			<p>
				<i class="fa-solid fa-exclamation" style="color: #57cc99;"></i>
				아이디
			</p>
			<input type="text" name="id" id="id" placeholder="ID" required> <input type="button" value="아이디 중복확인" onclick="return idValidation()">
			<p>
				<i class="fa-solid fa-exclamation" style="color: #57cc99;"></i>
				비밀번호
			</p>
			<input type="text" name="pw" placeholder="비밀번호" required>
			<p>
				<i class="fa-solid fa-exclamation" style="color: #57cc99;"></i>
				이름
			</p>
			<input type="text" name="name" placeholder="이름" required>
			<p>
				<i class="fa-solid fa-exclamation" style="color: #57cc99;"></i>
				Email
			</p>
			<input type="text" name="email" placeholder="이메일" required> <input type="button" value="Email 중복확인" onclick="return emailValidation()">
			<p>성별</p>
			<select name="sex">
				<option value="M">M</option>
				<option value="F">F</option>
			</select>

			<div>
				<input type="submit" value="회원가입" style="WIDTH: 60pt;">
			</div>
		</form>
	</div>
	<%
	String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	String DB_ID = Configure.DB_ID;
	String DB_PW = "comp322";

	Connection conn = null;
	JDBCDriver.load();
	conn = JDBCDriver.getConnection(URL, DB_ID, DB_PW);
	%>

	<%
	ArrayList<String> idAL = new ArrayList<>();
	ArrayList<String> emailAL = new ArrayList<>();
	String query = "SELECT User_ID, Email FROM Users";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(query);

	while (rs.next()) {
		idAL.add(rs.getString(1));
		emailAL.add(rs.getString(2));
	}

	StringBuffer values1 = new StringBuffer();
	for (int i = 0; i < idAL.size(); i++) {
		if (values1.length() > 0) {
			values1.append(',');
		}
		values1.append('"').append(idAL.get(i)).append('"');
	}

	StringBuffer values2 = new StringBuffer();
	for (int i = 0; i < emailAL.size(); i++) {
		if (values2.length() > 0) {
			values2.append(',');
		}
		values2.append('"').append(emailAL.get(i)).append('"');
	}
	%>

	<%
	rs.close();
	stmt.close();
	JDBCDriver.close(conn);
	%>


	<script type="text/javascript">
		function idValidation() {
			var id = document.getElementById("id").value;
			var flag = true;
			var list = [
	<%=values1.toString()%>
		];
			if (id == "") {
				alert("아이디를 입력해주세요.");
				return;
			}
			for (var i = 0; i < list.length; i++) {
				if (id == list[i]) {
					flag = false;
					break;
				}
			}
			if (flag)
				alert("사용 가능한 아이디입니다.");
			else
				alert("이미 사용하고 있는 아이디입니다.");
		}

		function emailValidation() {
			var email = document.getElementById("email").value;
			var flag = true;
			var list = [
	<%=values2.toString()%>
		];
			if (email == "") {
				alert("이메일을 입력해주세요.");
				return;
			}
			for (var i = 0; i < list.length; i++) {
				if (email == list[i]) {
					flag = false;
					break;
				}
			}
			if (flag)
				alert("사용 가능한 이메일입니다.");
			else
				alert("이미 사용하고 있는 이메일입니다.");
		}
	</script>
</body>
</html>
<%@page import="Phase3Package.Print"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.Math"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="Phase3Package.JDBCDriver"%>
<%@page import="java.sql.*"%>
<%@page import="Phase3Package.Configure"%>
<%@page import="Phase3Package.Recipe"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/7b62cb3616.js"
	crossorigin="anonymous"></script>
<title>What's in my Fridge?</title>
<link rel="stylesheet" type="text/css" href="indexStyle.css">
</head>

<body>
	<!-- 프로젝트 properties - project facets에서 dynamic web module 3.0 체크, java 1.8 변경, runtimes에 톰캣 추가-->
	<!-- Page Top -->

	<%@ include file="navigationBar.jsp" %>

	<main id="container">
		<div id="뭉탱이" style="display: flex; height: 100%;"></div>
		<!-- 왼쪽-->
		<section id="main-content"
			style="display: block; float: left; width: 70%">
			<div class="recipe-today">
				<p>
					<i class="fa-solid fa-crown fa-2x" style="color: #d4cf25;"> 오늘의 레시피</i>
				</p>
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
			String query = "SELECT * FROM (SELECT R.recipe_id, R.title, R.writer_id, CU.cuisine_name, CU.category, (SELECT COUNT(*) FROM FAVORITE F WHERE R.recipe_id = F.like_recipe_id and f.like_time BETWEEN TO_DATE(TO_CHAR(sysdate-1, 'YYYYMMDD') || '000000', 'YYYYMMDDHH24MISS') AND TO_DATE(TO_CHAR(sysdate, 'YYYYMMDD') || '000000', 'YYYYMMDDHH24MISS')) as likecount, (SELECT COUNT(*) FROM COMMENTS C WHERE R.recipe_id = C.recipe_id and C.comment_time BETWEEN TO_DATE(TO_CHAR(sysdate-1, 'YYYYMMDD') || '000000', 'YYYYMMDDHH24MISS') AND TO_DATE(TO_CHAR(sysdate, 'YYYYMMDD') || '000000', 'YYYYMMDDHH24MISS')) as commentcount,(SELECT COUNT(*) FROM FAVORITE F WHERE R.recipe_id = F.like_recipe_id) as totlikecount, (SELECT COUNT(*) FROM COMMENTS C WHERE R.recipe_id = C.recipe_id) as totcommentcount FROM RECIPE R, CUISINE CU WHERE R.cuisine_id = CU.cuisine_id ORDER BY likecount + commentcount DESC, totlikecount + totcommentcount DESC) WHERE ROWNUM <= 6";
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			int rank = 1;

			ArrayList<String> titles = new ArrayList<>();
			ArrayList<String> writers = new ArrayList<>();
			ArrayList<String> cuisines = new ArrayList<>();
			ArrayList<String> categories = new ArrayList<>();
			ArrayList<Integer> ids = new ArrayList<>();

			while (rs.next()) {
				int id = rs.getInt(1);
				String raw_title = rs.getString(2);
				String title = raw_title.substring(0, Math.min(30, raw_title.length()));
				if (raw_title.length() > 30)
					title = title + "...";
				ids.add(id);
				titles.add(title);
				writers.add(rs.getString(3));
				cuisines.add(rs.getString(4));
				categories.add(rs.getString(5));
			}
			for (int j = 0; j < 2; j++) {

				out.println("<div class=\"recipe-rank\">");
				for (int i = 0; i < 3; i++) {
					int idx = j * 3 + i;
					out.println("<div class=\"post\">");
					out.println("<div style=\"font-size: 25px; color: #57cc99; margin-bottom: 15px;\">" + rank++ + "위</div>");
					out.println(
					"<div style=\"margin-bottom: 15px\"><a style=\"text-decoration-line: none; color: black;\" href=\"/WIF/view-recipe.jsp?recipe-id="
							+ ids.get(idx) + "\">" + titles.get(idx) + "</a></div>");
					out.println("<div><span style=\"float: left; color: #999;\">" + cuisines.get(idx) + " | " + categories.get(idx)
					+ "</span><span style=\"float: right; color: #009933;\">" + writers.get(idx) + "</span></div>");
					out.println("</div>");
				}
				out.println("</div>");
			}
			%>
			
			<div class="recipe-today">
				<p>
					<i class="fa-solid fa-pen fa-2x" style="color: #d4cf25;"> 최근 올라온 레시피</i>
				</p>
			</div>
			<%
			String query2 = "SELECT * \r\n" +
						 "FROM (SELECT R.recipe_id, R.title, R.writer_id, CU.cuisine_name, CU.category, R.write_time \r\n" +
						 "      FROM RECIPE R, CUISINE CU \r\n" +
						 "      WHERE R.cuisine_id = CU.cuisine_id \r\n" +
						 "      ORDER BY R.write_time DESC) \r\n" +
						 "WHERE ROWNUM <= 6";
			pstmt = conn.prepareStatement(query2);
			rs = pstmt.executeQuery();
			
			titles.clear(); writers.clear(); cuisines.clear(); categories.clear(); ids.clear();
			
			while(rs.next()) {
				ids.add(rs.getInt(1));
				String raw_title = rs.getString(2);
				String title = raw_title.substring(0, Math.min(30, raw_title.length()));
				if (raw_title.length() > 30)
					title = title + "...";
				titles.add(title);
				writers.add(rs.getString(3));
				cuisines.add(rs.getString(4));
				categories.add(rs.getString(5));
			}
			
			for (int j = 0; j < 2; j++) {

				out.println("<div class=\"recipe-rank\">");
				for (int i = 0; i < 3; i++) {
					int idx = j * 3 + i;
					out.println("<div class=\"post\">");
//					out.println("<div style=\"font-size: 25px; color: #57cc99; margin-bottom: 15px;\">" + rank++ + "위</div>");/*  */
					out.println(
					"<div style=\"margin-bottom: 15px\"><a style=\"text-decoration-line: none; color: black;\" href=\"/WIF/view-recipe.jsp?recipe-id="
							+ ids.get(idx) + "\">" + titles.get(idx) + "</a></div>");
					out.println("<div><span style=\"float: left; color: #999;\">" + cuisines.get(idx) + " | " + categories.get(idx)
					+ "</span><span style=\"float: right; color: #009933;\">" + writers.get(idx) + "</span></div>");
					out.println("</div>");
				}
				out.println("</div>");
			}
			
			%>
			
			<%
			rs.close();
			pstmt.close();
			%>
		</section>
		<!-- 오른쪽 -->
		<section id="login-box"
			style="display: block; float: right; width: 30%">
			<%-- <div class="styled-button" id="loginButton2" style="width: 90%;">
				<jsp:include page="./login-include.jsp" />
			</div> --%>

			<div>
				<p style="text-align: center;">
					<i class="fa-solid fa-chart-simple fa-2x" style="color: #d4cf25;"> 통계</i>
				</p>

				<div class="userRanking">
					<h2>유저 랭킹</h2>
					<p>좋아요 수와 댓글 수의 합으로 점수가 계산됩니다.!</p>
					<table>
						<thead>
							<tr>
								<th>순위</th>
								<th>사용자 (Id)</th>
								<th>점수</th>
							</tr>
						</thead>
						<tbody>
							<%
							// 여기서부터 유저 랭킹 데이터를 동적으로 추가하는 부분입니다.
							String sql = "SELECT\n" + "    id, S\n" + "FROM\n" + "    (\n" + "        SELECT\n"
									+ "            SUM(Ccnt + Fcnt) AS S,\n" + "            T1.id\n" + "        FROM\n" + "                     (\n"
									+ "                SELECT\n" + "                    COUNT(*)  AS Ccnt,\n"
									+ "                    C.User_id AS id\n" + "                FROM\n" + "                    COMMENTS C\n"
									+ "                GROUP BY\n" + "                    C.User_id\n" + "            ) T1\n"
									+ "            JOIN (\n" + "                SELECT\n" + "                    COUNT(*)       AS Fcnt,\n"
									+ "                    F.Like_user_id AS id\n" + "                FROM\n" + "                    FAVORITE F\n"
									+ "                GROUP BY\n" + "                    F.Like_user_id\n" + "            ) T2 ON T1.id = T2.id\n"
									+ "        GROUP BY\n" + "            T1.id\n" + "        ORDER BY\n" + "            S DESC\n" + "    )\n"
									+ "WHERE\n" + "    ROWNUM <= 3";

							try {
								Statement stmt = conn.createStatement();
								rs = stmt.executeQuery(sql);

								rank = 1;

								while (rs.next()) {
									String userIds = rs.getString(1);
									int score = rs.getInt(2);

									// 유저 랭킹 테이블에 데이터를 동적으로 추가합니다.
									out.println("<tr>");
									out.println("<td>" + rank + "</td>");
									out.println("<td>" + userIds + "</td>");
									out.println("<td>" + score + "</td>");
									out.println("</tr>");

									rank++;
								}
								rs.close();
								stmt.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
							%>
						</tbody>
					</table>
				</div>


				<div class="inactiveUser">
					<div
						style="font-size: 25px; color: #57cc99; margin-bottom: 15px; text-align: center;">비활동
						유저</div>
					<%
					String inactiveUserRatioContext = null;
					String sql1 = "SELECT\r\n" + "	count(U.USER_ID)\r\n" + "FROM\r\n" + "	USERS U\r\n" + "WHERE\r\n"
							+ "	NOT EXISTS (\r\n" + "		SELECT\r\n" + "			*\r\n" + "		FROM\r\n" + "			RECIPE R\r\n"
							+ "		WHERE\r\n" + "			R.WRITER_ID = U.USER_ID\r\n" + "	)";
					String sql2 = "SELECT COUNT(*) FROM USERS";

					try {
						Statement stmt = conn.createStatement();
						int inactives = 0, total = 0;
						ResultSet rs1 = stmt.executeQuery(sql1);
						if (rs1.next())
							inactives = rs1.getInt(1);
						ResultSet rs2 = stmt.executeQuery(sql2);
						if (rs2.next())
							total = rs2.getInt(1);
						//System.out.println(""+inactives+" "+total);

						if (total < 1)
							inactiveUserRatioContext = "아직 가입한 회원이 없어요..";
						else {
							float tmp = inactives / (float) total * 100;
							inactiveUserRatioContext = String.valueOf(tmp) + "%가 레시피 작성을 안했어요!";
						}
						Print.printString(inactiveUserRatioContext);

						out.println("<div style=\"margin-bottom: 15px; text-align: center;\">");
						out.println("<a style=\"display: inline-block;\">" + inactiveUserRatioContext + "</a>");
						out.println("</div>");

						rs1.close();
						rs2.close();
						stmt.close();

					} catch (SQLException e) {
						e.printStackTrace();
					}
					%>
				</div>

				<div class="userAgeDistribution">
					<div
						style="font-size: 25px; color: #57cc99; margin-bottom: 15px; text-align: center;">연령별
						활동 비율</div>
					<%
					sql = "SELECT\r\n" + "	AGE_GROUP,\r\n" + "	COUNT(*) CNT\r\n" + "FROM\r\n" + "	(\r\n" + "		SELECT\r\n"
							+ "			CASE\r\n" + "			    WHEN Age < 10              THEN\r\n" + "			        '9세 이하'\r\n"
							+ "			    WHEN Age BETWEEN 10 AND 19 THEN\r\n" + "			        '10대'\r\n"
							+ "			    WHEN Age BETWEEN 20 AND 29 THEN\r\n" + "			        '20대'\r\n"
							+ "			    WHEN Age BETWEEN 30 AND 39 THEN\r\n" + "			        '30대'\r\n"
							+ "			    WHEN Age BETWEEN 40 AND 49 THEN\r\n" + "			        '40대'\r\n"
							+ "			    WHEN Age BETWEEN 50 AND 59 THEN\r\n" + "			        '50대'\r\n"
							+ "			    WHEN Age >= 60             THEN\r\n" + "			        '60대 이상'\r\n"
							+ "			END AS AGE_GROUP\r\n" + "		FROM\r\n" + "			(\r\n" + "				SELECT\r\n"
							+ "					User_ID,\r\n" + "					Sex,\r\n" + "					Birth,\r\n"
							+ "					TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),\r\n"
							+ "					                     BIRTH) / 12) AS Age\r\n" + "				FROM\r\n"
							+ "					USERS\r\n" + "			)\r\n" + "	)\r\n" + "GROUP BY\r\n" + "	AGE_GROUP\r\n"
							+ "ORDER BY\r\n" + "	AGE_GROUP ASC";

					try {
						Statement stmt = conn.createStatement();
						rs = stmt.executeQuery(sql);
						while (rs.next()) {
							String groupName = rs.getString(1);
							if (groupName == null) continue;
							int cnt = rs.getInt(2);
							out.println("<div style=\"margin-bottom: 15px; text-align: center;\">");
							out.println("<a style=\"display: inline-block;\">" + groupName + "분포: " + String.valueOf(cnt) + "</a>");
							out.println("</div>");

						}
						rs.close();
						stmt.close();
						JDBCDriver.close(conn);
					} catch (SQLException e) {
						e.printStackTrace();
					}
					%>
				</div>

			</div>
		</section>
	</main>

	<script>
		// JavaScript 코드
		document.getElementById('loginButton').addEventListener('click',
				function() {
					// 클릭 시 이동할 페이지의 URL을 설정
					var newPageURL = ''; // 여기에 이동하고 싶은 페이지의 URL을 입력하세요
					if (document.getElementById('loginNeeded') != null) {
						newPageURL = '/WIF/login-form.jsp';
					} else {
						newPageURL = '/WIF/logout.jsp';
					}

					// 새로운 페이지로 이동
					window.location.href = newPageURL;
				});
		document.getElementById('loginButton2').addEventListener('click',
				function() {
					// 클릭 시 이동할 페이지의 URL을 설정
					var newPageURL = ''; // 여기에 이동하고 싶은 페이지의 URL을 입력하세요
					if (document.getElementById('loginNeeded') != null) {
						newPageURL = '/WIF/login-form.jsp';
					} else {
						newPageURL = '/WIF/logout.jsp';
					}

					// 새로운 페이지로 이동
					window.location.href = newPageURL;
				});
	</script>
</body>

</html>
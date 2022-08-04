<%@ page import="database.entitys.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="database.SQLQuery" %>
<%@ page import="database.query.UserQuery" %><%--
  Created by IntelliJ IDEA.
  User: Вероника
  Date: 19.05.2022
  Time: 18:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String wrong= (String) session.getAttribute("wrlg");
    if(wrong!=null){
        out.println("<script type=\"text/javascript\">");
        out.println("alert('"+wrong+"');");
        out.println("</script>");
        session.setAttribute("wrlg",null);
    }
%>
<% User usr= (User) session.getAttribute("usr");
    User userUp= new SQLQuery().selectAllUser(new UserQuery().select(usr.getUserId())).get(0);
    session.setAttribute("usr",userUp);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User</title>
    <link rel="shortcut icon" href="img/heart_kill_icon.png">
    <link rel="stylesheet" href="css/normalize.css" />
    <link rel="stylesheet" href="css/detection.css" />
    <link rel="stylesheet" href="css/login.css" />
</head>
<body >
<div class="menu-buttons">

    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/UserServlet" ' >Профиль</button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/LearnServlet"' >Обучение </button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/DetectionServlet"' >Распознавание</button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/HistoryServlet"' >История</button>
</div>

<form action="/Emotion_war_exploded/UserServlet?id=<%out.println(userUp.getUserId());%>" method="post">


    <div class="container">
        <label for="login"><b>Логин</b></label>
        <input type="text"  id="login" value="<%out.println(userUp.getUserLogin());%>" required name="login" required>

        <label for="password"><b>Пароль</b></label>
        <input type="password" id="password" value="<%out.println(userUp.getUserPassword());%>" required name="password" required>

    </div>
    <div class="container">
        <label for="description"><b>Описание</b></label>
        <input type="text" id="description" value="<%out.println(userUp.getUserDescription());%>"  name="description" required>


        <button type="submit">Обновить</button>

    </div>
</form>
    <button onClick='location.href="http://localhost:8090/Emotion_war_exploded/hello-servlet"'>Выйти</button>
    <!--<button class="danger-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/DeleteUserServlet?id=<%out.println(userUp.getUserId());%>"'>Delete Profile</button>-->
<button class="danger-button"><a  href="http://localhost:8090/Emotion_war_exploded/DeleteUserServlet?id=<%out.println(userUp.getUserId());%>">Удалить профиль</a></button>
</body>
</html>

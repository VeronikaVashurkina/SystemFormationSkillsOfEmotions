<%--
  Created by IntelliJ IDEA.
  User: Вероника
  Date: 19.05.2022
  Time: 17:59
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
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <link rel="shortcut icon" href="img/heart_kill_icon.png">
  <link rel="stylesheet" href="css/normalize.css" />
  <link rel="stylesheet" href="css/login.css" />
</head>
<body>
<form action="/Emotion_war_exploded/RegistrationServlet" method="post">

  <h1 class="title">Регистрация</h1>

  <div class="container">
    <label for="login"><b>Логин</b></label>
    <input id="login" type="text" placeholder="Введите логин" name="login" required>

    <label for="password"><b>Пароль</b></label>
    <input id="password" type="password" placeholder="Введите пароль" name="password" required>

    <button type="submit" onclick="addUser()">Регистрация</button>

  </div>

  <div class="container" style="background-color:#f1f1f1">
    <span class="registration"> <a href="http://localhost:8090/Emotion_war_exploded/hello-servlet">Вход</a></span>
  </div>
</form>

</body>
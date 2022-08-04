<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Вход</title>
    <link rel="shortcut icon" href="img/heart_kill_icon.png">
    <link rel="stylesheet" href="css/normalize.css" />
    <link rel="stylesheet" href="css/login.css" />
</head>
<body>
<form action="/Emotion_war_exploded/hello-servlet" method="post">

    <h1 class="title">Логин</h1>
    <div class="container">
        <label for="login"><b>Логин</b></label>
        <input id="login" type="text" placeholder="Введите логин" name="login" required>

        <label for="password"><b>Пароль</b></label>
        <input id="password" type="password" placeholder="Введите пароль" name="password" required>

        <button type="submit">Вход</button>

    </div>

    <div class="container" style="background-color:#f1f1f1">
        <span class="registration"> <a  href="Registration.jsp">Регистрация</a></span>
        <!--<span class="psw">Forgot <a href="#">password?</a></span>-->
    </div>
</form>
</body>
</html>
<%@ page import="database.entitys.Emotion" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="database.entitys.User" %>
<%@ page import="database.SQLQuery" %>
<%@ page import="database.query.EmotionQuery" %>
<%@ page import="java.sql.Date" %><%--
  Created by IntelliJ IDEA.
  User: Вероника
  Date: 19.05.2022
  Time: 17:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% User usr = (User) session.getAttribute("usr");
    //List<Emotion> list=(ArrayList)session.getAttribute("All");
    List<Emotion> list = new SQLQuery().selectAllEmotion(new EmotionQuery().selectByUsrId(usr.getUserId()));
    double all = 0;
    double angry = 0;
    double disgust = 0;
    double fear = 0;
    double happy = 0;
    double neutral = 0;
    double sad = 0;
    double surprise = 0;
    for (int i = 0; i < list.size(); i++) {
        all++;
        if (list.get(i).getEmotionName().equals("злость")) {
            angry++;
        }
        if (list.get(i).getEmotionName().equals("отвращение")) {
            disgust++;
        }
        if (list.get(i).getEmotionName().equals("страх")) {
            fear++;
        }
        if (list.get(i).getEmotionName().equals("счастье")) {
            happy++;
        }
        if (list.get(i).getEmotionName().equals("нейтральное выражение")) {
            neutral++;
        }
        if (list.get(i).getEmotionName().equals("грусть")) {
            sad++;
        }
        if (list.get(i).getEmotionName().equals("удивление")) {
            surprise++;
        }
    }


%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>History</title>
    <link rel="shortcut icon" href="img/heart_kill_icon.png">
    <link rel="stylesheet" href="css/normalize.css"/>
    <link rel="stylesheet" href="css/detection.css"/>
    <link rel="stylesheet" href="css/table.css"/>
    <script src="https://www.google.com/jsapi"></script>
    <script>
        google.load("visualization", "1", {packages: ["corechart"]});
        google.setOnLoadCallback(drawChart);

        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                ['Эмоция', 'Процент'],
                ['Злость', <%out.println(angry/all*100);%>],
                ['Отвращение', <%out.println(disgust/all*100);%>],
                ['Страх', <%out.println(fear/all*100);%>],
                ['Счастье', <%out.println(happy/all*100);%>],
                ['Нейтральное выражение', <%out.println(neutral/all*100);%>],
                ['Грусть', <%out.println(sad/all*100);%>],
                ['Удивление', <%out.println(surprise/all*100);%>]
            ]);
            var options = {
                title: 'Ваши эмоции',
                is3D: true,
                pieResidueSliceLabel: ''
            };
            var chart = new google.visualization.PieChart(document.getElementById('air'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>
<div class="menu-buttons">

    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/UserServlet" ' >Профиль</button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/LearnServlet"' >Обучение </button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/DetectionServlet"' >Распознавание</button>
    <button class="menu-button" onClick='location.href="http://localhost:8090/Emotion_war_exploded/HistoryServlet"' >История</button>
</div>
<div class="content">
    <div id="air" style="width: 500px; height: 400px;"></div>
    <!--
<div class="calendar" id="month-calendar">
    <ul class="month">
        <li class="prev"><i class="fas fa-angle-double-left"></i></li>
        <li class="next"><i class="fas fa-angle-double-right"></i></li>
        <li class="month-name"></li>
        <li class="year-name"></li>
    </ul>
    <ul class="weekdays">
        <li>Пн</li>
        <li>Вт</li>
        <li>Ср</li>
        <li>Чт</li>
        <li>Пт</li>
        <li>Сб</li>
        <li>Вс</li>
    </ul>
    <ul class="days">
    </ul>
</div>
-->
    <%
       /* out.println("<p id=\"description-emotions\">");
        List<String> dates = new SQLQuery().selectDate(new EmotionQuery().selectDate());
        for (int i = 0; i < dates.size(); i++) {
            out.println("Date: <br>");
            out.println("        " + dates.get(i) + "<br>");
            out.println("Emotion: <br>");
            for (int j = 0; j < list.size(); j++) {
                if (list.get(j).getDate().equals(dates.get(i))) ;
                {
                    out.println("        " + list.get(j).getEmotionName() + ", <br>");
                }
            }
        }
        out.println("</p>");

        */
    %>


    <table class="table">
        <tr>
            <th>  Дата  </th>
            <th>Эмоции(я)</th>

        </tr>

        <%
            List<String> dates = new SQLQuery().selectDate(new EmotionQuery().selectDate());
            for (int i = 0; i < dates.size(); i++) {
                out.println("<tr> " + "<td>" + dates.get(i) + "</td>");
                List<Emotion> emotionList = new SQLQuery().selectAllEmotion(new EmotionQuery().selectByUniqueDateAndId(Date.valueOf(dates.get(i)),list.get(0).getUserId()));
                String str="";
                for (int j = 0; j < emotionList.size(); j++) {

                        str+=emotionList.get(j).getEmotionName()+" ";

                }
                out.println("<td>" + str + "</td>" +
                        "</tr>"
                );

            }
        %>

    </table>


</div>
<script>
    <%//for(int i=0;i< list.size();i++){
      //  out.println("let mas = [][]");
        //List<Emotion> list1=new SQLQuery().selectAllEmotion(new EmotionQuery().selectByDateAndId(list.get(i).getDate(),list.get(i).getUserId()));
       // String emotions=list.get(i).getDate().toString().replace('-','.');
       // out.println("mas["+i+"][0]='"+emotions+"'");
      //  for(int j=1;j< list1.size();j++){
      //      out.println("mas["+i+"]["+j+"]='"+list1.get(i).getEmotionName()+"'");
       // }
    //}%>

    function getEmotionsOnDate(text) {
        var str
        for (var i = 0; i < mas.lenght; i++) {
            if (text === mas[i][0]) {
                for (var j = 0; j < mas[i].lenght; j++) {
                    str += mas[i][j] + ", \n";
                }
                document.getElementById("description-emotions").innerHTML = str;
            }

        }
        // document.getElementById("description-emotions").innerText = str;
    }

    //document.getElementById("description-emotions").innerHTML = "а вот и текст)))))))))))))))))))))))";
</script>

</body>
</html>
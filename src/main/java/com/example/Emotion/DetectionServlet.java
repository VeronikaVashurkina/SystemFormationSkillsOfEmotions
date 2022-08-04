package com.example.Emotion;

import database.SQLQuery;
import database.entitys.Emotion;
import database.query.EmotionQuery;



import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@WebServlet(name = "DetectionServlet", value = "/DetectionServlet")
public class DetectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        RequestDispatcher rd = request.getRequestDispatcher("/Detection.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String emot = request.getParameter("emotion");
        ArrayList<Emotion> emotions = null;
        try {
            emotions = new SQLQuery().selectAllEmotion(new EmotionQuery().selectAll());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        int id = Integer.parseInt(request.getParameter("id"));
        Emotion emotion = null;
        if (emotions.size() == 0) {  emotion = new Emotion(0,emot,new Date(Calendar.getInstance().getTimeInMillis()),id);}
        else {
            try {
                 emotion = new Emotion(getId()+1,emot,new Date(Calendar.getInstance().getTimeInMillis()),id);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
        try {
            new SQLQuery().insert(new EmotionQuery().insert(emotion.getEmotionId(),emotion.getEmotionName(),emotion.getDate(),emotion.getUserId()));
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.sendRedirect("/Emotion_war_exploded/DetectionServlet");
    }
    protected int getId() throws ClassNotFoundException {
        List<Emotion> list=new SQLQuery().selectAllEmotion(new EmotionQuery().selectAll());
        int max=0;
        for (Emotion item : list){
            int number=item.getEmotionId();
            if(number>max)max=number;
        }
        return max;
    }
}

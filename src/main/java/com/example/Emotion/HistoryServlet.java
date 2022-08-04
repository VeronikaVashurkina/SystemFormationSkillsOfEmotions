package com.example.Emotion;

import database.SQLQuery;
import database.query.EmotionQuery;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "HistoryServlet", value = "/HistoryServlet")
public class HistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ///request.setAttribute("All", new SQLQuery().selectAllEmotion(new EmotionQuery().selectAll()));
        //request.getSession().setAttribute("All", new SQLQuery().selectAllEmotion(new EmotionQuery().selectAll()));
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        RequestDispatcher rd = request.getRequestDispatcher("/History.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
    }
}

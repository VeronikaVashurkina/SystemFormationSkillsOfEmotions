package com.example.Emotion;

import database.SQLQuery;
import database.entitys.User;
import database.query.UserQuery;

import java.io.*;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    private boolean isWrong = false;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (isWrong) {
            request.setAttribute("wrlg", "Неправильный логин или пароль");
            request.getSession().setAttribute("wrlg", "Неправильный логин или пароль");
            isWrong=false;

        }
        RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
        rd.forward(request, response);


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            String login = request.getParameter("login");
            String password = request.getParameter("password");
            ArrayList<User> user = new SQLQuery().selectAllUser(new UserQuery().selectAll());
            if (user.size() != 0) {
                for (int i = 0; i < user.size(); i++) {
                    if ((user.get(i).getUserLogin().equals(login)) && (user.get(i).getUserPassword().equals(password))) {
                        User userLogin = user.get(i);
                        request.setAttribute("usr", userLogin);
                        request.getSession().setAttribute("usr", userLogin);
                        isWrong=false;
                        response.sendRedirect("/Emotion_war_exploded/UserServlet");
                        return;
                    } else {
                        isWrong = true;


                    }

                }
                response.sendRedirect("/Emotion_war_exploded/hello-servlet");
            } else {
                isWrong = true;
                response.sendRedirect("/Emotion_war_exploded/hello-servlet");
            }


        } catch (
                Exception e) {
            request.setAttribute("err", e.getMessage());
            doGet(request, response);
        }
    }


}
package com.example.Emotion;

import database.SQLQuery;
import database.entitys.User;
import database.query.UserQuery;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RegistrationServlet", value = "/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    private boolean isWrong = false;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (isWrong) {
            request.setAttribute("wrlg", "Этот логин уже зарегистрирован в системе");
            request.getSession().setAttribute("wrlg", "Этот логин уже зарегистрирован в системе");
            isWrong=false;

        }
        RequestDispatcher rd = request.getRequestDispatcher("/Registration.jsp");
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
                    if ((user.get(i).getUserLogin().equals(login))) {
                        isWrong = true;
                        response.sendRedirect("/Emotion_war_exploded/RegistrationServlet");
                        return;
                    }
                }
                if(!isWrong) {

                    User user1 = new User(getId() + 1, login, password, "");
                    new SQLQuery().insert(new UserQuery().insert(user1.getUserId(), user1.getUserLogin(), user1.getUserPassword(), user1.getUserDescription()));
                    response.sendRedirect("/Emotion_war_exploded/hello-servlet");
                    return;
                }
            } else {

                User user1 = new User(0, login, password,"");
                new SQLQuery().insert(new UserQuery().insert(user1.getUserId(),user1.getUserLogin(),user1.getUserPassword(),user1.getUserDescription()));
                response.sendRedirect("/Emotion_war_exploded/hello-servlet");
            }


        } catch (
                Exception e) {
            request.setAttribute("err", e.getMessage());
            doGet(request, response);
        }
    }
    protected int getId() throws ClassNotFoundException {
        List<User> list=(ArrayList)new SQLQuery().selectAllUser(new UserQuery().selectAll());
        int max=0;
        for (User item : list){
            int number=item.getUserId();
            if(number>max)max=number;
        }
        return max;
    }
    }


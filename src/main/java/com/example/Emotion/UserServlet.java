package com.example.Emotion;

import database.SQLQuery;
import database.entitys.User;
import database.query.UserQuery;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "UserServlet", value = "/UserServlet")
public class UserServlet extends HttpServlet {
    private boolean isWrong = false;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (isWrong) {
            request.setAttribute("wrlg", "Этот логин уже зарегистрирован в системе");
            request.getSession().setAttribute("wrlg", "Этот логин уже зарегистрирован в системе");

        }

        RequestDispatcher rd = request.getRequestDispatcher("/User.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            String login = request.getParameter("login");
            String password = request.getParameter("password");
            String description = request.getParameter("description");
            int id = Integer.parseInt(request.getParameter("id"));
            ArrayList<User> user = new SQLQuery().selectAllUser(new UserQuery().select(id));
            if (user.get(0).getUserLogin().equals(login)) {
                new SQLQuery().update(new UserQuery().update(user.get(0).getUserId(), login, password, description));

            } else {
                ArrayList<User> users = new SQLQuery().selectAllUser(new UserQuery().selectAll());
                for (int i = 0; i < users.size(); i++) {
                    if ((users.get(i).getUserLogin().equals(login))) {
                        isWrong = true;

                    } else {
                        new SQLQuery().update(new UserQuery().update(user.get(0).getUserId(), login, password, description));

                    }
                }
            }
            response.sendRedirect("/Emotion_war_exploded/UserServlet");
        } catch (
                Exception e) {
            request.setAttribute("err", e.getMessage());
            try {
                doGet(request, response);
            } catch (Exception exception) {
                exception.printStackTrace();
            }
        }
    }
}

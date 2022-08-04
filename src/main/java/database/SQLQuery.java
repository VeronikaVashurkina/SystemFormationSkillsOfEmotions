package database;

import database.entitys.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public  class SQLQuery {

    private static Properties properties = new Properties();
    private static String url;
    private static String user;
    private static String password;

    public SQLQuery() throws ClassNotFoundException {
        try (FileInputStream in = new FileInputStream("C:\\Users\\Вероника\\Desktop\\8 семак\\kursovicWEB\\курсач\\TomCat\\src\\main\\resources\\application.properties")) {
            properties.load(in);
            url = properties.getProperty("jdbc.url");
            user = properties.getProperty("jdbc.user");
            password = properties.getProperty("jdbc.password");
            url="jdbc:postgresql://localhost:5432/EmotionDATA";
            Class.forName("org.postgresql.Driver");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void insert(String sql)  {
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement();) {
            statement.executeUpdate(sql);

            connection.setAutoCommit(false);
            connection.commit();

        } catch (Exception e) {
            System.out.println(e);

        }
    }

    //selects /////////////////////

    public static ArrayList<User> selectAllUser(String sql)  {
        ArrayList<User> records = new ArrayList<User>();
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {
            while (resultSet.next()) {
                int newUserId = resultSet.getInt("usr_id");
                String newLogin = resultSet.getString("login");
                String newPassword = resultSet.getString("password");
                String newDescription = resultSet.getString("description");
                User record = new User(newUserId,newLogin,newPassword,newDescription);
                records.add(record);
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return records;
    }

    public static ArrayList<Emotion> selectAllEmotion(String sql)  {
        ArrayList<Emotion> records = new ArrayList<Emotion>();
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql);) {
            while (resultSet.next()) {
                int newEmotionId = resultSet.getInt("emotion_id");
                String newName = resultSet.getString("emotion_name");
                Date  newDate = resultSet.getDate("date");
                int newUserId = resultSet.getInt("usr_id");
                Emotion record = new Emotion(newEmotionId,newName,newDate,newUserId);
                records.add(record);
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return records;
    }

    public static List<String> selectDate(String sql)  {
        List<String> list=new ArrayList<>();
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql);) {
            while (resultSet.next()) {
                Date  newDate = resultSet.getDate("date");
                list.add(newDate.toString());
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public static void update(String sql)  {
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement()) {
            connection.setAutoCommit(false);
            statement.executeUpdate(sql);
            connection.commit();

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static void delete(String sql)  {
        try (Connection connection = DriverManager
                .getConnection(url, user, password);
             Statement statement = connection.createStatement()
        ) {
            statement.executeUpdate(sql);
            connection.setAutoCommit(false);
            connection.commit();


        } catch (Exception e) {
            System.out.println(e);
        }
    }




}
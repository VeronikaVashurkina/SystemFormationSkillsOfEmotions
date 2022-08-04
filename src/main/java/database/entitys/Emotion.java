package database.entitys;

import java.sql.Date;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Emotion {
    private int emotionId;
    private String emotionName;
    private Date date;
    private int userId;

    public Emotion(int emotionId, String emotionName, Date date, int userId) {
        this.emotionId = emotionId;
        this.emotionName = emotionName;
        this.date = date;
        this.userId = userId;
    }

    public Emotion(int emotionId, String emotionName, String date, int userId) throws ParseException {
        this.emotionId = emotionId;
        this.emotionName = emotionName;
        SimpleDateFormat format = new SimpleDateFormat();
        // format.applyPattern("dd.MM.yyyy");
        format.applyPattern("yyyy.MM.dd");
        this.date = (Date) format.parse(date);
        this.userId = userId;

    }

    public int getEmotionId() {
        return emotionId;
    }

    public void setEmotionId(int emotionId) {
        this.emotionId = emotionId;
    }

    public String getEmotionName() {
        return emotionName;
    }

    public void setEmotionName(String emotionName) {
        this.emotionName = emotionName;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}

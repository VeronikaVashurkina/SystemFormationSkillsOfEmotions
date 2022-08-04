package database.query;

import java.sql.Date;

public class EmotionQuery {
    public String delete(int emotionId) {
        return "delete from emotion where emotion_id =" + emotionId;
    }

    public String select(int emotionId) {
        return "select * from emotion where emotion_id =" + emotionId;
    }
    public String selectByUsrId(int usrId) {
        return "select * from emotion where usr_id =" + usrId;
    }
    public String selectByDate(Date date) {
        return "select * from emotion where date = '" + date+"'";
    }
    public String selectByUniqueDateAndId(Date date,int usrId) {
        return "select * from emotion where date = '" + date+"' and usr_id =" + usrId;
    }
    public String selectDate() {
        return "select distinct date from emotion";
    }
    public String selectAll(){return "select * from emotion";}

    public String insert(int emotionId, String name, Date date, int usrId) {
        return "insert into emotion values ('" + emotionId + "', '" + name + "', '" + date  +  "', '" + usrId+"');";
    }
    public String update(int emotionId, String name, Date date, int usrId){
        return "update emotion set emotion_name= '"+name+"' where emotion_id= '"+emotionId+"' ;"+
                "update emotion set usr_id= '"+usrId+"' where emotion_id= '"+emotionId+"' ;"+
                "update emotion set date= '"+date+"' where emotion_id= '"+emotionId+"' ;";
    }
}


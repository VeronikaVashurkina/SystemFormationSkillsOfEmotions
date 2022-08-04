package database.query;

public class UserQuery {

    public String delete(int usrId) {
        return "delete from usr where usr_id =" + usrId;
    }

    public String select(int usrId) {
        return "select * from usr where usr_id =" + usrId;
    }

    public String selectFromLogin(String login) {
        return "select * from usr where login =" + login;
    }

    public String selectAll(){return "select * from usr";}
    public String insert(int usrId, String userLogin, String userPassword, String userDescription) {
        return "insert into usr values ('" + usrId + "', '" + userLogin + "', '" + userPassword + "', '" + userDescription + "');";
    }
public String update(int usrId, String userLogin, String userPassword, String userDescription){
    return "update usr set login= '"+userLogin+"' where usr_id= '"+usrId+"' ;"+
            "update usr set password= '"+userPassword+"' where usr_id= '"+usrId+"' ;"+
            "update usr set description= '"+userDescription+"' where usr_id= '"+usrId+"' ;";
}
}

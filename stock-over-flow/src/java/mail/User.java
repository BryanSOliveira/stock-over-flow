package mail;


public class User {
    String userName;
    String userEmail;
    String userToken;

    public User() {
    }

    public User(String userName, String userEmail, String userToken) {
        this.userName = userName;
        this.userEmail = userEmail;
        this.userToken = userToken;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserToken() {
        return userToken;
    }

    public void setUserToken(String userToken) {
        this.userToken = userToken;
    }
    
}

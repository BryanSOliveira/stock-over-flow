/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mail;

/**
 *
 * @author K4mi
 */
public class mailUser {
    String userName;
    String userEmail;
    String userToken;

    public mailUser() {
    }

    public mailUser(String userName, String userEmail, String userToken) {
        this.userName = userName;
        this.userEmail = userEmail;
        this.userToken = userToken;
    }

    public String getMailUserName() {
        return userName;
    }

    public void setMailUserName(String userName) {
        this.userName = userName;
    }

    public String getMailUserEmail() {
        return userEmail;
    }

    public void setMailUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getMailUserToken() {
        return userToken;
    }

    public void setMailUserToken(String userToken) {
        this.userToken = userToken;
    }
    
}

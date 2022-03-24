package mail;

import java.util.Properties;
import java.util.Random;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendEmail {
    public String genToken() {
        Random token = new Random();
        int tokenNumber = token.nextInt(99999999);
        return String.format("%08d", tokenNumber);
    }

    public boolean sendEmail(User regUser) {
        boolean verifiedStatus = false;

        String regEmail = regUser.getUserEmail();
        final String botEmail = "stock.overflow.verify@gmail.com";
        final String botPassword = "overflowadmin";

        try {

            Properties mailSettings = new Properties();
            mailSettings.setProperty("mail.smtp.host", "smtp.gmail.com");
            mailSettings.setProperty("mail.smtp.port", "587");
            mailSettings.setProperty("mail.smtp.auth", "true");
            mailSettings.setProperty("mail.smtp.starttls.enable", "true");
            mailSettings.put("mail.smtp.socketFactory.port", "587");
            mailSettings.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
 
            Session regSession = Session.getInstance(mailSettings, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(botEmail, botPassword);
                }
            });

            Message emailMessage = new MimeMessage(regSession);

 
            emailMessage.setFrom(new InternetAddress(botEmail));

            emailMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(regEmail));
            emailMessage.setSubject("Confirmação de Email");
            emailMessage.setText("Detectamos uma tentativa de registro em nosso site com esse email. \nSe foi você use este codigo de verificação: " + regUser.getUserToken());
            
            Transport.send(emailMessage);
            
            
            verifiedStatus = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return verifiedStatus;
    }
}
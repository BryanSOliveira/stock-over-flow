package mail;



import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author K4mi
 */
public class VerifyUser extends HttpServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
           String userName = request.getParameter("targetUserName");
           String userEmail = request.getParameter("targetUserEmail");
           
           SendEmail mailInstance = new SendEmail();
      	
           String userToken = mailInstance.genToken();
           
           User verifyUser = new User(userName, userEmail, userToken);
           boolean emailSent = mailInstance.sendEmail(verifyUser);
           
           
           if(emailSent){
               HttpSession verifySession  = request.getSession();
               verifySession.setAttribute("authUser", verifyUser);
               response.sendRedirect("account-verify.jsp");
           }else{
      		  out.println("Houve uma falha ao enviar o codigo de verificação para seu email");
      	   }
           
        }
    }

   
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}
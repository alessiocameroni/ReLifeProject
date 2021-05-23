package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "feedServlet", value = "/feed-servlet")
@MultipartConfig(fileSizeThreshold = 512000, maxFileSize = 512000, maxRequestSize = 516000)
public class FeedServlet extends HttpServlet {
    static String errorString;

    public void init() {
        DbUtility dub = DbUtility.getInstance(getServletContext());
        dub.setDevCredentials("jdbc:mariadb://localhost:3306/dbReLife?maxPoolSize=2&pool", "root", "");
    }

    //      doGet and doPost

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String azione = request.getParameter("azione");
        System.out.println(azione);

        if(azione == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (azione) {
            case "createComment":
                break;
            case "createPost":
                createPost(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    //      Load comments function
    private void loadComments(HttpServletRequest request, HttpServletResponse response) throws IOException {

    }

    //      Create post function
    private void createPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession sessione = request.getSession(false);
        String nomeCompleto = (String) sessione.getAttribute("nomecompleto");
        String[] arrNome = nomeCompleto.split(" ");

        String username = arrNome[0];
        String[] postDateTime = getDateTime().split(" ");
        Part img = null;

        try {
            img = request.getPart("inputImage");
        } catch (IllegalStateException | ServletException e) {
            errorString = "La dimensione dell'immagine supera il limite. Riprovare.";
            String link = String.format("%s/createPost.jsp?errore=%s", request.getContextPath(), errorString);
            response.sendRedirect(link);
        }

        ServletContext ctx = request.getServletContext();
        String nomeFile = extractFileName(img);
        String tipo = ctx.getMimeType(nomeFile);

        DbUtility dub = DbUtility.getInstance(getServletContext());
        String url = dub.getUrl();
        String user = dub.getUser();
        String password = dub.getPassword();

        try (Connection con = DriverManager.getConnection(url, user, password)) {
            String strSql = "CALL addPost (?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(strSql)) {
                ps.setString(1, postDateTime[0]);
                ps.setString(2, postDateTime[1]);
                ps.setBinaryStream(3, img.getInputStream());
                ps.setString(4, tipo);
                ps.setString(5, username);

                ps.executeUpdate();

                response.sendRedirect("feed.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();

            errorString = "Errore con il caricamento del file. Riprovare.";
            String link = String.format("%s/createPost.jsp?errore=%s", request.getContextPath(), errorString);
            response.sendRedirect(link);
        }
    }

    //      Extra functions
    //      Returns current time and date
    private String getDateTime() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm");
        LocalDateTime now = LocalDateTime.now();

        String postDateTime = dtf.format(now);

        return postDateTime;
    }

    //      Extracts the name from the Part uploaded
    private static String extractFileName(Part part) {
         for (String cd : part.getHeader("content-disposition").split(";")) {
             if (cd.trim().startsWith("filename")) {
                 String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                 return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
             }
         }

         return null;
    }
}

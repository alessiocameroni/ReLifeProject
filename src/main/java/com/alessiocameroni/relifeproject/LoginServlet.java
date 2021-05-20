package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import java.io.*;
import java.sql.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "loginServlet", value = "/login-servlet")
public class LoginServlet extends HttpServlet {

    public void init() {
        DbUtility dub = DbUtility.getInstance(getServletContext());
        dub.setDevCredentials("jdbc:mariadb://localhost:3306/dbReLife?maxPoolSize=2&pool", "root", "");
    }

    //      doGet and doPost

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        executeLogin(request, response);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        executeLogout(request, response);
    }

    //      Login function

    private void executeLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession sessione = request.getSession(false);

        if(sessione != null && sessione.getAttribute("nomecompleto") != null) {
            response.sendRedirect("catalog.jsp");
            return;
        }

        String tbUsername = request.getParameter("tbUsername");
        String tbPassword = request.getParameter("tbPassword");

        DbUtility dub = DbUtility.getInstance(getServletContext());
        String url = dub.getUrl();
        String user = dub.getUser();
        String password = dub.getPassword();

        try (Connection con = DriverManager.getConnection(url, user, password)) {
            String strSql = "SELECT username, nome FROM siteUser WHERE username = ? AND SHA2(CONCAT(salt, ?), 256) = password_hash";

            try (PreparedStatement ps = con.prepareStatement(strSql)) {
                ps.setString(1, tbUsername);
                ps.setString(2, tbPassword);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String username = rs.getString("username");
                    String nome = rs.getString("nome");
                    String nomeCompleto = String.format("%s %s", username, nome);

                    sessione = request.getSession(true);
                    sessione.setAttribute("nomecompleto", nomeCompleto);
                    sessione.setMaxInactiveInterval(30 * 60);

                    response.sendRedirect("catalog.jsp");
                } else {
                    String link = String.format("%s/login.jsp?errore=errore", request.getContextPath());
                    response.sendRedirect(link);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //      Logout function

    private void executeLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String nc = (String) session.getAttribute("nomecompleto");

        if (nc != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath());
    }

    public void destroy() {
    }
}
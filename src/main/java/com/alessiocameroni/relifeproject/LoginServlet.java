package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletContext;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "loginServlet", value = "/login-servlet")
public class LoginServlet extends HttpServlet {
    static String errorString;

    //      doGet and doPost

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String azione = request.getParameter("azione");

        if(azione == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (azione) {
            case "login":
                executeLogin(request, response);
                break;
            case "create":
                createAccount(request, response);
                break;
            case "changePwd":
                changePassword(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
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

        ServletContext ctx = request.getServletContext();
        DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");
        try (Connection con = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword())) {
            String strSql = "SELECT username, nome, cognome FROM siteUser WHERE username = ? AND SHA2(CONCAT(salt, ?), 256) = password_hash";

            try (PreparedStatement ps = con.prepareStatement(strSql)) {
                ps.setString(1, tbUsername);
                ps.setString(2, tbPassword);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String username = rs.getString("username");
                    String nome = rs.getString("nome");
                    String cognome = rs.getString("cognome");
                    String nomeCompleto = String.format("%s %s %s", username, cognome, nome);

                    sessione = request.getSession(true);
                    sessione.setAttribute("nomecompleto", nomeCompleto);
                    sessione.setMaxInactiveInterval(30 * 60);

                    response.sendRedirect("feed.jsp");
                } else {
                    errorString = "Username e/o password sbagliati. Riprovare.";
                    String link = String.format("%s/login.jsp?errore=%s", request.getContextPath(), errorString);
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

    //      Account creation functions
    private void createAccount (HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nome = request.getParameter("tbName");
        String cognome = request.getParameter("tbSurname");
        String username =  request.getParameter("tbUsername").toLowerCase();
        String luogo = request.getParameter("tbPlace");
        String pwd = request.getParameter("tbPassword");
        String pwdCheck = request.getParameter("tbConfirmPassword");

        if(checkPwd(pwd, pwdCheck)) {
            if(addToDatabase(request, nome, cognome, username, luogo, pwd)) {
                response.sendRedirect("login.jsp");
            } else {
                errorString = "Errore nella creazione dell account. Riprovare.";
                String link = String.format("%s/createAccount.jsp?errore=%s", request.getContextPath(), errorString);
                response.sendRedirect(link);
            }
        } else {
            errorString = "Le password non sono uguali. Riprovare.";
            String link = String.format("%s/createAccount.jsp?errore=%s", request.getContextPath(), errorString);
            response.sendRedirect(link);
        }
    }

        //      DB Handling
        private boolean addToDatabase(HttpServletRequest request, String nome, String cognome, String username, String luogo, String pwd) {
            boolean check = false;

            ServletContext ctx = request.getServletContext();
            DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");
            try (Connection con = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword())) {
                String strSql = "CALL addUser (?, ?, ?, ?, ?)";

                try (PreparedStatement ps = con.prepareStatement(strSql)) {
                    ps.setString(1, username);
                    ps.setString(2, pwd);
                    ps.setString(3, nome);
                    ps.setString(4, cognome);
                    ps.setString(5, luogo);

                    int rows = ps.executeUpdate();

                    if (rows != 0) {
                        check = true;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            return check;
        }

    //      Password change functions
    private void changePassword (HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html; charset=UTF-8");

        String username = request.getParameter("tbUsername").toLowerCase();
        boolean checkName = checkName(username);

        PrintWriter out = response.getWriter();

        if(checkName) {
            String pwd = request.getParameter("tbNewPassword");
            String pwdCheck = request.getParameter("tbConfirmPassword");

            if(checkPwd(pwd, pwdCheck)) {
                changePwd(request, username, pwd);

                response.sendRedirect("login.jsp");
            } else {
                errorString = "Le password non sono uguali. Riprovare.";
                String link = String.format("%s/forgotPassword.jsp?errore=%s", request.getContextPath(), errorString);
                response.sendRedirect(link);
            }
        } else {
            errorString = "Non esiste un utente con questo username.";
            String link = String.format("%s/forgotPassword.jsp?errore=%s", request.getContextPath(), errorString);
            response.sendRedirect(link);
        }
    }

        //      DB handling
        private void changePwd(HttpServletRequest request, String username, String pw1) {
            ServletContext ctx = request.getServletContext();
            DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");
            try (Connection con = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword())) {
                String strSql = "CALL siteUser_change_pwd (?, ?) ";

                try (PreparedStatement ps = con.prepareStatement(strSql)) {
                    ps.setString(1, username);
                    ps.setString(2, pw1);

                    ps.executeUpdate();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        //      Checks
        private boolean checkName (String username) {
            boolean check = false;

            DbUtility dub = DbUtility.getInstance(getServletContext());
            String url = dub.getUrl();
            String user = dub.getUser();
            String password = dub.getPassword();

            try (Connection con = DriverManager.getConnection(url, user, password)) {
                String strSql = "SELECT username FROM siteUser WHERE username = ?";

                try (PreparedStatement ps = con.prepareStatement(strSql)) {
                    ps.setString(1, username);

                    ResultSet rs = ps.executeQuery();

                    if(rs.next()) {
                        return true;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            return check;
        }

        private boolean checkPwd(String pw1, String pw2) {
            if (pw1.equals(pw2)) {
                return true;
            } else {
                return false;
            }
        }

    public void destroy() {
    }
}
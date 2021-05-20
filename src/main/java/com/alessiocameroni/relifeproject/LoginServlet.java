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

    //      Account creation functions
    private void createAccount (HttpServletRequest request, HttpServletResponse response) throws IOException {

    }

    //      Password change functions
    private void changePassword (HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html; charset=UTF-8");

        String username = request.getParameter("tbUsername");
        boolean checkName = checkName(username);

        PrintWriter out = response.getWriter();

        if(checkName) {
            String pwd1 = request.getParameter("tbPwd1");
            String pwd2 = request.getParameter("tbPwd2");

            if(checkPwd(pwd1, pwd2)) {
                changePwd(username, pwd1);

                response.sendRedirect("login.jsp");
            } else {
                String toast = "Le password inserite non sono uguali, riprovare";
                wrongInputOutput(out, toast);
            }
        } else {
            String toast = "Questo utente non esiste";
            wrongInputOutput(out, toast);
        }
    }

        //      DB handling
        private void changePwd(String username, String pw1) {
            DbUtility dub = DbUtility.getInstance(getServletContext());
            String url = dub.getUrl();
            String user = dub.getUser();
            String password = dub.getPassword();

            try (Connection con = DriverManager.getConnection(url, user, password)) {
                //TODO Cambia database e crea metodo
                String strSql = "CALL musicshop_change_pwd (?, ?) ";

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
                //TODO Cambia query SQL
                String strSql = "SELECT username FROM musicshop_users WHERE username = ?";

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

        //      Output
        private void wrongInputOutput (PrintWriter out, String toast) {
            //TODO Cambia tipo di response, rimuovi output codice HTML
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Login - Revolution Music</title>");
            out.println("<link rel='stylesheet' href='resources/css/login-style.css'/>");
            out.println("<link rel='stylesheet' href='https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined'>");
            out.println("<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css'>");
            out.println("<link rel='preconnect' href='https://fonts.gstatic.com'>");
            out.println("<script src = 'https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>");
            out.println("<script src ='https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/js/materialize.min.js'></script>");
            out.println("</head>");

            out.println("<body>");
            out.println("<script>M.toast({html: '" + toast + "', classes: 'rounded'})</script>");
            out.println("<main>");
            out.println("<div class='fullscreen-bg'>");
            out.println("<video autoplay muted loop class='fullscreen-bg__video'>");
            out.println("<source src='resources/video/bg-video.mp4' type='video/mp4'>");
            out.println("</video>");
            out.println("</div>");

            out.println("<div id='container'>");
            out.println("<div id='left-side'>");
            out.println("<div id='logo'></div>");
            out.println("</div>");

            out.println("<div id='right-side'>");
            out.println("<div id='form'>");
            out.println("<h3><b>Cambia password</b></h3>");

            out.println("<div class='spacer-tiny'></div>");

            out.println("<form action='pwd-servlet' method='POST'>");
            out.println("<div class='input-field'>");
            out.println("<input id='username' name='tbUsername' type='text' class='validate' required>");
            out.println("<label for='username'>Nome utente</label>");
            out.println("</div>");

            out.println("<div class='input-field'>");
            out.println("<input id='pwd1' name='tbPwd1' type='password' class='validate' required>");
            out.println("<label for='pwd1'>Nuova password</label>");
            out.println("</div>");

            out.println("<div class='input-field'>");
            out.println("<input id='pwd2' name='tbPwd2' type='password' class='validate' required>");
            out.println("<label for='pwd2'>Conferma</label>");
            out.println("</div>");

            out.println("<div class='right-content'>");
            out.println("<a href='login.jsp' class='back-btn waves-effect btn-large btn-flat round z-depth-0'>");
            out.println("<i class='material-icons-outlined left'>arrow_back</i>");
            out.println("Torna indietro");
            out.println("</a>");

            out.println("<button type='submit' class='waves-effect waves-light btn-large round black z-depth-0'>");
            out.println("<i class='material-icons-outlined left'>check</i>");
            out.println("Conferma");
            out.println("</button>");
            out.println("</div>");
            out.println("</form>");
            out.println("</div>");
            out.println("</div>");
            out.println("</div>");
            out.println("</main>");

            out.println("<footer class='page-footer'>");
            out.println("<div class='footer-div'>");
            out.println("Sito creato a scopo didattico<br>");
            out.println("ITT Fauser | Cameroni Alessio - 2020/2021");
            out.println("</div>");
            out.println("</footer>");
            out.println("</body>");
            out.println("</html>");
        }

    public void destroy() {
    }
}
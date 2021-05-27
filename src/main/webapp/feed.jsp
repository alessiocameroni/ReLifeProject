<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.Console" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Feed - ReLife</title>
        <link rel="stylesheet" href="resources/css/style-feed.css"/>
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src ="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/js/materialize.min.js"></script>

        <script>
            $(document).ready(function() {
                $('.dropdown-trigger').dropdown();
                $('.materialboxed').materialbox();
                $('.tooltipped').tooltip();
                $('.fixed-action-btn').floatingActionButton();
            });
        </script>
    </head>

    <body>
        <%
            HttpSession sessione = request.getSession(false);
            String nomeCompleto = (String) sessione.getAttribute("nomecompleto");

            if(nomeCompleto == null) {
                response.sendRedirect("index.jsp");
            }

            String[] arrNome = nomeCompleto.split(" ");
            String nomeUtente = arrNome[1] + " " + arrNome[2];
        %>
        <div class="fixed-action-btn">
            <a class="btn-floating btn-large waves-effect waves-light btn-upload tooltipped" data-position="left" data-tooltip="Azioni">
                <i class="material-icons-outlined">add</i>
            </a>
            <ul>
                <li><a href="showUsers.jsp" class="btn-floating blue darken-2 tooltipped" data-position="left" data-tooltip="Mostra utenti"><i class="material-icons-outlined">people</i></a></li>
                <li><a href="createPost.jsp" class="btn-floating blue darken-4 tooltipped" data-position="left" data-tooltip="Carica post"><i class="material-icons-outlined">publish</i></a></li>
            </ul>
        </div>

        <main>
            <div class="navbar-fixed">
                <nav class="z-depth-0">
                    <div class="nav-wrapper">
                        <div id="logo-navbar" class="brand-logo">
                            <object id="logoSvg" data="resources/img/svg/logo-gr-txt-wh.svg" width="100em" height="64em"></object>
                        </div>
                        <div id="pageTitle" class="brand-logo center">
                            <h5>Home</h5>
                        </div>
                        <ul id="nav-mobile" class="right hide-on-med-and-down">
                            <li>
                                <a id="account-link" class="dropdown-trigger tooltipped" href="login-servlet" data-target="account-dropdown" data-position="left" data-tooltip="<%=nomeUtente%>">
                                    <i class="material-icons-outlined">account_circle</i>
                                </a>
                                <ul id="account-dropdown" class="dropdown-content" tabindex="0">
                                    <li tabindex="0"><a href="login-servlet">Esci</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div>

            <div id="container">
                <%
                    ServletContext ctx = request.getServletContext();
                    DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");

                    try(
                            Connection con = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
                            Statement ps = con.createStatement();
                            ResultSet rs = ps.executeQuery("SELECT sitePost.*, nome, cognome " +
                                    "FROM sitePost, siteUser " +
                                    "WHERE sitePost.codiceUtente = siteUser.username " +
                                    "ORDER BY sitePost.data DESC, sitePost.ora DESC")
                    ){
                %>

                <form action="feed-servlet" method="post">
                <%
                        while (rs.next()) {
                %>

                    <div class="post">
                        <div class="post-header">
                            <!-- Cognome, nome, data, ora -->
                            <div class="post-header-col1">
                                <i class="material-icons-outlined">account_circle</i>
                                <%=rs.getString("cognome") + " " + rs.getString("nome")%>
                            </div>
                            <div class="post-header-col2">
                                <%=rs.getDate("data")%>
                                <br>
                                <%=rs.getTime("ora")%>
                            </div>
                        </div>
                        <div class="post-body">
                            <!-- Immagine -->
                            <div class="post-img materialboxed" style="background-image: url(load-image-servlet?codice=<%=rs.getInt("codice")%>);"></div>
                        </div>
                        <div class="post-footer">
                            <div class="post-footer-content">
                                <a href="comments.jsp?codicePost=<%=rs.getInt("codice")%>" data-position="left">
                                    <i class="material-icons-outlined">comment</i>
                                </a>
                            </div>
                        </div>
                    </div>

                <%      };
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <div class="error-div">
                        <h5>Errore con il caricamento dei dati.</h5>
                    </div>
                <%};%>
                </form>
            </div>
        </main>
    </body>
</html>
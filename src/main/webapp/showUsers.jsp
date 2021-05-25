<%@ page import="edu.fauser.DbUtility" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.Console" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Utenti - ReLife</title>
        <link rel="stylesheet" href="resources/css/style-users.css"/>
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
                $('select').formSelect();
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

        <main>
            <div class="navbar-fixed">
                <nav class="z-depth-0">
                    <div class="nav-wrapper">
                        <div id="logo-navbar" class="brand-logo">
                            <object id="logoSvg" data="resources/img/svg/logo-gr-txt-wh.svg" width="100em" height="64em"></object>
                        </div>
                        <div id="pageTitle" class="brand-logo center">
                            <h5>Utenti</h5>
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

            <%
                    DbUtility dbu = DbUtility.getInstance(sessione.getServletContext());

                    String queryString = request.getQueryString();
                    String selectedCitiesQuery = ";";

                    System.out.println(queryString);

                    if(queryString != null) {
                        String[] selectedCities = queryString.split("slCity=");
                        selectedCitiesQuery = "WHERE ";

                        for(String city:selectedCities) {
                            city = city.replace("&","");
                            System.out.println(city);
                            //selectedCitiesQuery = "siteUser = " + city;
                        }

                    }

                    System.out.println(selectedCitiesQuery);

                    try(
                            Connection con = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword());
                            Statement ps = con.createStatement();
                            ResultSet rsCities = ps.executeQuery(
                                    "SELECT DISTINCT luogo " +
                                    "FROM siteUser");

                            ResultSet rsSearch = ps.executeQuery(
                                    "SELECT username, nome, cognome, luogo " +
                                    "FROM siteUser " +
                                    selectedCitiesQuery)
                    ){

                %>

            <div id="container">
                <form action="showUsers.jsp" method="get">
                    <div class="topBar">
                        <div class="topBar-left">
                            <a class="waves-effect waves-light btn-flat btn-back" href="feed.jsp">Indietro <i class="material-icons left">arrow_back</i></a>
                        </div>
                        <div class="topBar-center">
                            <div class="input-field col s12">
                                <select name="slCity" multiple>
                                    <option value="" disabled selected></option>
                                    <%
                                        while (rsCities.next()) {
                                            String citta = rsCities.getString("luogo");
                                    %>
                                    <option value="<%=citta%>"><%=citta%></option>
                                    <%}%>
                                </select>
                                <label>Seleziona una o più città</label>
                            </div>
                        </div>
                        <div class="topBar-right">
                            <button type="submit" class="btn-floating btn-large waves-effect waves-light btn-search z-depth-0"><i class="material-icons-outlined">search</i></button>
                        </div>
                    </div>
                </form>

                <div class="spacer"></div>

                <%
                    while (rsSearch.next()) {
                %>

                    <div class="user-div">
                        <%=rsSearch.getString("username")%><br>
                        <%=rsSearch.getString("cognome")%><br>
                        <%=rsSearch.getString("nome")%><br>
                        <%=rsSearch.getString("luogo")%><br>
                    </div>

                <%      };
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <!--TODO metti testo di errore-->
                <%};%>
            </div>
        </main>
    </body>
</html>
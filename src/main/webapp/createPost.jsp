<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sessione = request.getSession(false);
    String nomeCompleto = (String) sessione.getAttribute("nomecompleto");

    if(nomeCompleto == null) {
        response.sendRedirect("index.jsp");
    } else {
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Crea un post - ReLife</title>
        <link rel="stylesheet" href="resources/css/style-postcreation.css"/>
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
            });
        </script>
    </head>

    <body>
        <%
            String[] arrNome = nomeCompleto.split(" ");
            String nomeUtente = arrNome[1] + " " + arrNome[2];

            if(request.getParameter("errore") != null) {
                    String errore = request.getParameter("errore");
        %>
                <script>M.toast({html: '<%=errore%>', classes: 'rounded'})</script>
        <%}%>

        <main>
            <div class="navbar-fixed">
                <nav class="z-depth-0">
                    <div class="nav-wrapper">
                        <div id="logo-navbar" class="brand-logo">
                            <object id="logoSvg" data="resources/img/svg/logo-gr-txt-wh.svg" width="100em" height="64em"></object>
                        </div>
                        <div id="pageTitle" class="brand-logo center">
                            <h5>Crea un post</h5>
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
                <div class="topBar">
                    <a class="waves-effect waves-light btn-flat btn-back" href="feed.jsp">Indietro <i class="material-icons left">arrow_back</i></a>
                </div>

                <div id="formContainer">
                    <div id="formContent">
                        <h4><strong>Vuoi pubblicare una foto?</strong></h4>
                        <h6 class="subText">
                            Clicca il seguente pulsante per selezionare un file dal tuo computer da caricare.
                            Alla conferma, verrà creato il post.
                        </h6>
                        <form action="feed-servlet" enctype="multipart/form-data" method="post">
                            <input type="hidden" name="azione" value="createPost">
                            <input type="hidden" name="cancella" value="cancella">

                            <div class="file-field input-field">
                                <div class="btn btn-file-upload">
                                    <span><i class="material-icons-outlined">file_upload</i></span>
                                    <input type="file" name="inputImage" required>
                                </div>
                                <div class="file-path-wrapper">
                                    <input class="file-path validate" type="text" placeholder="Carica una foto (Max 500kb)">
                                </div>
                            </div>

                            <button type="submit" class="waves-effect waves-light btn-large round btn-upload z-depth-0">Crea post</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
<%}%>
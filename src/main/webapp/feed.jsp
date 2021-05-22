<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    HttpSession sessione = request.getSession(false);
    String nomeCompleto = (String) sessione.getAttribute("nomecompleto");

    if(nomeCompleto != null) {
        String[] arrNome = nomeCompleto.split(" ");
        String nomeUtente = arrNome[1] + " " + arrNome[2];
%>
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
            });
        </script>
    </head>

    <body>
        <div class="fixed-action-btn">
            <a href="createPost.jsp" class="waves-effect waves-light btn-large round btn-upload">
                <i class="material-icons-outlined left">file_upload</i>
                crea post
            </a>
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
                                <a id="account-link" class="dropdown-trigger tooltipped" href="login-servlet" data-target="account-dropdown" data-position="down" data-tooltip="<%=nomeUtente%>">
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
                <div class="post">
                    <div class="post-header">
                        <!-- Cognome, nome, data, ora -->
                        <div class="post-header-col1">
                            <i class="material-icons-outlined">account_circle</i>
                            Cameroni Alessio
                        </div>
                        <div class="post-header-col2">
                            12-08-2002<br>
                            16:00
                        </div>
                    </div>
                    <div class="post-body">
                        <!-- Immagine -->
                        <div class="post-img materialboxed" style="background-image: url('resources/img/svg/photo_placeholder-large.svg')"></div>
                    </div>
                    <div class="post-footer">
                        <!-- Pulsante commenti, numero commenti-->
                        <div class="post-footer-col1">
                            0
                        </div>
                        <div class="post-footer-col2">
                            <a href="comments.jsp" data-position="left">
                                <i class="material-icons-outlined">comment</i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
<%
} else {
        response.sendRedirect("index.jsp");
    }
%>
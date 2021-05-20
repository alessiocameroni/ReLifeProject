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
        <title>Commenti - ReLife</title>
        <link rel="stylesheet" href="resources/css/style-commenti.css"/>
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
                $('input#textbox-comment-input').characterCounter();
                $('.materialboxed').materialbox();
            });
        </script>
    </head>

    <body>
        <main>
            <div class="navbar-fixed">
                <nav class="z-depth-0">
                    <div class="nav-wrapper">
                        <div id="logo-navbar" class="brand-logo">
                            <object id="logoSvg" data="resources/img/svg/logo-gr-txt-wh.svg" width="100em" height="64em"></object>
                        </div>
                        <div id="pageTitle" class="brand-logo center">
                            <h5>Commenti</h5>
                        </div>
                        <ul id="nav-mobile" class="right hide-on-med-and-down">
                            <li>
                                <a id="account-link" class="dropdown-trigger tooltipped" href="" data-target="account-dropdown" data-position="left" data-tooltip="Utente DEMO">
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

            <div id="container-left">
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
                        <div class="post-img materialboxed"></div>
                    </div>
                </div>
            </div>

            <div id="container-right">
                <div class="navbar-fixed">
                    <nav class="z-depth-0">
                        <div class="nav-wrapper">
                            <div class="brand-logo">
                                <ul class="left">
                                    <li>
                                        <a class="waves-effect waves-light btn-flat btn-back" href="feed.html">Indietro <i class="material-icons left">arrow_back</i></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </nav>
                </div>

                <div class="commento">
                    <div class="commento-header">
                        <div class="commento-header-col1">
                            <i class="material-icons-outlined">account_circle</i>
                            Genoni Luigia
                        </div>
                        <div class="commento-header-col2">
                            12-08-2002 · 19:00
                        </div>
                    </div>
                    <div class="commento-body">
                        Molto bello! Bravo.
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="input-comment">
                    <form action="" method="post">
                        <div class="input-comment-col1">
                            <div class="input-field input-field-comment">
                                <input id="textbox-comment-input" name="tbComment" type="text" class="validate" maxlength="140" autocomplete="off" placeholder="Massimo 140 caratteri" required>
                                <label for="textbox-comment-input">Scrivi un commento</label>
                            </div>
                        </div>

                        <div class="input-comment-col2">
                            <button type="submit" class="waves-effect waves-light btn-floating btn-large btn-upload z-depth-0"><i class="material-icons-outlined left">add_comment</i>commenta</button>
                        </div>
                    </form>
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
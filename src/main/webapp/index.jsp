<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Benvenuto - ReLife</title>
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <link rel="icon" href="favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="resources/css/style-index.css"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src ="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/js/materialize.min.js"></script>
    </head>

    <body>
        <main>
            <div class="fullscreen-bg">
                <video autoplay muted loop class="fullscreen-bg__video">
                    <source src="resources/video/bg-video.mp4" type="video/mp4">
                </video>
            </div>

            <div id="container">
                <div class="div-center div-over-bg">
                    <div id="logo">
                        <object id="logoSvg" data="resources/img/svg/logo-gr-txt-wh.svg" width="100%" height="100%"></object>
                    </div>

                    <div class="center-content">
                        <a href="createAccount.jsp" class="waves-effect waves-light btn-large round z-depth-0">
                            <i class="material-icons-outlined left">person_add</i>
                            iscriviti
                        </a>

                        <a href="login.jsp" class="waves-effect waves-light btn-large round z-depth-0">
                            <i class="material-icons-outlined left">login</i>
                            accedi
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <footer class="page-footer">
            <div class="footer-div">
                Sito creato a scopo didattico<br>
                ITT Fauser | Cameroni Alessio - 2020/2021
            </div>
        </footer>
    </body>
</html>
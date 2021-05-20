package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet(name = "feedServlet", value = "/feed-servlet")
public class FeedServlet extends HttpServlet {

    public void init() {
        DbUtility dub = DbUtility.getInstance(getServletContext());
        dub.setDevCredentials("jdbc:mariadb://localhost:3306/dbReLife?maxPoolSize=2&pool", "root", "");
    }
}

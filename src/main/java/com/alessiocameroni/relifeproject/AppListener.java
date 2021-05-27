package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener, HttpSessionAttributeListener {

    public AppListener() {
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DbUtility dbu = new DbUtility();
        dbu.setDevCredentials("jdbc:mariadb://localhost:3306/dbReLife?maxPoolSize=2&pool", "root", "");
        dbu.setProdCredentials("jdbc:mariadb://localhost:3306/dbReLife?maxPoolSize=2&pool", "db11448", "Jc7VD4MK");

        ServletContext ctx = sce.getServletContext();
        ctx.setAttribute("dbutility", dbu);
    }
}

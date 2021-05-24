package com.alessiocameroni.relifeproject;

import edu.fauser.DbUtility;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

@WebServlet(name = "loadImageServlet", value = "/load-image-servlet")
public class LoadImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer codice = Integer.parseInt(request.getParameter("codice"));
        if (codice == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ServletContext ctx = request.getServletContext();
        DbUtility dbu = (DbUtility) ctx.getAttribute("dbutility");

        System.out.println(dbu.getUrl());
        System.out.println(dbu.getUser());
        System.out.println(dbu.getPassword());

        try (Connection cn = DriverManager.getConnection(dbu.getUrl(), dbu.getUser(), dbu.getPassword()))
        {
            String strSql = "SELECT fileImmagine, tipo FROM sitePost WHERE codice = ?";
            try (PreparedStatement ps = cn.prepareStatement(strSql)) {
                ps.setInt(1, codice);
                ResultSet rs = ps.executeQuery();
                if (rs.next() == false) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                ServletOutputStream out = response.getOutputStream();

                InputStream img = rs.getBinaryStream("fileImmagine");
                String tipo = rs.getString("tipo");
                response.setContentType(tipo);

                byte[] buffer = new byte[4096];
                while (img.read(buffer) > 0) {
                    out.write(buffer);
                }
                out.flush();
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace(response.getWriter());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Metodo POST non gestito da questa servlet
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

}

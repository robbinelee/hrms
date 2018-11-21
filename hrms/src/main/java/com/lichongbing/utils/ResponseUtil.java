package com.lichongbing.utils;

import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

public class ResponseUtil {
    /**
     *
     * @param response
     * @param o
     * @throws Exception
     *
     *其 write() 方法的作用是将用 HttpServletResponse
     *返回前台 JSON 格式数据，同时减少 Controller 层代码的冗余
     *
     *
     */
    public static void write(HttpServletResponse response, Object o)
            throws Exception {
        response.setContentType("text/html;charset=utf-8");
        response.addHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = response.getWriter();
        out.println(o.toString());
        out.flush();
        out.close();
    }
}

package com.bj58.data.antifraud.heatmap.web.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bj58.data.antifraud.heatmap.entity.Click;
import com.bj58.data.antifraud.heatmap.service.ClickService;
import com.bj58.data.antifraud.heatmap.service.impl.ClickServiceImpl;

import net.sf.json.JSONArray;

/**
 * Servlet implementation class DataQueryController
 */
@WebServlet("/DataQueryController")
public class DataQueryController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		System.out.println("dataqueryservlet init...");
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html; charset=utf-8");
		System.out.println("dataquerycontroller...");
		ClickService cs = new ClickServiceImpl();
		PrintWriter out = response.getWriter();

		List<Click> clicks = cs.dataQuery(request);
		out.write(JSONArray.fromObject(clicks).toString());

		out.flush();
		out.close();

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}

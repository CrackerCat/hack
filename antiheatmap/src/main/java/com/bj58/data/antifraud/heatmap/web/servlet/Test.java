package com.bj58.data.antifraud.heatmap.web.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Test extends HttpServlet {
	private static final Logger logger = LogManager.getLogger("heatmaplog");
	private static int request_cnt;
	
	@Override
	public void init() throws ServletException {
		System.out.println("tttt");
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("sssss1");
		PrintWriter pw = resp.getWriter();
		pw.println("hahaha!!");

		logger.error("log4j log the log !" + request_cnt);
		request_cnt++;

		pw.println("hehehe");
		pw.println(new Date());

		System.out.println("sssss2");

	}

}

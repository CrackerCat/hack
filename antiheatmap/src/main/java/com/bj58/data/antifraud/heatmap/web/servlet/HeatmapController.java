package com.bj58.data.antifraud.heatmap.web.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.bj58.data.antifraud.heatmap.service.ClickService;
import com.bj58.data.antifraud.heatmap.service.impl.ClickServiceImpl;

public class HeatmapController extends HttpServlet {
	private static final long serialVersionUID = 01L;
	private static final Logger logger = LogManager.getLogger("heatmaplog");

	private ClickService cs = null;
	
	@Override
	public void init() throws ServletException {
		System.out.println("general servlet init...");
		cs = new ClickServiceImpl();
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/html; charset=utf-8");
		String action_type = req.getParameter("action_type");
		int clk_cnt = 1;
		// System.out.println("action_type: " + action_type);
		
		if ("heatmap_1".equals(action_type) || "clickmap_1".equals(action_type)) {
			clk_cnt = cs.countQuery(req);
			
			resp.sendRedirect(req.getContextPath() + "/views/wholeheatmap.jsp?spm=" + req.getParameter("spm")
								+ "&start_date=" + req.getParameter("start_date")
								+ "&end_date=" + req.getParameter("end_date")
								+ "&clk_cnt=" + clk_cnt
								+ "&maptype=" + action_type
								+ "&flag=0");    // 全页面
			// req.getRequestDispatcher("/views/wholeheatmap.jsp").forward(req, resp);
		} else if ("heatmap_2".equals(action_type) || "clickmap_2".equals(action_type)) {
			req.setAttribute("flag", 1);     // 单广告位
			clk_cnt = cs.countQuery(req);
			req.setAttribute("clk_cnt", clk_cnt);
			req.setAttribute("maptype", action_type);
			req.getRequestDispatcher("/views/singleheatmap.jsp").forward(req, resp);
		} else if ("test_bn".equals(action_type)) {			
			req.setAttribute("flag", 2);     // 测试
			req.setAttribute("clk_cnt", clk_cnt);
			req.getRequestDispatcher("/views/singleheatmap.jsp").forward(req, resp);
		}

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

}

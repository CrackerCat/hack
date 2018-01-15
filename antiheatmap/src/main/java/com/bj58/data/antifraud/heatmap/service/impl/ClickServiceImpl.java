package com.bj58.data.antifraud.heatmap.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.bj58.data.antifraud.heatmap.dao.ClickDao;
import com.bj58.data.antifraud.heatmap.dao.impl.ClickDaoImpl;
import com.bj58.data.antifraud.heatmap.entity.Click;
import com.bj58.data.antifraud.heatmap.service.ClickService;

public class ClickServiceImpl implements ClickService {
	private String spm = null;
	private String start_date = null;
	private String end_date = null;
	private int pos1 = 0;
	private int pos2 = Integer.MAX_VALUE;
	private ClickDao cd = null;
	
	private SimpleDateFormat sdf1 = null;
	private SimpleDateFormat sdf2 = null;
	
	public ClickServiceImpl(){
		System.out.println("clickserviceImpl object create ...");
		cd = new ClickDaoImpl();
		sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		sdf2 = new SimpleDateFormat("yyyyMMdd");
	}
	
	public int countQuery(HttpServletRequest req){
		int clk_cnt = 0;
		spm = req.getParameter("spm");
		try {
			start_date = sdf2.format(sdf1.parse(req.getParameter("start_date")));
			end_date = sdf2.format(sdf1.parse(req.getParameter("end_date")));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		try {
			clk_cnt = cd.countQuery(start_date,end_date,spm);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return clk_cnt;
	}

	public List<Click> dataQuery(HttpServletRequest req) {
		List<Click> clicks = null;
		spm = req.getParameter("spm");
		try {
			start_date = sdf2.format(sdf1.parse(req.getParameter("start_date")));
			end_date = sdf2.format(sdf1.parse(req.getParameter("end_date")));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		// pos1 = StringUtils.isBlank(req.getParameter("pos1")) ? pos1 : Integer.parseInt(req.getParameter("pos1"));
		// pos2 = StringUtils.isBlank(req.getParameter("pos2")) ? pos2 : Integer.parseInt(req.getParameter("pos2"));
		// System.out.println("spm: " + spm + "start_date: " + start_date + "end_date: " + end_date + "pos1: " + pos1 + "pos2: "+pos2);
		
		String flag = req.getParameter("flag");
		int beginnum = Integer.parseInt(req.getParameter("beginnum"));
		int limitnum = Integer.parseInt(req.getParameter("limitnum"));
		if ("2".equals(flag)){
			String sid = req.getParameter("sid");
			String entid = req.getParameter("entid");
			String clktime = req.getParameter("clktime");
			System.out.println("sid: " + sid + "entid: " + entid + "clktime: " + clktime);
			try {
				clicks = cd.clickQuery(start_date,end_date,spm,sid,entid,clktime);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} else {
			try {
				clicks = cd.clickQuery(start_date,end_date,spm,flag,beginnum,limitnum);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return clicks;
	}
}

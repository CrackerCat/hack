package com.bj58.data.antifraud.heatmap.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.bj58.data.antifraud.heatmap.entity.Click;

public interface ClickService {
	public List<Click> dataQuery(HttpServletRequest req);

	public int countQuery(HttpServletRequest req);
}

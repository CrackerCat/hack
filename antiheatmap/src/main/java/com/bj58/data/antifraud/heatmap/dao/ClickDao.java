package com.bj58.data.antifraud.heatmap.dao;

import java.sql.SQLException;
import java.util.List;

import com.bj58.data.antifraud.heatmap.entity.Click;

public interface ClickDao {
	
	int countQuery(String start_date,String end_date,String spm) throws Exception;

	List<Click> clickQuery(String start_date, String end_date, String spm, String flag, int beginnum, int limitnum) throws SQLException;
	
	List<Click> clickQuery(String start_date, String end_date, String spm, String sid, String entid, String clktime) throws SQLException;
	
}

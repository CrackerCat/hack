package com.bj58.data.antifraud.heatmap.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bj58.data.antifraud.heatmap.dao.ClickDao;
import com.bj58.data.antifraud.heatmap.entity.Click;
import com.bj58.data.antifraud.heatmap.utils.DBUtil;

public class ClickDaoImpl implements ClickDao {
	
	public int countQuery(String start_date,String end_date,String spm){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		int clk_cnt = 0;
		String table_name = "featuredb.anti_mouse_clickdata_detail_m_whole";
		String sql = "select spm,count(1) as clk_cnt from " + table_name 
				+ " where dt>=? and dt<=? and touch_type=2 and spm=? group by spm ";
		
		System.out.println(sql + " start_date= " + start_date + " end_date= " + end_date + " spm = " + spm);
		
		try {
			conn = DBUtil.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, start_date);
			ps.setString(2, end_date);
			ps.setString(3, spm);
			rs = ps.executeQuery();
			if(rs.next()){
				clk_cnt = rs.getInt("clk_cnt");
			}else{
				return clk_cnt = 0;
			}
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			DBUtil.release(conn, ps, rs);
		}
		return clk_cnt;
	}

	public List<Click> clickQuery(String start_date, String end_date, String spm, String sid, String entid, String clktime) throws SQLException {
		String table_name = "featuredb.anti_mouse_clickdata_detail_m_whole";
		String sql = "select sid,entityid,spm,dpi_x,dpi_y,pagewidth,pageheight,pos,slideend_x,slideend_y,"
				+ "container_x,container_y,entity_x,entity_y,scroll_y,entity_width,entity_height,touch_type from " 
				+ table_name 
				+ " where dt>=? and dt<=? and touch_type=2 and spm=? and sid=? and entityid=? and slideendtime=?";
		
		return getResult(sql, start_date, end_date, spm, sid, entid, clktime);

	}
	

	public List<Click> clickQuery(String start_date, String end_date, String spm, String flag, int beginnum, int limitnum) throws SQLException {
		
		String table_name = "featuredb.anti_mouse_clickdata_detail_m_whole";
		String sql = "select sid,entityid,spm,dpi_x,dpi_y,pagewidth,pageheight,pos,slideend_x,slideend_y,"
				+ "container_x,container_y,entity_x,entity_y,scroll_y,entity_width,entity_height,touch_type from " 
				+ table_name 
				+ " where dt>=? and dt<=? and touch_type=2 and spm=? order by pos limit " + beginnum + ", " + limitnum;
		return getResult(sql, start_date, end_date, spm);
	}
	
	private List<Click> getResult(String sql, Object ... args){
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<Click> clklist = new ArrayList<Click>();
		
		try {
			conn = DBUtil.getConnection();
			ps = conn.prepareStatement(sql);
			System.out.print(sql);
			//占位符顺序从1开始
			for(int i = 0; i<args.length; i++){
				ps.setObject(i+1, args[i]);
				System.out.print("\t" + args[i]);
			}
			
			System.out.println();
			
			rs = ps.executeQuery();
			while(rs.next()){
				Click clk = new Click();
				// clk.setTouch_type(rs.getInt("touch_type"));
				clk.setSid(rs.getString("sid"));
				clk.setEntityid(rs.getString("entityid"));
				clk.setSpm(rs.getString("spm"));
				clk.setPos(rs.getInt("pos"));
				clk.setDpi_x(rs.getDouble("dpi_x"));
				clk.setDpi_y(rs.getDouble("dpi_y"));
				clk.setPagewidth(rs.getDouble("pagewidth"));
				clk.setPageheight(rs.getDouble("pageheight"));
				clk.setSlideend_x(rs.getDouble("slideend_x"));
				clk.setSlideend_y(rs.getDouble("slideend_y"));
				clk.setContainer_x(rs.getDouble("container_x"));
				clk.setContainer_y(rs.getDouble("container_y"));
				clk.setEntity_x(rs.getDouble("entity_x"));
				clk.setEntity_y(rs.getDouble("entity_y"));
				clk.setScroll_y(rs.getDouble("scroll_y"));
				clk.setEntity_width(rs.getDouble("entity_width"));
				clk.setEntity_height(rs.getDouble("entity_height"));
				
				clklist.add(clk);
			}
		} catch (Exception e){
			e.printStackTrace();
		} finally {
			DBUtil.release(conn, ps, rs);
		}
		
		return clklist;
	}
}

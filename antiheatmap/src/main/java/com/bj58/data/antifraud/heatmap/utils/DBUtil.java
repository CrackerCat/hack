package com.bj58.data.antifraud.heatmap.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.mchange.v2.c3p0.ComboPooledDataSource;


public class DBUtil {
	/*private static final String URL = "jdbc:mysql://10.126.83.92:3306/featuredb";
	private static final String USER = "readuser";
	private static final String PWD = "123456";
	private static Connection conn = null;*/

	// 数据库连接池
	private static ComboPooledDataSource ds = null;

	static { // 静态代码块，加载驱动、连接数据库
		/*try {
			// 1. 加载驱动
			Class.forName("com.mysql.jdbc.Driver");
			// 2. 获得数据库连接
			conn = DriverManager.getConnection(URL, USER, PWD);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}*/
		
		try {
			//通过读取C3P0的xml配置文件创建数据源
			ds = new ComboPooledDataSource("MySQL");//使用C3P0的命名配置来创建数据源
		} catch (Exception e){
			e.printStackTrace();
		}
	}

	// 对外提供一个获取数据库连接的接口
	public static Connection getConnection() throws SQLException {
		//return conn;
		//从数据源中获取数据库连接
		return ds.getConnection();
	}

    /**
    * @Method: release
    * @Description: 释放资源，
    * 释放的资源包括Connection数据库连接对象，负责执行SQL命令的Statement对象，存储查询结果的ResultSet对象
    */ 
    public static void release(Connection conn,Statement st,ResultSet rs){
        if(rs!=null){
            try{
                //关闭存储查询结果的ResultSet对象
                rs.close();
            }catch (Exception e) {
                e.printStackTrace();
            }
            rs = null;
        }
        if(st!=null){
            try{
                //关闭负责执行SQL命令的Statement对象
                st.close();
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        if(conn!=null){
            try{
                //将Connection连接对象还给数据库连接池
                conn.close();
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

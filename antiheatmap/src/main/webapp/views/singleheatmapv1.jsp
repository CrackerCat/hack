<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="zh-CN" data-dpr="1" style="font-size: 41.4px;">
<!-- 包含head -->
<jsp:include page="/WEB-INF/include/hy_m_heatmap_head.jspf" />

<body>
	<div id="list">
		<jsp:include page="/WEB-INF/include/hy_m_heatmap_body_top.jspf" />
		
		<!-- 渲染区域开始！ -->
		<div class="list">
			<ul class="list-demo huangye_m_list">
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
			</ul>
		</div>
		<canvas id="cvs0" class="singlecanvas" style="position:absolute;"></canvas>
		<!-- 渲染区域结束！ -->
		
	</div>
	
	<div>
		<h6>spm:${param.spm }</h6>
		<input type="hidden" value="${param.spm }" id="spm"/>
		<input type="hidden" value="${param.start_date }" id="start_date"/>
		<input type="hidden" value="${param.end_date }" id="end_date"/>
		<input type="hidden" value="${param.sid }" id="sid"/>
		<input type="hidden" value="${param.entid }" id="entid"/>
		<input type="hidden" value="${param.clktime }" id="clktime"/>
		<input type="hidden" value="${requestScope.flag }" id="flag"/>
		<input type="hidden" value="${requestScope.clk_cnt }" id="clk_cnt"/>
		<input type="hidden" value="${requestScope.maptype }" id="maptype"/>
	</div>

	<br><br>
	
	<script type="text/javascript" src="/antiheatmap/js/heatmap.js"></script>
	<script type="text/javascript" src="/antiheatmap/js/heatmapdraw.js"></script>
	<script>
		var cvs = $('#cvs0');
		var singleslot = $('.singleslot:first-child');
		var singleslot_width = singleslot.outerWidth(true);
		var singleslot_height = singleslot.outerHeight(true);
		cvs.css('left', singleslot.position().left);
		cvs.css('top', singleslot.position().top);
		cvs.attr('width', singleslot_width);
		cvs.attr('height', singleslot_height);
	</script>
	<script>
		// 设备像素宽高
		//var device_dpi_x = document.documentElement.clientWidth;
		//var device_dpi_y = document.documentElement.clientHeight;
		var device_dpi_x = window.screen.width;
		var device_dpi_y = window.screen.height;

		var ctx = cvs.get(0).getContext("2d");
		
		var spm = $('#spm').val();
		var start_date = $('#start_date').val();
		var end_date = $('#end_date').val();
		var sid = $('#sid').val();
		var entid = $('#entid').val();
		var clktime = $('#clktime').val();
		var flag = $('#flag').val();
		var clk_cnt = $('#clk_cnt').val();
		var maptype = $('#maptype').val();
		
		// 分页查询 绘制
		var limitnum = 5000;
		var tmp = clk_cnt/limitnum;
		for (var i = 0; i < tmp; i++){
			$.ajax({
				url:"/antiheatmap/heatmap/dataquery",
				data:{
					spm:spm,
					start_date:start_date,
					end_date:end_date,
					flag:flag,
					beginnum:limitnum*i,
					limitnum:limitnum,
					sid:sid,
					entid:entid,
					clktime:clktime
				},
				success:function(clicklist,status){
					console.log(clicklist);
					if ("clickmap_2" === maptype) {
						var j;
						for(j=0; j< clicklist.length;j++){
							clk = clicklist[j];
							var coordinate_x = 1.0*(clk.slideend_x -clk.entity_x)/clk.entity_width*singleslot_width;
							var coordinate_y = 1.0*(clk.slideend_y -clk.entity_y)/clk.entity_height*singleslot_height;
							/* alert('device_dpi_x: '+device_dpi_x + ' device_dpi_y: ' + device_dpi_y);
							alert('coor_x: '+ (clk.slideend_x -clk.entity_x) + ' coor_y: ' + (clk.slideend_y -clk.entity_y));
							alert('dpi_x: '+ clk.dpi_x + ' dpi_y: ' + clk.dpi_y);
							alert('singleslot_width: '+ singleslot_width + ' singleslot_height: ' + singleslot_height);
							alert('coordinate_x: '+ coordinate_x + ' coordinate_y: ' + coordinate_y); */
							//drawCoordinate(ctx, device_dpi_x, device_dpi_y, coordinate_x, coordinate_y, clk.dpi_x, clk.dpi_y, 0.1);
							conf = {
						        gradient:{1.0:"rgb(0,0,255)"},
						        radius:5,
						        blur:1	
							};
							drawHeatmap(clicklist, flag, conf);
						}
					}else if ("heatmap_2" === maptype) {
						drawHeatmap(clicklist, flag);	
					}
				},
				dataType:"json"
			});
		}
	</script>
</body>

<script src="//tracklog.58.com/referrer_m.js"></script>
<script src="//wechat.58.com/google-analytics"></script>

</html>
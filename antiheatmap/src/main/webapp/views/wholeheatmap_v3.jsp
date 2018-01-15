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
				<%-- <jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" /> --%>
			</ul>
		</div>
		<!-- 渲染区域结束！ -->
		
		<div>
			<input type="hidden" value="${param.spm }" id="spm"/>
			<input type="hidden" value="${param.start_date }" id="start_date"/>
			<input type="hidden" value="${param.end_date }" id="end_date"/>
			<input type="hidden" value="${param.flag }" id="flag"/>
			<input type="hidden" value="${param.clk_cnt }" id="clk_cnt"/>
			<input type="hidden" value="${param.maptype }" id="maptype"/>
		</div>
		
		<div class="load" id="infomore" >
			<i></i>加载更多
		</div>
		<div id="bottom">我是有底线的，没有更多信息啦~</div>
	</div>


</body>

<script type="text/javascript" src="/antiheatmap/js/heatmap.js"></script>
<script type="text/javascript" src="/antiheatmap/js/heatmapdraw.js"></script>
<script>
	var spm = $('#spm').val();
	var start_date = $('#start_date').val();
	var end_date = $('#end_date').val();
	var flag = $('#flag').val();
	var clk_cnt = $('#clk_cnt').val();
	var maptype = $('#maptype').val();
	
	var device_dpi_x = window.screen.width;
	var device_dpi_y = window.screen.height;
	
	var ul = $('.huangye_m_list');
	var pos;
	for(pos = 0; pos < 500; pos++){
		ul.append('<jsp:include page="./included/huangye_common_ad.jsp" />')
		$('.singleslot:last-child').attr('id','slot' + pos);
	}
/* 	for(pos = 0; pos < 500; pos++){
		ul.append('<jsp:include page="./included/huangye_common_ad.jsp" />')
		$('.singleslot:last-child').attr('id','slot' + pos);
		ul.append('<canvas class="singlecanvas" style="position:absolute;"></canvas>');
		var cvs = $('.singlecanvas:last-child').attr('id','cvs'+pos);
		var singleslot = $('#slot'+pos);
		var singleslot_width = singleslot.outerWidth(true);
		var singleslot_height = singleslot.outerHeight(true);
		cvs.css('left', singleslot.position().left);
		cvs.css('top', singleslot.position().top);
		cvs.attr('width', singleslot_width);
		cvs.attr('height', singleslot_height);
	} */
	
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
				limitnum:limitnum
			},
			dataType:"json",
			success:function(clicklist,status){
				// console.log(clicklist);
				if ("clickmap_1" === maptype) {
					var j;
					for(j=0; j< clicklist.length;j++){
						clk = clicklist[j];
						pos = clk.pos;
						var cvs = $('#cvs'+pos);
						var ctx = cvs.get(0).getContext("2d");
						coordinate_x = 1.0*(clk.slideend_x -clk.entity_x)/clk.entity_width*cvs.width();
						coordinate_y = 1.0*(clk.slideend_y -clk.entity_y)/clk.entity_height*cvs.height();
						drawCoordinate(ctx, device_dpi_x, device_dpi_y, coordinate_x, coordinate_y, clk.dpi_x, clk.dpi_y, 0.4);
					}
				}else if ("heatmap_1" === maptype) {
					drawHeatmap(clicklist, flag);	
				}
			}
		});
	}
	
	
</script>


<script src="//tracklog.58.com/referrer_m.js"></script>
<script src="//wechat.58.com/google-analytics"></script>

</html>
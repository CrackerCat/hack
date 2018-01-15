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
		<!-- 渲染区域结束！ -->
		
	</div>
	
	<div>
		<h6 id="clkcoor"></h6>
		<h6>spm:${param.spm }</h6>
		<h6 id="loadsuccess"></h6>
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
		// 设备像素宽高
		//var device_dpi_x = document.documentElement.clientWidth;
		//var device_dpi_y = document.documentElement.clientHeight;
		/*var device_dpi_x = window.screen.width;
		var device_dpi_y = window.screen.height;
		alert('device_dpi_x:' + device_dpi_x + '   device_dpi_y:' + device_dpi_y);*/
		// 最多查多少条数据
		var MAX_QUERY = 100000;
		var spm = $('#spm').val();
		var start_date = $('#start_date').val();
		var end_date = $('#end_date').val();
		var sid = $('#sid').val();
		var entid = $('#entid').val();
		var clktime = $('#clktime').val();
		var flag = $('#flag').val();
		var clk_cnt = $('#clk_cnt').val();
		clk_cnt = clk_cnt > MAX_QUERY ? MAX_QUERY : clk_cnt;
		var maptype = $('#maptype').val();
		
		// 热力图容器
	    var config_width = $('.singleslot:first-child').outerWidth(true);
	    var config_height = $('.singleslot:first-child').outerHeight(true);
	    var conf = {};
	    if ("clickmap_2" === maptype){
			conf = {
			        gradient:{1.0:"rgb(0,0,255)"},
			        radius:5,
			        blur:0.6,
			        maxOpacity:1
			};
	    } else if ("heatmap_2" === maptype) {
	    	conf = {
	    		blur:0.8,
	            minOpacity:0.2	
	    	}
	    }
    	$.extend(conf,{
            container: $('.singleslot').get(0),
            width: config_width,
            height: config_height,
        });
    	heatmapInstance = h337.create(conf);
    	
		var limitnum = 3000;
		var i = 0;
		var pointsData;
    	$.ajax({
    		url:"/antiheatmap/heatmap/dataquery",
    		async:false,
			data:{
				spm:spm,
				start_date:start_date,
				end_date:end_date,
				flag:flag,
				beginnum:limitnum*i++,
				limitnum:limitnum,
				sid:sid,
				entid:entid,
				clktime:clktime
			},
    		dataType:"json",
    		success:function(data,status){
    			// console.log(pointsData);
    			pointsData = drawHeatmap_v2(data, flag);
    		}
    	});
        
        var coordinator_datas = { 
                max: 500, 
                data: pointsData
        }
        heatmapInstance.setData(coordinator_datas);
    	
		
		// 分页查询 绘制
		var tmp = clk_cnt/limitnum;
		var deferredslist = [];
		for(; i < tmp; i++){
			deferredslist.push($.ajax({
					url:"/antiheatmap/heatmap/dataquery",
					//async:false,
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
					dataType:"json",
					success:function(returndata,status){
						//console.log(data);
						heatmapInstance.addData(drawHeatmap_v2(returndata, flag));
					}
				}));
			}
		$.when(
				deferredslist
		).done(
				function(){
					console.log('ccccc');
					$('#loadsuccess').text('加载完成');
				}
		);
		/* $.when(
			for (; i < tmp; i++){
				$.ajax({
					url:"/antiheatmap/heatmap/dataquery",
					//async:false,
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
					dataType:"json",
					success:function(returndata,status){
						//console.log(data);
						heatmapInstance.addData(drawHeatmap_v2(returndata, flag));
						$(document).dequeue("heatmapqueue");
					}
				});
			}
		).done(
				function(){
					console.log('ccccc');
					$('#loadsuccess').text('加载完成');
				}
		); */
	</script>
	<script type="text/javascript">
		function getCoordinates(e){
			x=e.clientX - $('.singleslot:first-child').get(0).offsetLeft;
			y=e.clientY - $('.singleslot:first-child').get(0).offsetTop;
			document.getElementById("clkcoor").innerHTML="";
			document.getElementById("clkcoor").innerHTML="Coordinates: (" + x + "," + y + ")";
		};
		var cvs = $('.heatmap-canvas');
		cvs.on('click',getCoordinates);
	</script>
</body>

<script src="//tracklog.58.com/referrer_m.js"></script>
<script src="//wechat.58.com/google-analytics"></script>

</html>
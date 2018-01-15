<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport"
	content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width">
<meta name="format-detection" content="telephone=no">
<meta name="format-detection" content="email=no">
<meta name="format-detection" content="address=no;">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<title>首页-M端热力图</title>
<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>



<style type="text/css">
.select_input {
	width: 150px;
	height: 30px;
	margin: 10px 5px;
	border: 0px;
	background: #3385ff;
	color: #fafafa;
}

.font_input {
	font-size: 15px;
	font-family: Arial;
}
</style>

<script type="text/javascript">
	function click_input(ele) {
		if (ele.id == "heatmap_1") {
			$("#fm").attr('action', "/heatmap/mtheatmap.php");
		} else if (ele.id == "heatmap_2") {
			$("#fm").attr('action',
					"/heatmap/uniform_heatmap/unientiheatmap.php");
		} else if (ele.id == "heatmap_3") {
			$("#fm").attr(
					'action',
					"/heatmap/mtheatmap.php?dispid='" + $('#disp_id').val()
							+ "'&entid='" + $('#ent_id').val() + "'&clktime="
							+ $('#clk_time').val());
		}

		$('#fm').submit();
	}
</script>
</head>

<body>
	<div align="center" style="padding: 100px 0px;">
		<div id="logo" style="margin:0px 0px 20px 0px;">
			<img src="${pageContext.request.contextPath }/img/logo-58.png" width="220" height="80">
		</div>
		<form id="fm" method="post" target="_blank">
			<input id="spm" name="spm" style="width: 300px; height: 30px;" class="font_input"> <input
				type="date" name="query_date" style="width: 140px; height: 30px;" class="font_input">
			<div>
				<input type="submit" id="heatmap_1" value="全页面热力图" class="select_input font_input"
					onclick="click_input(this)" />
				<input type="submit" id="heatmap_2"
					value="单广告位热力图" class="select_input font_input" onclick="click_input(this)">
				<input type="button" id="test_bn" value="坐标数据测试" class="select_input font_input"
					onclick="$('#coor_input').show();">
				<div id="coor_input" style="display: none;">
					展现ID：<input type="text" id="disp_id"> 
					EntityId：<input type="text" id="ent_id">
					clicktime：<input type="text" id="clk_time"> <input type="button" id="heatmap_3"
						value="确定" onclick="click_input(this)">
				</div>
			</div>
		</form>
	</div>
</body>

</html>

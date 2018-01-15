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

				<li class="zdAdContainer">
					<ul>
						<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
						<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
						<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
					</ul>
				</li>
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
				<li class="recommendTags">
					<a class="recommendTag0" href="#">推荐1</a><a class="recommendTag1" href="#">推荐2</a><a class="recommendTag2" href="#">推荐3</a><a class="recommendTag3" href="#">推荐4</a><a class="recommendTag4" href="#">推荐5</a><a class="recommendTag5" href="#">推荐6</a>
				</li>
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
			</ul>
		</div>
		<!-- 渲染区域结束！ -->
		
		<div>
			<c:forEach var="click" items="<%=request.getAttribute(\"clicklist\") %>">
				${click.spm}
			</c:forEach>
		</div>
		
		
		<div class="load" id="infomore">
			<i></i>加载更多
		</div>
		<div id="bottom">我是有底线的，没有更多信息啦~</div>
	</div>


</body>

<script type="text/javascript" src="./js/drawheatmap.js"></script>

<script src="//tracklog.58.com/referrer_m.js"></script>
<script src="//wechat.58.com/google-analytics"></script>

</html>
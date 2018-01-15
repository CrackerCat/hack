<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<!DOCTYPE html>
<html lang="zh-CN" data-dpr="1" style="font-size: 41.4px;">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width">
<meta name="format-detection" content="telephone=no">
<meta name="format-detection" content="email=no">
<meta name="format-detection" content="address=no;">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">

<title>M端热力图</title>

<script>
	(function(win, lib) {
		var doc = win.document;
		var docEl = doc.documentElement;
		var metaEl = doc.querySelector('meta[name="viewport"]');
		var flexibleEl = doc.querySelector('meta[name="flexible"]');
		var dpr = 0;
		var scale = 0;
		var tid;
		var flexible = lib.flexible || (lib.flexible = {});

		if (metaEl) {
			console.warn('将根据已有的meta标签来设置缩放比例');
			var match = metaEl.getAttribute('content').match(
					/initial\-scale=([\d\.]+)/);
			if (match) {
				scale = parseFloat(match[1]);
				dpr = parseInt(1 / scale);
			}
		} else if (flexibleEl) {
			var content = flexibleEl.getAttribute('content');
			if (content) {
				var initialDpr = content.match(/initial\-dpr=([\d\.]+)/);
				var maximumDpr = content.match(/maximum\-dpr=([\d\.]+)/);
				if (initialDpr) {
					dpr = parseFloat(initialDpr[1]);
					scale = parseFloat((1 / dpr).toFixed(2));
				}
				if (maximumDpr) {
					dpr = parseFloat(maximumDpr[1]);
					scale = parseFloat((1 / dpr).toFixed(2));
				}
			}
		}

		if (!dpr && !scale) {
			var isAndroid = win.navigator.appVersion.match(/android/gi);
			var isIPhone = win.navigator.appVersion.match(/iphone/gi);
			var devicePixelRatio = win.devicePixelRatio;
			if (isIPhone) {
				// iOS下，对于2和3的屏，用2倍的方案，其余的用1倍方案
				if (devicePixelRatio >= 3 && (!dpr || dpr >= 3)) {
					dpr = 3;
				} else if (devicePixelRatio >= 2 && (!dpr || dpr >= 2)) {
					dpr = 2;
				} else {
					dpr = 1;
				}
			} else {
				// 其他设备下，仍旧使用1倍的方案
				dpr = 1;
			}
			scale = 1 / dpr;
		}

		docEl.setAttribute('data-dpr', dpr);
		window.dpr = dpr;

		if (!metaEl) {
			metaEl = doc.createElement('meta');
			metaEl.setAttribute('name', 'viewport');
			metaEl.setAttribute('content', 'initial-scale=' + scale
					+ ', maximum-scale=' + scale + ', minimum-scale=' + scale
					+ ', user-scalable=no');
			if (docEl.firstElementChild) {
				docEl.firstElementChild.appendChild(metaEl);
			} else {
				var wrap = doc.createElement('div');
				wrap.appendChild(metaEl);
				doc.write(wrap.innerHTML);
			}
		}

		function refreshRem() {
			var width = docEl.getBoundingClientRect().width;
			if (width / dpr > 540) {
				width = 540 * dpr;
			}
			var rem = width / 10;
			docEl.style.fontSize = rem + 'px';
			flexible.rem = win.rem = rem;
		}

		win.addEventListener('resize', function() {
			clearTimeout(tid);
			tid = setTimeout(refreshRem, 300);
		}, false);
		win.addEventListener('pageshow', function(e) {
			if (e.persisted) {
				clearTimeout(tid);
				tid = setTimeout(refreshRem, 300);
			}
		}, false);

		refreshRem();

		flexible.dpr = win.dpr = dpr;
		flexible.refreshRem = refreshRem;
		flexible.rem2px = function(d) {
			var val = parseFloat(d) * this.rem;
			if (typeof d === 'string' && d.match(/rem$/)) {
				val += 'px';
			}
			return val;
		}
		flexible.px2rem = function(d) {
			var val = parseFloat(d) / this.rem;
			if (typeof d === 'string' && d.match(/px$/)) {
				val += 'rem';
			}
			return val;
		}

	})(window, window['lib'] || (window['lib'] = {}));
</script>
<script type="text/javascript">
	var lm_infolist = [];
	var lm_filter = {
		"filter" : [ {
			"name" : "区域"
		}, {
			"name" : "类别"
		} ]
	};
	var __citychange = {
		"name" : "北京",
		"url" : "#"
	};
	var _trackURL = "{'pagesize':'30','area':'1','cate':'8512,95','pagenum':'1','actiontype':'tongchengbao','pagetype':'list','is_biz':'false'}";
	var adTotal = 25;
	var ____json4fe = {
		"sid" : "145925167197721256778231755",
		"giftflag" : false,
		"locallist" : [ {
			"dispid" : "1",
			"name" : "北京",
			"listname" : "bj"
		} ],
		"catentry" : [ {
			"dispid" : "8512",
			"name" : "家政服务",
			"listname" : "shenghuo"
		}, {
			"dispid" : "95",
			"name" : "保姆/月嫂",
			"listname" : "baomu"
		} ],
		"sessionid" : "4a55c3cd-cccf-4f9d-81d0-224b01320cb9"
	};
</script>
<link rel="stylesheet" href="//c.58cdn.com.cn/crop/biz/m/hezuoM/css/list_20_all_v20170911191911.css" charset="utf-8">
<script src="//j1.58cdn.com.cn/crop/biz/m/hezuoM/js/libs/esl_zepto_v20170613192207.js"
	charset="utf-8"></script>
<script src="//j1.58cdn.com.cn/crop/biz/base/js/fzb_list_new_v20161130220801.js" charset="utf-8"></script>
<!-- 新增黄页用户行为埋点 -->
<script type="text/javascript">
	window.WMDA_SDK_CONFIG = ({
		api_v : 1,
		sdk_v : 0.1,
		mode : 'report',
		appid : 1732820940289,
		key : '02izt42t',
		project_id : '1732052797057'
	});
	(function() {
		var wmda = document.createElement('script');
		wmda.type = 'text/javascript';
		wmda.async = true;
		wmda.src = ('https:' == document.location.protocol ? 'https://'
				: 'http://')
				+ 'j1.58cdn.com.cn/wmda/js/statistic.js?'
				+ (Math.floor(+new Date() / 60000)) * 60;
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(wmda, s);
	})();
</script>
<!-- growingio start -->
<script type="text/javascript">
	var _vds = _vds || [];
	window._vds = _vds;
	(function() {
		_vds.push([ 'setAccountId', '8154da2f94e51dff' ]);
		_vds.push([ 'setImp', false ]);
		_vds.push([ 'setPageGroup', 'list' ]);
		(function() {
			var vds = document.createElement('script');
			vds.type = 'text/javascript';
			vds.async = true;
			vds.src = ('https:' == document.location.protocol ? 'https://'
					: 'http://')
					+ 'dn-growing.qbox.me/vds.js';
			var s = document.getElementsByTagName('script')[0];
			s.parentNode.insertBefore(vds, s);
		})();
	})();
</script>
<!-- growingio end -->

</head>
<body>
	<div id="list">
		<div id="list_bg"></div>
		<div class="top" id="top">
			<div class="lunaSearch">
				<a href="//luna.58.com/m/autotemplate?city=bj&amp;temname=juhe_common" class="logo">
					<img src="http://img.58cdn.com.cn/crop/biz/m/lunaHome/pic/img/logo.png" alt="">
				</a>
				<div class="searchTxtarea">
					<a
						href="//luna.58.com/city.shtml?-15=20&amp;plat=m&amp;url=http%3A%2F%2Fluna.58.com%2Flist.shtml%3F%26plat%3Dm%26cate%3Dbaomu%26PGTID%3D0d200000-0000-1732-ddeb-d3c8c11ec6af%26-15%3D20%26tag%3Djuhe_common_fifthjiazheng_baomu%26ClickID%3D1%26city%3D__CITY__"
						class="city">
						<i>北京</i>
					</a>
					<span>
						<form action="">
							<input type="text" class="searchArea" disabled="disabled" placeholder="找工作 找房子 找搬家">
						</form>
					</span>
				</div>
			</div>
			<div class="filter">
				<ul class="filter_title">
					<li>
						<span>区域</span>
					</li>
					<li>
						<span>类别</span>
					</li>
				</ul>
				<div class="filterContainer">
					<div class="filterBox"></div>
				</div>
			</div>
		</div>
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
				<li data-adtype="20">
					<a class="huangye_list_demo_a " href="#">
						<img class="list-img" data-url="http://pic1.58cdn.com.cn/p1/small/n_v1bkujjd4sipnfqincimtq.jpg">
						<dl>
							<dt class="huangye-title">家政公司为您提供专业服务!</dt>
							<dd class="attr-demo list-details">回龙观-北京我帮你家政服务有限公司</dd>
							<span class="list-vip-sign">会员</span>
						</dl>
					</a>
					<a class="huangye_list_demo_phone"></a>
				</li>
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
				<li class="recommendTags">
					<a class="recommendTag0" href="#">推荐1</a><a class="recommendTag1" href="#">推荐2</a><a class="recommendTag2" href="#">推荐3</a><a class="recommendTag3" href="#">推荐4</a><a class="recommendTag4" href="#">推荐5</a><a class="recommendTag5" href="#">推荐6</a>
				</li>
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
				<jsp:include page="/WEB-INF/include/huangye_common_ad.jspf" />
			</ul>
		</div>
		<div class="load" id="infomore">
			<i></i>加载更多
		</div>
		<div id="bottom">我是有底线的，没有更多信息啦~</div>
	</div>
	<div class="searchBox">
		<div class="searchInput">
			<div class="searchTxtarea">
				<a
					href="//luna.58.com/city.shtml?-15=20&amp;plat=m&amp;url=http%3A%2F%2Fluna.58.com%2Flist.shtml%3F%26plat%3Dm%26cate%3Dbaomu%26PGTID%3D0d200000-0000-1732-ddeb-d3c8c11ec6af%26-15%3D20%26tag%3Djuhe_common_fifthjiazheng_baomu%26ClickID%3D1%26city%3D__CITY__"
					class="city">北京</a>
				<span><form action="">
						<input type="text" placeholder="找工作 找房子 找搬家" class="searchArea">
					</form></span>
			</div>
			<span class="close">取消</span>
		</div>
		<div class="searchHistory">
			<h2>浏览历史</h2>
			<div class="historyList"></div>
		</div>
		<div class="searchList"></div>
	</div>
	<script>
		var __lm_infolist = lm_infolist, __lm_filter = lm_filter;
	</script>
	<!-- <script src="//j1.58cdn.com.cn/crop/biz/m/hezuoM/js/pages/list_20_huangye_new_v20170927153839.js" charset="utf-8"></script> -->

	<script src="//tracklog.58.com/referrer_m.js" async=""></script>
	<script src="//wechat.58.com/google-analytics" async=""></script>





	<div id="addInfo" style="display: none;">
		<a href="#">推荐信息</a>
	</div>
</body>
</html>
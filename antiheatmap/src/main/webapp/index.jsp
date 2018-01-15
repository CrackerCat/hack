<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<title>M端热力图</title>
		
		<!-- 引入 Bootstrap -->
		<%-- <link href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css" rel="stylesheet"> --%>
    	<link href="./bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
    	<link href="./bootstrap/validator/css/bootstrapValidator.min.css" rel="stylesheet" media="screen">
	    <link href="./bootstrap/datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
	    
	    <script src="http://upcdn.b0.upaiyun.com/libs/jquery/jquery-2.0.2.min.js"></script>
		<script src="./bootstrap/js/bootstrap.min.js"></script>
		<script src="./bootstrap/validator/js/bootstrapValidator.min.js"></script>
		<script src="./bootstrap/datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
		<script src="./bootstrap/datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
	</head>
	<body>
		<div align="center" style="padding: 40px 0px;">
			<div id="logo" style="margin:0px 0px 40px 0px;">
				<img src="${pageContext.request.contextPath }/img/logo-58.png" class="img-responsive" alt="58 logo">
			</div>
  
  			<form id="heatmap_form" method="post" target="_blank"  style="width:50%;">
  				<div class="form-group">
  					<label style="display:flex;">spm</label>
  					<input type="text" class="form-control" aria-describedby="sizing-addon1" id="spm" name="spm">
				</div>
				
				<div>
					<div class="form-group">
  						<label style="display:flex;">开始日期</label>
	                	<div class="input-group date form_date">
	                		<!-- <span class="input-group-addon" style="width:120px;">开始日期</span> -->
	                    	<input id="start_date" class="form-control" type="text" name="start_date" value="" style="background: white" readonly>
							<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
	                	</div>
	                </div>
	                <div class="form-group">
  						<label style="display:flex;">结束日期</label>
	                	<div class="input-group date form_date">
	                		<!-- <span class="input-group-addon" style="width:120px;">结束日期</span> -->
	                    	<input id="end_date" class="form-control" type="text" name="end_date" value="" style="background: white" readonly>
							<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
	                	</div>
	                </div>
            	</div>
            	<input type="hidden" name="action_type" id="action_type" value=""/>
            	<div>
					<button type="submit" style="width:130px;margin:5px;" class="btn btn-info " id="heatmap_1" onclick="click_input(this)">全页面热力图</button>
					<button type="submit" style="width:130px;margin:5px;" class="btn btn-info " id="heatmap_2" onclick="click_input(this)">单广告位热力图</button>
					<button type="submit" style="width:130px;margin:5px;" class="btn btn-info " id="clickmap_1" onclick="click_input(this)">全页面点击图</button>
					<button type="submit" style="width:130px;margin:5px;" class="btn btn-info " id="clickmap_2" onclick="click_input(this)">单广告位点击图</button>
					<button type="button" style="width:130px;margin:5px;" class="btn btn-info " id="test_bn" onclick="testmotion(this)">坐标测试</button>
				</div>
				
				<div id="coor_input" style="display: none;">
					<div class="form-group">
    					<label for="disp_id" class="col-sm-2 control-label">展现ID</label>
    					<div class="col-sm-9">
      						<input type="text" class="form-control" name="sid">
    					</div>
  					</div>
  					<div class="form-group">
    					<label for="ent_id" class="col-sm-2 control-label">EntityId</label>
    					<div class="col-sm-9">
      						<input type="text" class="form-control" name="entid">
    					</div>
  					</div>
  					<div class="form-group">
    					<label for="clk_time" class="col-sm-2 control-label">ClickTime</label>
    					<div class="col-sm-9">
      						<input type="text" class="form-control" name="clktime">
    					</div>
  					</div>
					<div class="form-group">
					  <div class="col-sm-offset-2 col-sm-9">
					    <button type="submit" class="btn btn-default" id="heatmap_3" onclick="click_input(this)">确定</button>
					    <button type="submit" class="btn btn-default" id="heatmap_4" onclick="click_input(this)">取消</button>
					  </div>
					</div>
				</div>
			</form>
		</div>
	



<script type="text/javascript">
	$('.form_date').datetimepicker({
        format: 'yyyy-mm-dd',
        language:  'zh-CN',
        weekStart: 1,
        todayBtn:  1,
		autoclose: 1,
		todayHighlight: 1,
		startView: 2,
		minView: 2,
		forceParse: 0
    });
	


	$(function () {
        $('form').bootstrapValidator({
        	message: 'This value is not valid',
        	feedbackIcons: {
        		valid: 'glyphicon glyphicon-ok',
        		invalid: 'glyphicon glyphicon-remove',
        		validating: 'glyphicon glyphicon-refresh'
        	},
            fields: {
                spm: {
                    message: 'spm empty',
                    validators: {
                        notEmpty: {
                            message: 'Please input spm'
                        }
                    }
                }
            }
        });
        
    });
	function click_input(element) {
		$('#heatmap_form').attr('action', '/antiheatmap/heatmap');
		$('#action_type').val(element.id);
/* 		if(element.id == "heatmap_1") {
			$('#action_type').attr('value', 'whole');
		}else if (element.id == "heatmap_2") {
			$('#action_type').attr('value', 'single');
		}else if (element.id == "heatmap_3") {
			$('#action_type').attr('value', 'test');
		} */
	}
	function testmotion(element){
		var ele = $('#coor_input');
		if (ele.css('display') === 'none'){
			ele.slideDown('slow');
			element.innerText = '收起';
		}else{
			ele.slideUp('slow');
			element.innerText = '坐标测试';
		}
	}
	
	$("#spm").click(function () {
        $(this).focus().select();
        this.selectionStart = 0;
        this.selectionEnd = this.val().length;
    })
</script> 

</body>
</html>



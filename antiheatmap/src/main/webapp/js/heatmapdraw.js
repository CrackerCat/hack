// 根据坐标绘制点击
function drawCoordinate(canvas_contex, devicedpix, devicedpiy, coordinate_x,
		coordinate_y, dpi_x, dpi_y, alpha) {
	// alpha: 透明度
	canvas_contex.strokeStyle = "#0000FF";
	canvas_contex.globalAlpha = alpha;

	/*coordinate_x = 1.0 * devicedpix * coordinate_x / dpi_x;
	coordinate_y = 1.0 * devicedpiy * coordinate_y / dpi_y;*/

	canvas_contex.beginPath();
	canvas_contex.moveTo(coordinate_x - 2, coordinate_y - 2);
	canvas_contex.lineTo(coordinate_x + 2, coordinate_y + 2);
	canvas_contex.moveTo(coordinate_x + 2, coordinate_y - 2);
	canvas_contex.lineTo(coordinate_x - 2, coordinate_y + 2);
	canvas_contex.closePath();
	canvas_contex.stroke();
}

// 渲染热力图
function drawHeatmap(data) {
	var cvs_number = undefined;
    var max = 0;
    for (var i = 0; i < data.length; i++) {
    	var coordinate_x = 1.0*(data[i].slideend_x -data[i].entity_x)/data[i].entity_width*config_width;
		var coordinate_y = 1.0*(data[i].slideend_y -data[i].entity_y)/data[i].entity_height*config_height;
		cvs_number = Number(data[i].pos);

        var point = {
            x: coordinate_x,
            y: coordinate_y,
            value: 50,
            radius: 2
        };
        //pointsArray[cvs_number].push(point);
        heatmapInstances[cvs_number].addData(point);
    }
}


//渲染热力图
function drawHeatmap_v2(data) {
	var pointsArray = [];
    var max = 0;
    for (var i = 0; i < data.length; i++) {
    	var coordinate_x = 1.0*(data[i].slideend_x -data[i].entity_x)/data[i].entity_width*config_width;
		var coordinate_y = 1.0*(data[i].slideend_y -data[i].entity_y)/data[i].entity_height*config_height;

        var point = {
            x: coordinate_x,
            y: coordinate_y,
            value: 30,
            radius: 2
        };
        pointsArray.push(point);
    }
    return pointsArray;
}





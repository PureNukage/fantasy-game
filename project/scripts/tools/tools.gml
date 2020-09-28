function approach(a, b, amount) {
	if (a < b) {
		a += amount
		if (a > b)
		return b
	} else {
		a -= amount
		if (a < b)
		return b
	}
	return a 	
}

function wave(from, to, duration, offset) {
	var a4 = (to - from) * 0.5
	return from + a4 + sin((((current_time * 0.0001) + duration * offset) / duration) * (pi*2)) * a4	
}

function wrap(value, Min, Max) {
	var _val = value
	var _max = Min
	var _min = Max

	if(_val mod 1 == 0) {
		while(_val > _max || _val < _min) {
			if(_val > _max) {
				_val = _min + _val - _max - 1	
			} else if (_val < _min) {
				_val = _max + _val - _min + 1
			} else _val = _val 
		}
		return _val
	} else {
		var _old = value + 1
		while (_val != _old) {
			_old = _val
			if(_val<_min) {
				_val = _max - (_min - _val)	
			} else if (_val > _max) {
				_val = _min + (_val - _max)
			} else _val = _val
		}
		return _val
	}	
}
	
function draw_text_outlined(x, y, String, text_color, outline_color) {
	var xx = x;
	var yy = y;
	var s = String;
	var c1 = text_color;
	var c2 = outline_color;

	draw_set_color(c2);
	draw_text(xx+1, yy+1, s);
	draw_text(xx-1, yy+1, s);
	draw_text(xx+1, yy-1, s);
	draw_text(xx-1, yy-1, s);

	draw_set_color(c1);
	draw_text(xx, yy, s);
}
	
function draw_reset() {
	
	draw_set_color(c_black)
	draw_set_alpha(1)
	draw_set_font(-1)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
}
	
function create_item(Name) constructor {
	name = Name
}

function create_dialogue(body_text, ID, Next) {
	
	var Box = instance_create_layer(0,0,"Instances",textbox)
	Box.textComplete = body_text
	Box.distanceTarget = ID
	Box.next = Next
	
}

function load_dialogue(stringID) {
	
	var width = ds_grid_width(app.dialogueGrid)
	var height = ds_grid_height(app.dialogueGrid)
	var DialogueIndex = 0
	var Dialogue = []
	for(var i=0;i<height;i++) {
		var key = app.dialogueGrid[# 0, i]
		var next = app.dialogueGrid[# 1, i]
		var String = app.dialogueGrid[# 2, i]
		
		//	This dialogue is mine!
		if is_string(key) and !string_length(key) == 0 and string_count(stringID,key) > 0 {
			Dialogue[DialogueIndex][0] = String
			if sign(real(next)) == -1 {
				Dialogue[DialogueIndex][1] = real(next) + 1	
			} else Dialogue[DialogueIndex][1] = real(next) - 1
			DialogueIndex++
		}
	}
	
	return Dialogue
	
}
	
function pathfind(Grid, Path, xStart, yStart, xGoal, yGoal, diag) {
	
	if !mp_grid_path(Grid,Path, xStart, yStart, xGoal, yGoal, diag) {
		debug.log("Unable to path to this destination!")	
		return false
	}
	
	else {
		pos = 1
		xGoto = path_get_point_x(Path, pos)	
		yGoto = path_get_point_y(Path, pos)
		return true
	}
	
}
if on {
	
	//	Camera variables
	var XX = 15
	var YY = 15
	draw_set_color(c_black)
	if instance_exists(app) with app {
		draw_text(XX,YY,"paused: "+string(paused)) YY += 15
		
		draw_text(XX,YY,"camera_view_x: "+string(camera_get_view_x(camera))) YY += 15
		draw_text(XX,YY,"camera_view_y: "+string(camera_get_view_y(camera))) YY += 15
	}
	
	if instance_exists(player) with player {
		draw_set_color(c_black)
		draw_set_alpha(1)
		draw_text(XX,YY, "x: "+string(x)) YY += 15
		draw_text(XX,YY, "y: "+string(y)) YY += 15
		draw_text(XX,YY, "z: "+string(z)) YY += 15	
	}
	
	
	////	DEBUG MENU
	var menu = {
		width: 300,
		height: 100,
		x: 640 - 300 - 16,
		y: 30,
	}
	
	draw_set_color(c_gray)
	draw_rectangle(menu.x,menu.y,menu.x+menu.width,menu.y+menu.height,false)
	
	//	gobling attack button
	var bX = menu.x + 15
	var bY = menu.y + 15
	var bWidth = 200
	var bHeight = 30
	if point_in_rectangle(mouse_gui_x,mouse_gui_y,bX,bY,bX+bWidth,bY+bHeight) {
		draw_set_color(c_ltgray)
		if input.mouseLeftPress {
			app.debug_GOBLIN_ATTACK = true
			class_npc.dialogueIndex = 7
			class_npc.sprite_index = s_granny_devious
		}
	}
	else {
		draw_set_color(c_dkgray)
	}
	draw_rectangle(bX,bY,bX+bWidth,bY+bHeight,false)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(bX+bWidth/2,bY+bHeight/2,"ADVANCE GOBLIN QUEST")
	
	
	
	//	equip torch button
	var bX = menu.x + 15
	var bY = menu.y + 15 + bHeight + 15
	var bWidth = 200
	var bHeight = 30
	if point_in_rectangle(mouse_gui_x,mouse_gui_y,bX,bY,bX+bWidth,bY+bHeight) {
		draw_set_color(c_ltgray)
		if input.mouseLeftPress {
			app.hasTorch = true
			player.hasTorch = true
		}
	}
	else {
		draw_set_color(c_dkgray)
	}
	draw_rectangle(bX,bY,bX+bWidth,bY+bHeight,false)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(bX+bWidth/2,bY+bHeight/2,"giff torch")
	
}
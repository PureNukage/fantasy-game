//if live_call() return live_result;

////	Player is DEAD
if instance_exists(player) and !player.alive {
	var centerX = display_get_gui_width()/2
	var YY = 80
	
	draw_set_color(c_white)
	draw_set_font(fnt_respawn)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(centerX,YY,"Press <E> to respawn")
	
	draw_reset()
}

if interactionCooldown >= 0 interactionCooldown--

if interaction {
	var centerX = display_get_gui_width()/2
	var centerY = display_get_gui_height()/2
	
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(centerX,centerY,"Press <E> to interact")
	
	if input.keyInteract and interactionID > -1 and interactionCooldown == -1 and !instance_exists(textbox) {
		with class_npc {
			var ID = id
		}
		if !instance_exists(textbox) {
			var String = ID.dialogue[ID.dialogueIndex][0]
			var Next = ID.dialogue[ID.dialogueIndex][1]
			create_dialogue(String, ID, Next)
		}
	}
	draw_health = false
	draw_stamina = false
	draw_inventory = false
}

else {
	//draw_health = true
	//draw_stamina = true
	//draw_inventory = true	
}

draw_reset()

////	Player Health and Stamina
if instance_exists(player) {
	var healthX = 15
	var healthY = 15
	var healthWidthContainer = 32
	var healthHeightContainer = 140
	var healthHeightBar = (player.hp / player.hpMax) * healthHeightContainer
	if draw_health { 
		draw_set_color(c_black)
		draw_roundrect(healthX,healthY,healthX+healthWidthContainer,healthY+healthHeightContainer,true)
		draw_set_color(c_red)
		draw_roundrect(healthX,healthY,healthX+healthWidthContainer,healthY+healthHeightBar,false)
	}

	var staminaX = healthX + healthWidthContainer + 8
	var staminaY = healthY
	var staminaWidthContainer = 32
	var staminaHeightContainer = 140
	var staminaHeightBar = (player.stamina / player.staminaMax) * staminaHeightContainer
	if draw_stamina {
		draw_set_color(c_black)
		draw_roundrect(staminaX,staminaY,staminaX+staminaWidthContainer,staminaY+staminaHeightContainer,true)
		draw_set_color(c_green)
		draw_roundrect(staminaX,staminaY,staminaX+staminaWidthContainer,staminaY+staminaHeightBar,false)
	}
}

if draw_inventory {
	//inventory.x = display_get_gui_width() - inventory.width - 15
	//inventory.y = display_get_gui_height() - inventory.height - 15

	//draw_set_color(c_yellow)
	//draw_rectangle(inventory.x,inventory.y, inventory.x+inventory.width,inventory.y+inventory.height,false)

	////	Draw inventory boxes
	//var xx = inventory.x
	//var yy = inventory.y
	//for(var i=0;i<4;i++) {
	//var Name = ""
	////	Empty slot
	//if inventory.slots[i] == -1 {
		
	//}
	////	Slot has an item
	//else {
	//	Name = inventory.slots[i].name
	//}
	
	////	Draw slot
	//draw_set_color(c_black)
	//draw_rectangle(xx-2,yy-2,xx + (inventory.width/2) + 2, yy + (inventory.height/2) + 2,false)
	//if point_in_rectangle(mouse_gui_x,mouse_gui_y,xx,yy,xx + (inventory.width/2), yy + (inventory.height/2)) {
	//	draw_set_color(c_ltgray)	
	//} else {
	//	draw_set_color(c_gray)
	//}
	//draw_rectangle(xx,yy,xx + (inventory.width/2), yy + (inventory.height/2),false)
	
	//draw_set_color(c_black)
	//draw_set_halign(fa_center)
	//draw_set_valign(fa_middle)
	//draw_text(xx + (inventory.width/2) / 2, yy + (inventory.height/2) / 2, Name)
	
	//if i == 0 {
	//	xx += (inventory.width/2)
	//}
	//if i == 1 {
	//	xx = inventory.x
	//	yy = inventory.y + (inventory.height/2)
	//}
	//if i == 2 {
	//	xx += (inventory.width/2)	
	//}
	
//}
	
}

draw_reset()
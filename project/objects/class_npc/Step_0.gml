if !app.paused {

	if point_distance(x,y, player.x,player.y-(sprite_get_height(player.sprite_index)/4)) < 25 {
		if !interaction or !gui.interaction {
			interaction = true
			gui.interaction = true
			gui.interactionID = id
		}
	}

	else {
		if interaction {
			interaction = false
			gui.interaction = false
			if gui.interactionID == id gui.interactionID = -1
			gui.draw_health = true
			gui.draw_inventory = true
			gui.draw_stamina = true
		}
	}
	
}

else image_speed = 0

depth = -y
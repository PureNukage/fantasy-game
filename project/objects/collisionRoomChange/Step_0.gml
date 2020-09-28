if Room > -1 and place_meeting(x,y,player) {
	app.roomGoto(Room, Direction, pair, transition_type)
}

if instance_exists(player) and Room > -1 and point_distance(x,y,player.x,player.y) < 75 {
	if !closeToPlayer {
		closeToPlayer = true
		gui.draw_health = false
		gui.draw_stamina = false
		gui.draw_inventory = false	
	}
}

else if closeToPlayer {
	gui.draw_health = true
	gui.draw_stamina = true
	gui.draw_inventory = true
	closeToPlayer = false
}
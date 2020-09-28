if app.savePostRoom > -1 and app.savePostRoom == room and app.savePostIndex == ID spawnpoint = true

if point_distance(x,y, player.x,player.y) < 200 and !dinged {
	player.mask_index = player.sprite_index
	if place_meeting(x,y,player) and player.state == state.attack {
		dinged = true
		if !spawnpoint {
			spawnpoint = true
			app.savePostRoom = ID
			
			var Camera = instance_create_layer(player.x-32,player.y-32,"Instances",collisionCameraFocus)
			Camera.image_xscale = 4
			Camera.image_yscale = 4
			Camera.temporary = true
			Camera.duration = 150
			Camera.focusX = x
			Camera.focusY = y - 32
			Camera.cinematic = true
			app.setDisplayZone(text)
		}
	}
	player.mask_index = s_player_collision
}


if dinged ding()

depth = -y
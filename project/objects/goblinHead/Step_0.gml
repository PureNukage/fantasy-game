if !app.paused {

	if !onGround applyThrust()

	if point_distance(x,y, player.x,player.y) < 200 and !damaged {
		player.mask_index = player.sprite_index
		if place_meeting(x,y,player) and player.state == state.attack and player.attackCharge == -1 {
			//knockbackDirection = point_direction(player.x,player.y, x,y)
			//knockbackForce = 5
			if player.attackCharged knockbackForce = 5 + 3
			if player.attackCharged {
				if alive app.paused = true
				if alive app.pausedTimer = 15
				if alive instance_create_layer(x,y-32,"Instances",goblinHead)
				damaged = true
				damagedTimer = 30
				damagedFlash = true
				alive = false
				setThrust(3)
			} else {
				damaged = true
				damagedTimer = 30
				damagedFlash = true
			}
		}
		player.mask_index = s_player_collision
	}
	
	if knockbackForce > 0 {
		knockbackForce -= 0.5
		setForce(knockbackForce, knockbackDirection)
	}

	if damagedTimer > -1 {
		damagedTimer--
		if damagedTimer < 15 {
			damagedFlash = false	
		}
	}
	else {
		damaged = false	
	}

	applyMovement()

	if !onGround {
		x = groundX
	}

	else {
		x = groundX
		y = groundY + z
	}
	
}

else image_speed = 0

depth = -y
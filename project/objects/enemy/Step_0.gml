if !app.paused {
	
	if alive {
		if goal == -1 {
		
			if attack {
				attackDelay++
			
				if attackDelay >= attackDelayMax {				
					if pathfind(grid.mpGrid,path,x,y,attackX,attackY,true) {
						debug.log("I am attacking!")
					
						goal = goal_attack
					
						attackForce = 10
					
						attackDelay = 0
					
						sprite_index = s_goblin_attack
						image_index = 0 
					
						if attackX > x image_xscale = 1
						else if attackX < x image_xscale = -1
					}
				}
				
				aggroCheck()
			}
		
			else if aggro {
			
				//	Find a spot within attack distance of the player
				var hSide = sign(x - player.x)
				var vSide = sign(y - player.y)
			
				var X = irandom_range(player.x, player.x + attackRange*hSide)
				var Y = irandom_range(player.y, player.y + attackRange*vSide)
			
				if pathfind(grid.mpGrid,path,x,y,X,Y,true) {
					debug.log("I am chasing!")
					goal = goal_chase
					
					sprite_index = s_goblin_hop
					image_index = 0
				}
				
				aggroCheck()
			
			} 
		
			else if wander {
			
				if wanderTimer == -1 {
					var range = 150
					var X = irandom_range(x-range,x+range)
					var Y = irandom_range(y-range,y+range)
			
					if pathfind(grid.mpGrid,path,x,y,X,Y,true) {
						debug.log("I am wandering!")
						goal = goal_wander
					
						path_set_precision(path,8)
						
						sprite_index = s_goblin_hop
						image_index = 0
					}
				} else wanderTimer--
			
				playerCheck(200)
			}
		}
		else {
		switch(goal) { 
			#region Wander // Chase 
				case goal_wander:
				case goal_chase:
				
					moveDirection = point_direction(x,y,xGoto,yGoto)
				
					if point_distance(x,y,xGoto,yGoto) < 6 {
						if pos++ >= path_get_number(path)-1 {
							if goal == goal_wander {
								wanderTimer = irandom_range(120,180)
								
								sprite_index = s_goblin_idle
								image_index = 0
							} else if goal == goal_chase {
								attack = true
								attackX = player.x
								attackY = player.y
							}
							goal = -1
						}
					
						else {
							xGoto = path_get_point_x(path,pos)
							yGoto = path_get_point_y(path,pos)
						}
					}
					else {
						setForce(1, moveDirection)
					}
				
				break
			#endregion
			
			#region Attack
				case goal_attack:
				
					image_speed = 1
					
					moveDirection = point_direction(x,y, attackX,attackY)
					
					if point_distance(x,y,attackX,attackY) < 5 attackForce = 0
					
					if attackForce > 0 {
						setForce(attackForce, moveDirection)
						attackForce -= 0.5
						
						if image_index >= 7 {
							image_index = 7
						}
					}
					
					else {
						if animation_end {
							goal = -1
							attack = false
						
							playerCheck()
						}
					}
					
				break
			#endregion
		}
	}
			
	}
		
	//	Player damage
	if point_distance(x,y, player.x,player.y) < 200 and !damaged {
		player.mask_index = player.sprite_index
		if place_meeting(x,y,player) {
			if player.state == state.attack and player.attackCharge == -1 {
				knockbackDirection = player.moveDirection //point_direction(player.x,player.y, x,y)
				knockbackForce = 5
				if player.attackCharged knockbackForce = 5 + 3
				if player.attackCharged {
					if alive {
						app.paused = true
						app.pausedTimer = 5
						player.image_index = 2
						sprite_index = s_goblin_headless_body
						var Head = instance_create_layer(x,y-32,"Instances",goblinHead)
						Head.knockbackForce = 5
						Head.knockbackDirection = player.moveDirection
						Head.image_xscale = image_xscale
						alive = false
						setDamage(5, 25, false, 10)
					}
				} else {
					setDamage(1, 25, true, 10)
				}
			} else {
				if alive and goal == goal_attack and !player.damaged {
					player.setDamage(2, 90, true, 75)		
				}
			}
		}
		player.mask_index = s_player_collision
	}	

	if knockbackForce > 0 {
		knockbackForce -= 0.5
		setForce(knockbackForce, knockbackDirection)
	}

	damage()
	
	if hp <= 0 {
		alive = false
		sprite_index = s_goblin_headless_body
	}
	
	if xx != 0 or yy != 0 {	
		if goal != goal_attack {
			if xx > 0 image_xscale = 1
			else if xx < 0 image_xscale = -1
			
			//if alive {
			//	if sprite_index != s_goblin_hop sprite_index = s_goblin_hop
			//}
		}
		
		if wander image_speed = 0.5
		else image_speed = 1
	}
	else {
		//if alive {
		//	if goal == goal_attack {
		//		if animation_end sprite_index = s_goblin_idle	
		//	}
		//	else sprite_index = s_goblin_idle	
		//}
	}

	applyMovement()
	
	//if damaged and alive sprite_index = s_goblin_struck

	if onGround {
		x = groundX
		y = groundY
	}
	else {
		
	}
	
}
	
else image_speed = 0

depth = -y
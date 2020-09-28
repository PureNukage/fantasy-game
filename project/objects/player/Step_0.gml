if !app.paused {
	
	if alive {

		switch(state)
		{
		#region Free State
			case state.free:
				hspd = (input.keyRight - input.keyLeft) + gamepad_axis_value(0, gp_axislh)
				vspd = (input.keyDown - input.keyUp) + gamepad_axis_value(0, gp_axislv)
			
				if stamina < staminaMax {
							
					//	Determine recharge rate
					var division = staminaMax / 5
					if stamina >= division * 4 {
						staminaRechargeRate = 1
					} else if stamina >= division * 3 and stamina < division * 4 {
						staminaRechargeRate = 2
					} else if stamina >= division * 2 and stamina < division * 3 {
						staminaRechargeRate = 2	
					} else if stamina >= division * 1 and stamina < division * 2 {
						staminaRechargeRate = 4	
					} else if stamina < division {
						staminaRechargeRate = 4
					}
				
	
					staminaRecharge++
					if staminaRecharge >= staminaRechargeRate {
						stamina++
						staminaRecharge = 0
					}
				}

				if onGround and !falling and input.keyJump {
					setThrust(5)
					//preJump = true
					//sprite_index = s_player_jump
					//image_index = 0
				}
				

				if !onGround and !falling applyThrust()
			
				var attackStaminaCost = 15
				if onGround and input.keyAttack and stamina >= attackStaminaCost {
					state = state.attack
					stamina -= attackStaminaCost
					moveForce = 3
					switch(sprite_index) {
						case s_player_idle_front:
						case s_player_walk_front: 
							sprite_index = s_player_attack_front
							image_xscale *= -1
						break
					
						case s_player_idle_side: 
						case s_player_walk_side: sprite_index = s_player_attack_side break
					
						case s_player_idle_back:
						case s_player_walk_back: 
							sprite_index = s_player_attack_back 
							image_xscale *= -1
						break
					
					}
					image_index = 0
					image_speed = 1
				
					sound.playSoundEffect(snd_sword_swing)
					audio_sound_pitch(snd_sword_swing,1)
				
					exit
				}

				if falling fall()

				var maxMoveSpeed = 2

				//	Inputting movement
				if (hspd != 0 or vspd != 0) {
	
					if onGround and !falling {
						if vspd == 0 {
							sprite_index = s_player_walk_side
						} else {
							if vspd > 0 sprite_index = s_player_walk_front
							else sprite_index = s_player_walk_back
						}
					
						//if !audio_is_playing(snd_footsteps_soft) sound.playSoundEffect(snd_footsteps_soft)
					
					}
					if hspd != 0 and sign(image_xscale) != sign(hspd) image_xscale = xscale * sign(hspd)
					image_speed = moveForce / maxMoveSpeed
	
					moveDirection = point_direction(0,0,hspd,vspd)
					moveForce += 0.15 * clamp(abs(hspd)+abs(vspd),-1,1)
	
					if falling moveForce *= xscale
	
					moveForce = clamp(moveForce, 0, maxMoveSpeed)
	
					setForce(moveForce, moveDirection)
				
					//debug.log("Moving at "+string_upper(string(moveForce)) + " force and in "+string_upper(string(moveDirection)) +" direction")
	
				}
				//	Not inputting movement
				else {
					image_speed = moveForce / maxMoveSpeed
					if moveForce > 0 {
						moveForce -= 0.25
						setForce(moveForce, moveDirection)
					} else {
						if onGround and !falling {
							switch(sprite_index) {
								case s_player_walk_front: sprite_index = s_player_idle_front break
								case s_player_walk_side: sprite_index = s_player_idle_side break
								case s_player_walk_back: sprite_index = s_player_idle_back break
							}
							image_speed = 1
						}
					}
				}
				
				applyMovement()

				if !onGround {
					x = groundX
					
					//	Jumping sprite
					//if thrust > 0 {
						//image_index = clamp(image_index,0, 8)
						//if image_index > 6 and image_index < 10 {
						//	sprite_set_offset(sprite_index, sprite_get_xoffset(sprite_index), 45)	
						//}
					//}
					
				}

				else {
					x = groundX
					y = groundY + z
				}
			break
		#endregion
	
		#region Attack State
			case state.attack:
		
				if image_speed != 1 image_speed = 1
		
				var attackStaminaCost = 30
				if attackCharge == -1 {
			
				if animation_end {
						if !input.keyAttackHold or attackCharged or stamina < attackStaminaCost {
							switch(sprite_index) {
								case s_player_attack_front: sprite_index = s_player_idle_front break
								case s_player_attack_side: sprite_index = s_player_idle_side break
								case s_player_attack_back: sprite_index = s_player_idle_back break
							}
				
							state = state.free	
							attackCharged = false
							attackCharge = -1
						}
				
						else {
							if attackCharge == -1 {
								switch(sprite_index) {
									case s_player_attack_side:
										image_index = 0
									break
									case s_player_attack_front:
										image_xscale *= -1
										image_index = 0
									break
									case s_player_attack_back:
										image_xscale *= -1
										image_index = 0
									break
								}
								image_speed = 0
								attackCharge++
							}
						}
					}
				}
				//	Charging attack
				else {
					if input.keyAttackHold {
						image_speed = 0
						attackCharge++	
					
						if attackCharge >= 30 {
							attackCharged = true
							image_speed = 1
							attackCharge = -1
							moveForce = 5
							stamina -= attackStaminaCost
						
							sound.playSoundEffect(snd_sword_swing)
							audio_sound_pitch(snd_sword_swing, 0.5)
						}
					}
				
					else {
						attackCharged = true
						image_speed = 1
						attackCharge = -1
						moveForce = 5
						stamina -= attackStaminaCost
					
						sound.playSoundEffect(snd_sword_swing)
						audio_sound_pitch(snd_sword_swing, 0.5)
					}
				}
			
				if moveForce > 0 {
					moveForce -= 0.5
					setForce(moveForce, moveDirection)	
				}
				
				if !onGround applyThrust()
			
				applyMovement()
			
				if !onGround {
					x = groundX
				}

				else {
					x = groundX
					y = groundY + z
				}
			
			break
		#endregion
		}
	
		damage()
		
		if hp <= 0 alive = false
	
	}
	else {
		sprite_index = s_player_dead
		image_xscale = 1
		
		gui.draw_health = false
		gui.draw_inventory = false
		gui.draw_stamina = false
		
		if input.keyInteract {
			app.loading = true	
		}
	}
}

else {
	image_speed = 0
}

depth = -y
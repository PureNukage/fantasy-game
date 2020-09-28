hspd = 0
vspd = 0
onGround = true
preJump = false
postJump = false
groundX = x
groundY = y
grav = 0.4
z = 0
xx = 0
yy = 0
xscale = image_xscale
yscale = image_yscale
moveForce = 0
moveDirection = -1
knockbackForce = 0
knockbackDirection = -1
thrust = 0
map = -1
falling = false
fallen = false
preFalling = false
state = state.free
damaged = false
damagedTimer = -1
damagedFlash = false
damagedFlashTimer = -1
hpMax = 5
hp = hpMax
staminaRecharge = -1
staminaRechargeRate = 5
staminaMax = 100
stamina = staminaMax
alive = true

function setDamage(amount, duration, _flash, _flashTimer) {
	damaged = true
	damagedFlash = _flash
	damagedTimer = duration
	damagedFlashTimer = _flashTimer
	
	hp -= amount
}

function damage() {
	if damagedTimer > -1 {
		damagedTimer--
		if damagedFlashTimer > -1 and damagedTimer < damagedFlashTimer {
			damagedFlash = false	
		}
	}
	else {
		damaged = false	
	}	
}

function setThrust(Thrust) {
	onGround = false
	thrust = Thrust
}

function fall() {
	var Lerp = 0.05
	//xscale = lerp(xscale, sign(image_xscale) * 0.05, Lerp)
	//yscale = lerp(yscale, sign(image_yscale) * 0.05, Lerp)
	////image_xscale = xscale
	//image_yscale = yscale
	
	//thrust -= 0.05
	thrust -= grav
	z += thrust
	
	var maximumVelocity = 20
	thrust = clamp(thrust,-maximumVelocity,maximumVelocity)
	
	if abs(y-z) >= camera_get_view_y(app.camera) + app.height {
		fallen = true
		alive = false
		if object_index == player app.cameraOnPlayer = false
	}
}

function applyThrust() {
	
	thrust -= grav
	z += thrust
		
	if y-z >= groundY {
		if map > -1 and map.z == -1 and thrust > -3 {
			preFalling = true
			exit
		}
		//	Falling
		if (place_meeting(x,y-z, collisionMap) and instance_place(x,y-z,collisionMap).z == -1)
		or (map > -1 and map.z == -1) {
			if map == -1 map = instance_place(x,y-z,collisionMap)
			var Map = map 
			if rectangle_in_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom, Map.x,Map.y, Map.x+(sprite_get_width(Map.sprite_index)*Map.image_xscale), Map.y+(sprite_get_height(Map.sprite_index)*Map.image_yscale)) == 1 {
				falling = true
				app.cameraOnPlayer = false
			}
		}
		
		
		if !falling onGround = true
		if !falling y = groundY
		//if !preFalling z = 0
		if !falling thrust = 0
		if map > -1 and map.z > -1 z = map.z
		else z = 0
	}
	
	
}

function setForce(force, direction) {
	
	xx = lengthdir_x(force, direction)
	yy = lengthdir_y(force, direction)

}
	
function changeMap(Map) {
	
	var oldMap = -1
	var Z = -1
	
	if map == -1 Z = 0
	else Z = map.z
	
	oldMap = map
	
	//	Changing to a map
	if Map > -1 {
		
		if Map.z == -1 {
			if rectangle_in_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom, Map.x,Map.y, Map.x+(sprite_get_width(Map.sprite_index)*Map.image_xscale), Map.y+(sprite_get_height(Map.sprite_index)*Map.image_yscale)) != 1 {
				exit	
			}
		}
		
		//	I am stepping down
		if Z > Map.z {
			if Map.z == -1 {
				onGround = false	
			} else {
				groundY = groundY + Map.z
				if groundY > y-z onGround = false
			}
		}
		//	I am jumping up
		else {
			groundY = groundY - Map.z
		}
		
	}
	//	Changing to no map/z = 0
	else {
		groundY = groundY + map.z

		if groundY >= y-z {
			onGround = false
			z -= 1	
		}
	}
	
	map = Map
}

function applyMovement() {
	
	var current_xscale = image_xscale
	var current_yscale = image_yscale
	
	image_xscale = 1
	image_yscale = 1
	
	if !falling {
	
	for(var X=0;X<abs(xx);X++) {
		if !place_meeting(groundX + sign(xx), groundY, collision) {
			if place_meeting(groundX + sign(xx), groundY, collisionMap) {
				var Map = instance_place(groundX + sign(xx), groundY, collisionMap)
				if (z >= Map.z or map == Map) {
					groundX += sign(xx)
					if map == -1 or (map > -1 and map != Map) {
						changeMap(Map)
					}
				} 
				//	We're not high enough to enter this map
				else {
					if groundY < Map.y + Map.z {
						groundX += sign(xx)	
					}
				}
			//	Not colliding with collision or a collisionMap
			}
			else {
				groundX += sign(xx)
				if map > -1 {
					changeMap(-1)	
				}
			}
		}
		//	Collision happening
		else {
			var Collision = instance_place(groundX + sign(xx), groundY, collision)
			if Collision.topWall {
				//	If we are higher than the topWall
				if z >= Collision.map.z {
					if map == -1 or map != Collision.map {
						changeMap(Collision.map) 
					} else if map == Collision.map {
						changeMap(-1)
					}
				}
				else if map == Collision.map {
					changeMap(-1)
				}
			}
		}
	}
	
	for(var Y=0;Y<abs(yy);Y++) {
		if !place_meeting(groundX, groundY + sign(yy), collision) {
			if place_meeting(groundX, groundY + sign(yy), collisionMap) {
				var Map = instance_place(groundX, groundY + sign(yy), collisionMap)
				if (z >= Map.z or map == Map) {
					groundY += sign(yy)
					if !onGround y += sign(yy)
					if map == -1 or (map > -1 and map != Map) {
						changeMap(Map)
					}
				}
				//	We're not high enough to enter this map
				else {
					if groundY + sign(yy) < Map.y + Map.z {
						groundY += sign(yy)
						if !onGround y += sign(yy)
					}					
				}
			}
			//	Not colliding with collision or collisionMap
			else {
				groundY += sign(yy)
				if !onGround y += sign(yy)	
				if map > -1 {
					changeMap(-1)
				}	
			}
		}
		//	Hitting collision
		else {
			var Collision = instance_place(groundX, groundY + sign(yy), collision)
			if Collision.topWall {
				if z >= Collision.map.z {
					if map == -1 or map != Collision.map {
						map = Collision.map
						groundY -= map.z
						while place_meeting(groundX,groundY,Collision) {
							groundY -= 1	
						}
						//changeMap(Collision.map) 
					} else if map == Collision.map {
						groundY += map.z
						while place_meeting(groundX,groundY,Collision) {
							groundY += 1	
						}
						if groundY > y-z onGround = false
						map = -1	
						//changeMap(-1)
					}
				}
				else if map == Collision.map {
					groundY += map.z
					while place_meeting(groundX,groundY,Collision) {
						groundY += 1	
					}
					if groundY > y-z onGround = false
					map = -1
					//changeMap(-1)
				}
			}
		}
	}
		
	}
	
	else {
		for(var X=0;X<abs(xx);X++) {
			//if instance_position(groundX + sign(xx), groundY, map)	groundX += sign(xx)
			if rectangle_in_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,
			map.x,map.y,map.x+sprite_get_width(map.sprite_index)*map.image_xscale,
			map.y+sprite_get_height(map.sprite_index)*map.image_yscale) == 1 {
				groundX += sign(xx)
				x += sign(xx)
			}
		}
		
		for(var Y=0;Y<abs(yy);Y++) {
			//if instance_position(groundX, groundY + sign(yy), map) groundY += sign(yy)
			if rectangle_in_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,
			map.x,map.y,map.x+sprite_get_width(map.sprite_index)*map.image_xscale,
			map.y+sprite_get_height(map.sprite_index)*map.image_yscale) == 1 {
				groundY += sign(yy)
				y += sign(yy)
			}
		}
	}
	
	xx = 0
	yy = 0
	
	image_xscale = current_xscale
	image_yscale = current_yscale
	
}
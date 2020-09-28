creator = ""
version = ""

if instance_number(app) > 1 {
	var Break = 0
	//var ID = id
	//with app if id != ID instance_destroy()
}

var Layer = "Instances"
instance_create_layer(0,0,Layer,input)
instance_create_layer(0,0,Layer,debug)
instance_create_layer(0,0,Layer,time)
instance_create_layer(0,0,Layer,sound)
instance_create_layer(0,0,Layer,gui)
instance_create_layer(0,0,Layer,grid)
instance_create_layer(0,0,Layer,lighting)

paused = false
pausedTimer = -1

hasTorch = false

function scale_canvas(new_width, new_height) {
	window_set_size(new_width, new_height)
	
	//if center {
	//	centerWindow = true
	//}
	
	//surface_resize(application_surface,new_width,new_height)
}
	
function cameraSetup() {

		width = 640
		height = 360
		zoom_level = 1
		
		var fullscreen = false
		var windowWidth = window_get_width()
		var windowHeight = window_get_height()
		var displayWidth = display_get_width()
		var displayHeight = display_get_height()
		if window_get_width() == display_get_width() and (abs(windowHeight - displayHeight) < 100) {
			fullscreen = true
		}

		#region Views

			view_enabled = true
			view_visible[0] = true

			view_set_visible(0,true)

			view_set_wport(0,width)
			view_set_hport(0,height)

		#endregion
		#region Resize and Center Game Window

			if !fullscreen window_set_rectangle((display_get_width()-view_wport[0])*0.5,(display_get_height()-view_hport[0])*0.5,view_wport[0],view_hport[0])
			
			if !fullscreen window_center()
	
			surface_resize(application_surface,view_wport[0],view_hport[0])
	
			display_set_gui_size(width,height)


		#endregion
		#region Camera Create

			camera = camera_create()

			var viewmat = matrix_build_lookat(width,height,-10,width,height,0,0,1,0)
			var projmat = matrix_build_projection_ortho(width,height,1.0,32000.0)

			camera_set_view_mat(camera,viewmat)
			camera_set_proj_mat(camera,projmat)
	
			camera_set_view_pos(camera,x,y)
			camera_set_view_size(camera,width,height)
	
			camera_set_view_speed(camera,200,200)
			camera_set_view_border(camera,width,height)
	
			camera_set_view_target(camera,id)

			view_camera[0] = camera

		#endregion
	
		if !fullscreen scale_canvas(1920,1080)

		default_zoom_width = camera_get_view_width(camera)
		default_zoom_height = camera_get_view_height(camera)

}

cameraOnPlayer = true
cameraFocusTimer = -1
cameraFocusTimerMax = -1
cameraFocusX = -1
cameraFocusY = -1
cameraFocusCinematic = false
cameraLerp = -1
camera_reset_switch = -1
camera_reset_on_player = false
function cameraSetFocus(X, Y, duration, Lerp, _cinematic) {
	cameraFocusX = X
	cameraFocusY = Y
	
	cameraOnPlayer = false
	
	cameraFocusTimerMax = duration
	cameraFocusTimer = duration 
	
	cameraFocusCinematic = _cinematic
	
	cameraLerp = Lerp
	
}

function cameraFocus(Lerp) {
	if Lerp > -1 {
		x = floor(lerp(x,cameraFocusX, Lerp))
		y = floor(lerp(y,cameraFocusY, Lerp))
	}
	
	else {
		x = cameraFocusX
		y = cameraFocusY
	}
	
	if cameraFocusTimer > 0 cameraFocusTimer--
	else if cameraFocusTimer == 0 {
		cameraOnPlayer = true
		cameraFocusTimer = -1	
		cameraFocusCinematic = false
	}
	
	cameraCinematic()
	
}
	
function cameraReset() {
	cameraOnPlayer = true
	cameraFocusCinematic = false
	cameraFocusTimer = -1
	cameraFocusTimerMax = -1
}

cameraCinematicSurface = -1
cameraCinematicBarHeight = 70
cameraCinematicBarCurrent = 0
function cameraCinematic() {
	var Lerp = 0.09
	
	if !surface_exists(cameraCinematicSurface) {
		//if window_has_focus() {
			cameraCinematicSurface = surface_create(width, height)
			surface_set_target(cameraCinematicSurface)
			draw_clear_alpha(c_black, 0)
			surface_reset_target()
		//}
	}
	
	////	We're in cinematic mode!
	if cameraFocusCinematic {

		if cameraCinematicBarCurrent < cameraCinematicBarHeight {
			cameraCinematicBarCurrent = lerp(cameraCinematicBarCurrent, cameraCinematicBarHeight, Lerp)
		}
	
	}
	////	We are NOT in cinematic mode
	else {
		if cameraCinematicBarCurrent > 0 {
			cameraCinematicBarCurrent = lerp(cameraCinematicBarCurrent, 0, Lerp)
		}
	}
	
	
	//	Draw black bars
	surface_set_target(cameraCinematicSurface)
		
	draw_set_color(c_black)
	var X = 0//camera_get_view_x(camera)
	var Y = 0//camera_get_view_y(camera)
	var Width = width//window_get_width()
	var Height = height//window_get_height()
	//	top bar
	draw_rectangle(X,Y, X+Width, Y+cameraCinematicBarCurrent, false)
		
	//	bottom bar
	draw_rectangle(X,Y+Height-cameraCinematicBarCurrent, X+Width,Y+Height, false)
		
	surface_reset_target()
}
	
//savePost = false
savePostRoom = -1
savePostIndex = -1
function save(bellID) {
	savePostRoom = room
	savePostIndex = bellID.ID
}

loading = false
loadingRoomChanged = false
function load() {
	
	if savePostRoom > -1 {
		//	pre-room change
		if !loadingRoomChanged {
			room_goto(savePostRoom)
			app.cameraOnPlayer = true
			loadingRoomChanged = true
		}
		//	post room-change
		else {
			
			if savePostIndex > -1 {
				
				app.cameraSetup()
				
				grid.mpgrid_build()
				
				var bellID = -1
				if instance_exists(bell) with bell if ID == other.savePostIndex {
					bellID = id
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
				
				player.x = bellID.x
				player.y = bellID.y + 32
				player.groundX = bellID.x
				player.groundY = bellID.y + 32
				
				app.x = player.x
				app.y = player.y
				
				loading = false
				loadingRoomChanged = false
				
			}
			else {
				
			}
		}
	}
	
	else {
		debug.log("ERROR savePostRoom = -1")
		game_restart()
	}
	
}
	
roomTime = -1
roomOldSurfaceBuffer = -1
roomNewSurfaceBuffer = -1
roomOldLightingSurfaceBuffer = -1
roomNewLightingSurfaceBuffer = -1
roomDuration = 0
roomDirection = -1
roomFrames = -1
roomDoor = -1
roomTransitionType = -1
roomPlayer = {
	x: -1,
	y: -1,
	oldX: -1,
	oldY: -1,
	newX: -1,
	newY: -1,
	amount: -1,
	ID: -1,
	sprite: -1,
	xscale: -1
}
	
function createRoomSurface() {
	var surface = surface_create(room_width,room_height)
		
	surface_set_target(surface)
	
	draw_clear_alpha(c_black, 0)
	
	draw_set_alpha(1)
		
	//	Draw tiles		
	var Layer = layer_tilemap_get_id(layer_get_id("Tiles_1"))
	draw_tilemap(Layer,0,0)
		
	var Layer = layer_tilemap_get_id(layer_get_id("Tiles_Rocks"))
	draw_tilemap(Layer,0,0)
		
	if instance_exists(enemy) with enemy {
		draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)	
	}
		
	if instance_exists(class_npc) with class_npc {
		draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)	
	}
		
	if instance_exists(House1) with House1 {
		draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)	
	}
		
	if instance_exists(bell) with bell {
		draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)		
	}
		
	if instance_exists(goblinHead) with goblinHead {
		draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)		
	}
	
	if surface_exists(lighting.surf) {
		//draw_light = false
		//draw_surface(lighting.surf,0,0)
	}	
		
	surface_reset_target()
	
	return surface
}

function roomGoto(nextRoom, Direction, Pair, transition_type) {
	if !paused paused = true
	
	//cameraOnPlayer = false
	cameraLerp = -1
	
	roomTransitionType = transition_type
	
	var surface = createRoomSurface()
		
	var surface2 = surface_create(width,height)
	
	surface_set_target(surface2)
	draw_clear_alpha(c_black, 0)
	surface_reset_target()
	
	var X = camera_get_view_x(camera)
	var Y = camera_get_view_y(camera)
	surface_copy_part(surface2,0,0,surface,X,Y,width,height)
		
	roomOldSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
	buffer_get_surface(roomOldSurfaceBuffer,surface2,0,0,0)
	
	surface_free(surface)
	surface_free(surface2)
	
	#region light surface
		var light_surface = surface_create(room_width,room_height)
		
		surface_set_target(light_surface)
		
		draw_clear_alpha(c_black, 0)
		
		draw_set_alpha(1)
		
		if surface_exists(lighting.surf) draw_surface(lighting.surf,0,0)
		
		surface_reset_target()
	
		var lightSurface2 = surface_create(width,height)
		
		surface_set_target(lightSurface2)
		draw_clear_alpha(c_black, 0)
		surface_reset_target()
		
		var X = camera_get_view_x(camera)
		var Y = camera_get_view_y(camera)
		surface_copy_part(lightSurface2,0,0,light_surface,X,Y,width,height)
	
		roomOldLightingSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
		buffer_get_surface(roomOldLightingSurfaceBuffer,lightSurface2,0,0,0)
		
		surface_free(lightSurface2)
		surface_free(light_surface)
	#endregion
	
	roomTime = 0
	roomDirection = Direction
	
	roomPlayer.x = abs(X - player.x)
	roomPlayer.y = abs(Y - player.y)
	
	roomPlayer.oldX = roomPlayer.x
	roomPlayer.oldY = roomPlayer.y
	
	////	Change lighting for new room
	if nextRoom == RoomTown {
		lighting.darkness = 0	
	} else if nextRoom == RoomStart {
		lighting.darkness = 0.8	
	}
	
	//	Sprite
	var Sprite = -1
	switch(Direction) {
		//	Down
		case -1: Sprite = s_player_walk_front break
		case up: Sprite = s_player_walk_back break
		case right: Sprite = s_player_walk_side break
		case down : Sprite = s_player_walk_front break
		case left: Sprite = s_player_walk_side break
	}
	roomPlayer.sprite = Sprite
	
	if Direction == left roomPlayer.xscale = -1
	else if Direction == right roomPlayer.xscale = 1
	else roomPlayer.xscale = 1
	
	roomDoor = Pair
		
	room_goto(nextRoom)
	
	if surface_exists(lighting.surf) surface_free(lighting.surf)
}
	
function roomTransition(transition_type, Speed) {
	if !paused paused = true
	
	cameraLerp = -1
	
	if roomTime == 0 {
		cameraSetup()
	
		if instance_exists(collisionRoomChange) with collisionRoomChange {
			if pair == other.roomDoor {
				var xx = x + (sprite_get_width(sprite_index) * image_xscale) / 2
				var yy = y + (sprite_get_height(sprite_index) * image_yscale) / 2
				
				switch(Direction) {
					case up: yy += 64 break
					case right: xx -= 64 break
					case down: yy -= 64 break
					case left: xx += 64 break
				}
			}
		}
					
		if !instance_exists(player) {
			roomPlayer.ID = instance_create_layer(xx,yy,"Instances",player)
		} else {
			with player other.roomPlayer.ID = id
			roomPlayer.ID.x = xx
			roomPlayer.ID.y = yy
			roomPlayer.ID.groundX = xx
			roomPlayer.ID.groundY = yy
		}
		
		roomPlayer.ID.sprite_index = roomPlayer.sprite
		roomPlayer.ID.image_xscale = roomPlayer.xscale
		
		cameraFocusX = roomPlayer.ID.x
		cameraFocusY = roomPlayer.ID.y
		x = cameraFocusX
		y = cameraFocusY
	}
	
	switch(transition_type)
	{
		#region Scrolling Transition
			case room_transition_scroll:
	
				var widthOrHeight = -1
				if roomDirection == up or roomDirection == down {
					widthOrHeight = height
				} else {
					widthOrHeight = width	
				}
	
				//	We're in the new room, take snapshot of this room too
				if roomTime == 5 {
		
					//	Rebuild grid
					grid.mpgrid_build()
		
					var surface = createRoomSurface()
		
					var surface2 = surface_create(width,height)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					surface_copy_part(surface2,0,0,surface,X,Y,width,height)
		
					roomNewSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
					buffer_get_surface(roomNewSurfaceBuffer,surface2,0,0,0)
					
					surface_free(surface)
					surface_free(surface2)
					
					#region light surface
						var light_surface = surface_create(room_width,room_height)
		
						surface_set_target(light_surface)
		
						draw_clear_alpha(c_black, 0)
		
						draw_set_alpha(1)
		
						if surface_exists(lighting.surf) draw_surface(lighting.surf,0,0)
		
						surface_reset_target()
	
						var lightSurface2 = surface_create(width,height)
		
						surface_set_target(lightSurface2)
						draw_clear_alpha(c_black, 0)
						surface_reset_target()
		
						var X = camera_get_view_x(camera)
						var Y = camera_get_view_y(camera)
						surface_copy_part(lightSurface2,0,0,light_surface,X,Y,width,height)
	
						roomNewLightingSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
						buffer_get_surface(roomNewLightingSurfaceBuffer,lightSurface2,0,0,0)
						
						surface_free(light_surface)
						surface_free(lightSurface2)
					#endregion
		
					var NewX = abs(X - player.x)
					var NewY = abs(Y - player.y)
		
					var gapY = abs(height - roomPlayer.oldY)
					var gapX = abs(width - roomPlayer.oldX)
		
					var newGapY = abs(height - NewY)
					var newGapX = abs(width - NewX)
		
					//	Find the on-screen coordinate for where the player is going to be
					switch(roomDirection) {
						case up:
							 roomPlayer.newY = roomPlayer.oldY - newGapY - roomPlayer.oldY
							 roomPlayer.newX = roomPlayer.oldX
						break
						case right:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX + NewX + gapX 
						break
						case -1:
						case down:
							roomPlayer.newY = roomPlayer.oldY + NewY + gapY
							roomPlayer.newX = roomPlayer.oldX
						break
						case left:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX - newGapX - roomPlayer.oldX
						break
					}
		
					sprite_index = s_player_walk_front
					image_speed = 1
					image_index = 0
		
					roomFrames = widthOrHeight / Speed
		
				}
	
				if roomTime > 5 roomDuration = approach(roomDuration, widthOrHeight, Speed)
	
				if roomDuration >= widthOrHeight {
					roomTime = -1
					if instance_exists(collisionRoomChange) with collisionRoomChange if pair == other.roomDoor closeToPlayer = true
					roomDuration = 0
					roomDirection = -1
					roomFrames = -1
					roomDoor = -1
					paused = false
					buffer_delete(roomOldSurfaceBuffer)
					buffer_delete(roomNewSurfaceBuffer)
					roomOldSurfaceBuffer = -1
					roomNewSurfaceBuffer = -1
					sprite_index = -1
					roomPlayer = {
						x: -1,
						y: -1,
						oldX: -1,
						oldY: -1,
						newX: -1,
						newY: -1,
						amount: -1,
						ID: -1,
						sprite: -1,
						xscale: -1,
					}
					cameraLerp = 0.09
					
					buffer_delete(roomOldLightingSurfaceBuffer)
					buffer_delete(roomNewLightingSurfaceBuffer)
				}
	
				else roomTime++
			
			break
		#endregion
		
		#region Fade to Black 
			case room_transition_fade_to_black:
				
				//	We're in the new room, take snapshot of this room too
				if roomTime == 5 {
		
					//	Rebuild grid
					grid.mpgrid_build()
		
					var surface = createRoomSurface()
		
					var surface2 = surface_create(width,height)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					surface_copy_part(surface2,0,0,surface,X,Y,width,height)
		
					roomNewSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
					buffer_get_surface(roomNewSurfaceBuffer,surface2,0,0,0)
					
					surface_free(surface)
					surface_free(surface2)
					
					#region light surface
						var light_surface = surface_create(room_width,room_height)
		
						surface_set_target(light_surface)
		
						draw_clear_alpha(c_black, 0)
		
						draw_set_alpha(1)
		
						if surface_exists(lighting.surf) draw_surface(lighting.surf,0,0)
		
						surface_reset_target()
	
						var lightSurface2 = surface_create(width,height)
		
						surface_set_target(lightSurface2)
						draw_clear_alpha(c_black, 0)
						surface_reset_target()
		
						var X = camera_get_view_x(camera)
						var Y = camera_get_view_y(camera)
						surface_copy_part(lightSurface2,0,0,light_surface,X,Y,width,height)
	
						roomNewLightingSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
						buffer_get_surface(roomNewLightingSurfaceBuffer,lightSurface2,0,0,0)
						
						surface_free(light_surface)
						surface_free(lightSurface2)
					#endregion
		
					var NewX = abs(X - player.x)
					var NewY = abs(Y - player.y)
		
					var gapY = abs(height - roomPlayer.oldY)
					var gapX = abs(width - roomPlayer.oldX)
		
					var newGapY = abs(height - NewY)
					var newGapX = abs(width - NewX)
		
					//	Find the on-screen coordinate for where the player is going to be
					switch(roomDirection) {
						case up:
							 roomPlayer.newY = roomPlayer.oldY - newGapY - roomPlayer.oldY
							 roomPlayer.newX = roomPlayer.oldX
						break
						case right:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX + NewX + gapX 
						break
						case -1:
						case down:
							roomPlayer.newY = roomPlayer.oldY + NewY + gapY
							roomPlayer.newX = roomPlayer.oldX
						break
						case left:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX - newGapX - roomPlayer.oldX
						break
					}
		
					//sprite_index = s_player_walk_front
					//image_speed = 1
					//image_index = 0
		
					//roomFrames = widthOrHeight / Speed
		
				}
					
				if roomTime > 5 roomDuration = approach(roomDuration, height, Speed)

				//	Finished fading
				if roomDuration >= height {
					roomTime = -1
					if instance_exists(collisionRoomChange) with collisionRoomChange if pair == other.roomDoor closeToPlayer = true
					roomDuration = 0
					roomDirection = -1
					roomFrames = -1
					roomDoor = -1
					paused = false
					buffer_delete(roomOldSurfaceBuffer)
					buffer_delete(roomNewSurfaceBuffer)
					roomOldSurfaceBuffer = -1
					roomNewSurfaceBuffer = -1
					sprite_index = -1
					roomPlayer = {
						x: -1,
						y: -1,
						oldX: -1,
						oldY: -1,
						newX: -1,
						newY: -1,
						amount: -1,
						ID: -1,
						sprite: -1,
						xscale: -1,
					}
					cameraOnPlayer = true
					cameraLerp = 0.09
				
					buffer_delete(roomOldLightingSurfaceBuffer)
					buffer_delete(roomNewLightingSurfaceBuffer)
					
				} else roomTime++
				
				
				
			break
		#endregion
		
		#region Fade to white
			case room_transition_fade_to_white:
								
				//	We're in the new room, take snapshot of this room too
				if roomTime == 5 {
		
					//	Rebuild grid
					grid.mpgrid_build()
		
					var surface = createRoomSurface()
		
					var surface2 = surface_create(width,height)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					surface_copy_part(surface2,0,0,surface,X,Y,width,height)
		
					roomNewSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
					buffer_get_surface(roomNewSurfaceBuffer,surface2,0,0,0)
					
					surface_free(surface)
					surface_free(surface2)
					
					#region light surface
						var light_surface = surface_create(room_width,room_height)
		
						surface_set_target(light_surface)
		
						draw_clear_alpha(c_black, 0)
		
						draw_set_alpha(1)
		
						if surface_exists(lighting.surf) draw_surface(lighting.surf,0,0)
		
						surface_reset_target()
	
						var lightSurface2 = surface_create(width,height)
		
						surface_set_target(lightSurface2)
						draw_clear_alpha(c_black, 0)
						surface_reset_target()
		
						var X = camera_get_view_x(camera)
						var Y = camera_get_view_y(camera)
						surface_copy_part(lightSurface2,0,0,light_surface,X,Y,width,height)
	
						roomNewLightingSurfaceBuffer = buffer_create(width*height*4,buffer_grow,1)
		
						buffer_get_surface(roomNewLightingSurfaceBuffer,lightSurface2,0,0,0)
						
						surface_free(light_surface)
						surface_free(lightSurface2)
					#endregion
		
					var NewX = abs(X - player.x)
					var NewY = abs(Y - player.y)
		
					var gapY = abs(height - roomPlayer.oldY)
					var gapX = abs(width - roomPlayer.oldX)
		
					var newGapY = abs(height - NewY)
					var newGapX = abs(width - NewX)
		
					//	Find the on-screen coordinate for where the player is going to be
					switch(roomDirection) {
						case up:
							 roomPlayer.newY = roomPlayer.oldY - newGapY - roomPlayer.oldY
							 roomPlayer.newX = roomPlayer.oldX
						break
						case right:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX + NewX + gapX 
						break
						case -1:
						case down:
							roomPlayer.newY = roomPlayer.oldY + NewY + gapY
							roomPlayer.newX = roomPlayer.oldX
						break
						case left:
							roomPlayer.newY = roomPlayer.oldY
							roomPlayer.newX = roomPlayer.oldX - newGapX - roomPlayer.oldX
						break
					}
		
					//sprite_index = s_player_walk_front
					//image_speed = 1
					//image_index = 0
		
					//roomFrames = widthOrHeight / Speed
		
				}
					
				if roomTime > 5 roomDuration = approach(roomDuration, height, Speed)

				//	Finished fading
				if roomDuration >= height {
					roomTime = -1
					if instance_exists(collisionRoomChange) with collisionRoomChange if pair == other.roomDoor closeToPlayer = true
					roomDuration = 0
					roomDirection = -1
					roomFrames = -1
					roomDoor = -1
					paused = false
					buffer_delete(roomOldSurfaceBuffer)
					buffer_delete(roomNewSurfaceBuffer)
					roomOldSurfaceBuffer = -1
					roomNewSurfaceBuffer = -1
					sprite_index = -1
					roomPlayer = {
						x: -1,
						y: -1,
						oldX: -1,
						oldY: -1,
						newX: -1,
						newY: -1,
						amount: -1,
						ID: -1,
						sprite: -1,
						xscale: -1,
					}
					cameraOnPlayer = true
					cameraLerp = 0.09
					
					buffer_delete(roomOldLightingSurfaceBuffer)
					buffer_delete(roomNewLightingSurfaceBuffer)
					
				} else roomTime++
				
			break
		#endregion
	}
}

drawDisplayZone = false
displayZoneState = -1
displayZoneTimer = -1
displayZoneFadeIn = false
displayZoneAlpha = 0
displayZoneText = ""
function displayZone() {
	
	//	First frame
	if displayZoneState == -1 {
		displayZoneState = 0
		displayZoneFadeIn = true
	}
	//	Fully faded in, lets pause and wait a bit
	else if displayZoneState == 1 {
		displayZoneState = 2
		displayZoneFadeIn = false
		displayZoneTimer = 120
	}
	//	Fully faded out, we're done
	else if displayZoneState == 3 {
		
	}
	
	draw_set_font(fnt_respawn)
	draw_set_color(c_white)
	
	//	Fading in
	if displayZoneFadeIn {
		displayZoneAlpha = approach(displayZoneAlpha, 1, 0.05)
		if displayZoneState == 0 and displayZoneAlpha == 1 {
			displayZoneState = 1
		}
	} 
	//	Fading out
	else {
		if displayZoneTimer > 0 displayZoneTimer--
		else if displayZoneTimer == 0 {
			displayZoneState = 3	
			displayZoneTimer = -1
		}
		if displayZoneState == 3 displayZoneAlpha = approach(displayZoneAlpha, 0, 0.05)
		if displayZoneState == 3 and displayZoneAlpha == 0 {
			displayZoneState = -1
			drawDisplayZone = false
			displayZoneText = ""
			displayZoneFadeIn = false
		}
	}
	
	var centerX = display_get_gui_width()/2
	var YY = 40
	
	draw_set_alpha(displayZoneAlpha)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	draw_text(centerX,YY, displayZoneText)
	
	draw_reset()
}
	
function setDisplayZone(Text) {
	displayZoneText = Text
	
	drawDisplayZone = true
}
	
cameraSetup()

dialogueGrid = load_csv("GAMEJAM_Dialogue_CSV.csv")

var width = ds_grid_width(dialogueGrid)
var height = ds_grid_height(dialogueGrid)
debug.log("dialogueGrid is "+string_upper(string(width))+" by "+string_upper(string(height))) 

debug_GOBLIN_ATTACK = false

if room == RoomAppStart {
	room_goto(RoomMainMenu)
	camera_reset_switch = 0
}
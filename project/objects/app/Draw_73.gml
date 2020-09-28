////	Room Transitions
if roomTime > -1 {
	switch(roomTransitionType)
	{
		#region Scrolling
			case room_transition_scroll:
				if roomTime <= 5 {
					//	Old room
					var surface = surface_create(width,height)
					buffer_set_surface(roomOldSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface,X,Y)
		
					draw_set_color(c_black)
					var Alpha = 1 - (abs((Y+roomPlayer.y) - Y+roomPlayer.y) / 100)
					Alpha = clamp(Alpha, 0.5, 0.8)
					Alpha = 0.8
					draw_set_alpha(Alpha - .25)
					var Size = Alpha
					Size = clamp(Size, 0.2, 1)
					var Width = 6 + (8 * Size)
					var Height = 1 + (2 * Size)
					draw_ellipse(X+roomPlayer.x-Width,Y+roomPlayer.y-Height,X+roomPlayer.x+Width,Y+roomPlayer.y+Height,false)

					draw_reset()
		
					draw_sprite_ext(roomPlayer.sprite,0,X+roomPlayer.x,Y+roomPlayer.y,roomPlayer.xscale,1,1,c_white,1)
					
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomOldLightingSurfaceBuffer,surface2,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					surface_free(surface)
		
				} else if roomOldSurfaceBuffer > -1 and roomNewSurfaceBuffer > -1 {
		
					//	Old room
					var surface = surface_create(width,height)
					buffer_set_surface(roomOldSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					switch(roomDirection) {
						case -1: Y -= roomDuration break
						case up: Y += roomDuration break
						case right: X -= roomDuration break
						case down: Y -= roomDuration break
						case left: X += roomDuration break
					}
					draw_surface(surface,X,Y)
					
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomOldLightingSurfaceBuffer,surface2,0,0,0)
					//var X = camera_get_view_x(camera)
					//var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					surface_free(surface)
		
					var oldY = Y
					var oldX = X
	
					//	New room
					var surface = surface_create(width,height)
					buffer_set_surface(roomNewSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					switch(roomDirection) {
						case -1: 
							Y -= roomDuration
							Y += height
						break
						case up: 
							Y += roomDuration 
							Y -= height
						break
						case right: 
							X -= roomDuration
							X += width
						break
						case down: 
							Y -= roomDuration 
							Y += height
						break
						case left: 
							X += roomDuration 
							X -= width
						break
					}
					draw_surface(surface,X,Y)
					
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomNewLightingSurfaceBuffer,surface2,0,0,0)
					//var X = camera_get_view_x(camera)
					//var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					surface_free(surface)
		
					draw_set_color(c_black)
					var Alpha = 1 - (abs((oldY+roomPlayer.y) - oldY+roomPlayer.y) / 100)
					Alpha = clamp(Alpha, 0.5, 0.8)
					Alpha = 0.8
					draw_set_alpha(Alpha - .25)
					var Size = Alpha
					Size = clamp(Size, 0.2, 1)
					var Width = 6 + (8 * Size)
					var Height = 1 + (2 * Size)
					draw_ellipse(oldX+roomPlayer.x-Width,oldY+roomPlayer.y-Height,oldX+roomPlayer.x+Width,oldY+roomPlayer.y+Height,false)

					draw_reset()
		
					draw_sprite_ext(roomPlayer.sprite,image_index,oldX+roomPlayer.x,oldY+roomPlayer.y,roomPlayer.xscale,1,1,c_white,1)
		
					//	Move player to the new on-screen xy coordinate
					if roomPlayer.y < roomPlayer.newY {
						var amount = abs(roomPlayer.oldY - roomPlayer.newY) / (roomFrames-2)
						roomPlayer.y += amount
					}
					else if roomPlayer.y > roomPlayer.newY {
						var amount = abs(roomPlayer.oldY - roomPlayer.newY) / (roomFrames-2)
						roomPlayer.y -= amount	
					}
		
					if roomPlayer.x < roomPlayer.newX {
						var amount = abs(roomPlayer.oldX - roomPlayer.newX) / (roomFrames-2)
						roomPlayer.x += amount		
					} else if roomPlayer.x > roomPlayer.newX {
						var amount = abs(roomPlayer.oldX - roomPlayer.newX) / (roomFrames-2)
						roomPlayer.x -= amount		
					}
		
				}
			break
		#endregion
		
		#region Fade to black
			case room_transition_fade_to_black:
				
				//	Fading to black
				if roomDuration <= height/2 {					
					//	Old room
					draw_set_alpha(1)
					var surface = surface_create(width,height)
					buffer_set_surface(roomOldSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface,X,Y)
					surface_free(surface)
					
					draw_sprite_ext(roomPlayer.sprite,0,X+roomPlayer.oldX,Y+roomPlayer.oldY,roomPlayer.xscale,1,1,c_white,1)
					
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomOldLightingSurfaceBuffer,surface2,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					
					//	Fade to black
					var Alpha = roomDuration / (height/2)
					draw_set_alpha(Alpha)
					draw_set_color(c_black)
					draw_rectangle(X,Y,X+window_get_width(),Y+window_get_height(),false)
					
					draw_reset()
				}
					
				//	Fading from black into the new room
				else {
					//	New room					
					draw_set_alpha(1)
					var surface = surface_create(width,height)
					buffer_set_surface(roomNewSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface,X,Y)
					surface_free(surface)
					
					draw_sprite_ext(roomPlayer.sprite,0,roomPlayer.ID.x,roomPlayer.ID.y,roomPlayer.xscale,1,1,c_white,1)
					
					//	Lighting
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomNewLightingSurfaceBuffer,surface2,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					
					//	Fade from black
					var Height = height/2
					var Alpha = 1 - ((roomDuration-(Height)) / (Height))
					draw_set_alpha(Alpha)
					draw_set_color(c_black)
					draw_rectangle(X,Y,X+window_get_width(),Y+window_get_height(),false)
					
					draw_reset()
					
				}
				
			break
		#endregion
		
		#region Fade to white
			case room_transition_fade_to_white:
				
				//	Fading to white
				if roomDuration <= height/2 {					
					//	Old room
					draw_set_alpha(1)
					var surface = surface_create(width,height)
					buffer_set_surface(roomOldSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface,X,Y)
					surface_free(surface)
					
					draw_sprite_ext(roomPlayer.sprite,0,X+roomPlayer.oldX,Y+roomPlayer.oldY,roomPlayer.xscale,1,1,c_white,1)
					
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomOldLightingSurfaceBuffer,surface2,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					
					//	Fade to black
					var Alpha = roomDuration / (height/2)
					draw_set_alpha(Alpha)
					draw_set_color(c_white)
					draw_rectangle(X,Y,X+window_get_width(),Y+window_get_height(),false)
					
					draw_reset()
				}
				
				//	Fading from white into the new room
				else {
					//	New room					
					draw_set_alpha(1)
					var surface = surface_create(width,height)
					buffer_set_surface(roomNewSurfaceBuffer,surface,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface,X,Y)
					surface_free(surface)
					
					draw_sprite_ext(roomPlayer.sprite,0,roomPlayer.ID.x,roomPlayer.ID.y,roomPlayer.xscale,1,1,c_white,1)
					
					//	Lighting
					var surface2 = surface_create(width,height)
					buffer_set_surface(roomNewLightingSurfaceBuffer,surface2,0,0,0)
					var X = camera_get_view_x(camera)
					var Y = camera_get_view_y(camera)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					draw_surface(surface2,X,Y)
					surface_free(surface2)
					
					//	Fade from black
					var Height = height/2
					var Alpha = 1 - ((roomDuration-(Height)) / (Height))
					draw_set_alpha(Alpha)
					draw_set_color(c_white)
					draw_rectangle(X,Y,X+window_get_width(),Y+window_get_height(),false)
					
					draw_reset()
					
				}
			break
		#endregion
	}
}


////	PAUSED text and screen dim
if paused and pausedTimer == -1 and roomTime == -1 {
	
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	
	var X = camera_get_view_x(camera)
	var Y = camera_get_view_y(camera)
	draw_rectangle(X,Y,X+width,Y+height,false)
	
	draw_set_color(c_white)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_text(X+width/2,Y+height/2,"PAUSED")
	
	draw_reset()
	
}
	
////	Draw cinematic black bars
if surface_exists(cameraCinematicSurface) {
	draw_surface(cameraCinematicSurface, camera_get_view_x(camera), camera_get_view_y(camera))
	surface_free(cameraCinematicSurface)
}
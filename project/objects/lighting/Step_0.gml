switch(room)
{
	case RoomForest:
	case RoomTown: darkness = 0 break;
	case RoomStart: darkness = 0 break
	case RoomCave: darkness = 1 break
}

if !surface_exists(surf) {
	surf = surface_create(room_width, room_height)

	surface_set_target(surf)
	draw_clear_alpha(c_black, 0)

	surface_reset_target()
}

//else {
	surface_set_target(surf)
	
	draw_set_color(c_black)
	draw_set_alpha(darkness)
	draw_rectangle(0,0, room_width,room_height, false)
	draw_rectangle(0,0, room_width,room_height, false)
	
	gpu_set_blendmode(bm_subtract)
	draw_set_color(c_white)
	
	if instance_exists(class_light) with class_light {	
		draw_set_alpha(vibrance)
		draw_sprite_ext(light,image_index,x,y,image_xscale,image_yscale,image_angle,c_black,vibrance)
	}
	
	draw_set_alpha(1)
	if instance_exists(collisionMap) with collisionMap if z > -1 {
		//draw_rectangle(x,y,x+sprite_get_width(sprite_index)*image_xscale,y+sprite_get_height(sprite_index)*image_yscale,false)
		var surface = surface_create(sprite_get_width(sprite_index)*image_xscale,sprite_get_height(sprite_index)*image_yscale)
		buffer_set_surface(surfaceBuffer, surface, 0,0,0)
		draw_surface_ext(surface,x,y,1,1,0,c_black,1)
		surface_free(surface)
	}
	
	if instance_exists(player) and player.alive and player.hasTorch {
		//var flicker = random_range(0.9,1.1)
		draw_sprite_ext(s_lighting_gradient,0,player.x,player.y-32-player.z,1,1,0,c_white,0.8)
	}
	
	gpu_set_blendmode(bm_normal)
	
	draw_set_color(c_black)
	draw_set_alpha(darkness)
	if instance_exists(collisionMap) with collisionMap if z > -1  {
		//draw_rectangle(x,y,x+sprite_get_width(sprite_index)*image_xscale,y+sprite_get_height(sprite_index)*image_yscale,false)
		//draw_rectangle(x,y,x+sprite_get_width(sprite_index)*image_xscale,y+sprite_get_height(sprite_index)*image_yscale,false)
		var surface = surface_create(sprite_get_width(sprite_index)*image_xscale,sprite_get_height(sprite_index)*image_yscale)
		buffer_set_surface(surfaceBuffer, surface, 0,0,0)
		draw_surface_ext(surface,x,y,1,1,0,c_black,other.darkness)
		draw_surface_ext(surface,x,y,1,1,0,c_black,other.darkness)
		surface_free(surface)
	}
	
	draw_set_alpha(1)
	
	surface_reset_target()
//}
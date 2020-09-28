#macro mouse_gui_x device_mouse_x_to_gui(0)
#macro mouse_gui_y device_mouse_y_to_gui(0)

#macro animation_end (image_index >= image_number - 1)

#macro up 0
#macro right 1
#macro down 2
#macro left 3

enum state {
	free,
	attack,
	
	
	
	main,
	options,
}

#macro goal_wander 0
#macro goal_chase 1
#macro goal_attack 2

#macro room_transition_scroll 0
#macro room_transition_fade_to_white 1
#macro room_transition_fade_to_black 2
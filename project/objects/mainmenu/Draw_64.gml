switch(state)
{
	#region Main
		case state.main:
	
			var String = "Play Game"
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			var XX = display_get_gui_width()/2 - width/2
			var YY = 120

			draw_set_color(c_black)
			draw_rectangle(XX-2,YY-2,XX+width+2,YY+height+2,false)
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+width,YY+height) {
				draw_set_color(c_gray)
				if input.mouseLeftPress {
					room_goto(bootRoom)
					app.camera_reset_switch = 0
					app.camera_reset_on_player = true
				}
			} else {
				draw_set_color(c_dkgray)	
			}
			draw_rectangle(XX,YY,XX+width,YY+height,false)

			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_text(XX+width/2,YY+height/2,String)




			var String = "Options"
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			var XX = display_get_gui_width()/2 - width/2
			var YY = YY + height + spacer

			draw_set_color(c_black)
			draw_rectangle(XX-2,YY-2,XX+width+2,YY+height+2,false)
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+width,YY+height) {
				draw_set_color(c_gray)
				if input.mouseLeftPress {
					state = state.options
					delayClick = 10
				}
			} else {
				draw_set_color(c_dkgray)	
			}
			draw_rectangle(XX,YY,XX+width,YY+height,false)

			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_text(XX+width/2,YY+height/2,String)
		
		break
	#endregion
	
	#region Options
		case state.options:
			
			var Fullscreened = window_get_fullscreen()
			var String = "Fullscreen: "
			if Fullscreened {
				String += "On"	
			} else {
				String += "Off"		
			}
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			var XX = display_get_gui_width()/2 - width/2
			var YY = 40

			draw_set_color(c_black)
			draw_rectangle(XX-2,YY-2,XX+width+2,YY+height+2,false)
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+width,YY+height) {
				draw_set_color(c_gray)
				if input.mouseLeftPress and delayClick == -1 {
					if Fullscreened window_set_fullscreen(false)
					else window_set_fullscreen(true)
				}
			} else {
				draw_set_color(c_dkgray)	
			}
			draw_rectangle(XX,YY,XX+width,YY+height,false)

			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_text(XX+width/2,YY+height/2,String)
			
			
			////	Sound volume
			var String = "Sound: " + string(sound.volumeSound * 100)
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			
			var barWidth = 200
			var barHeight = 40
			var barDivision = barWidth / 11
			
			var XX = display_get_gui_width()/2 - barWidth/2
			var YY = YY + height + spacer
			
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_set_color(c_white)
			draw_text(XX+barWidth/2,YY-16,String)
			
			draw_rectangle(XX,YY,XX+barWidth,YY+barHeight,false)
			
			draw_set_color(c_black)
			draw_circle(XX+barDivision*(sound.volumeSound*10), YY+barHeight/2, 16, false)
			
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+barWidth,YY+barHeight) {
				var pointX = abs(mouse_gui_x - XX)
				var soundX = floor(pointX / barDivision)
				if input.mouseLeft and delayClick == -1 {
					sound.volumeSound = soundX / 10	
				}
			}
			
			
			////	Music volume
			var String = "Music: " + string(sound.volumeMusic * 100)
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			
			var barWidth = 200
			var barHeight = 40
			var barDivision = barWidth / 11
			
			var XX = display_get_gui_width()/2 - barWidth/2
			var YY = YY + height + spacer
			
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_set_color(c_white)
			draw_text(XX+barWidth/2,YY-16,String)
			
			draw_rectangle(XX,YY,XX+barWidth,YY+barHeight,false)
			
			draw_set_color(c_black)
			draw_circle(XX+barDivision*(sound.volumeMusic*10), YY+barHeight/2, 16, false)
			
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+barWidth,YY+barHeight) {
				var pointX = abs(mouse_gui_x - XX)
				var soundX = floor(pointX / barDivision)
				if input.mouseLeft and delayClick == -1 {
					sound.volumeMusic = soundX / 10
					audio_sound_gain(sound.music,sound.volumeMusic,0)
				}
			}
			
			
			
			
			
			var String = "Back to Main Menu"
			var spacer = 32
			var width = string_width(String) + spacer
			var height = string_height(String) + spacer
			var XX = display_get_gui_width()/2 - width/2
			var YY = YY + height + spacer

			draw_set_color(c_black)
			draw_rectangle(XX-2,YY-2,XX+width+2,YY+height+2,false)
			if point_in_rectangle(mouse_gui_x,mouse_gui_y,XX,YY,XX+width,YY+height) {
				draw_set_color(c_gray)
				if input.mouseLeftPress {
					state = state.main
				}
			} else {
				draw_set_color(c_dkgray)	
			}
			draw_rectangle(XX,YY,XX+width,YY+height,false)

			draw_set_color(c_white)
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_text(XX+width/2,YY+height/2,String)
			
		break
	#endregion
	
}

if delayClick > -1 delayClick--
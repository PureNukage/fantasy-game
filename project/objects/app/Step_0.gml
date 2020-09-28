#region		Camera Zoom

if camera_reset_switch > -1 {
	camera_reset_switch++
	if camera_reset_switch > 0 {
		grid.mpgrid_build()
		cameraSetup()
		camera_reset_switch = -1
	}
}

if camera_reset_on_player {
	x = player.x
	y = player.y
	camera_reset_on_player = false
}

var ID = layer_get_id("Viewport")
if layer_exists(ID) {
	layer_set_visible(ID, false)
}

if cameraOnPlayer and instance_exists(player) {
	cameraFocusX = player.x
	cameraFocusY = player.y
	if time.stream <= 5 cameraLerp = -1
	else cameraLerp = 0.09
}

if time.stream < 5 {
	window_center()	
}

if roomTime > -1 {
	roomTransition(roomTransitionType, 5)
}

cameraFocus(cameraLerp)

if loading load()

if pausedTimer > 0 pausedTimer--
else if pausedTimer == 0 and paused {
	paused = false
	pausedTimer--	
}

if input.keyPause paused = !paused

//zoom_level = clamp((zoom_level + (mouse_wheel_down()-mouse_wheel_up())*0.1),0.25,1.0)

camera_set_view_pos(camera,
		clamp( camera_get_view_x(camera), 0, room_width - camera_get_view_width(camera) ),
		clamp( camera_get_view_y(camera), 0, room_height - camera_get_view_height(camera) ));

var view_w = camera_get_view_width(camera)
var view_h = camera_get_view_height(camera)

var rate = 0.2

var new_w = round(lerp(view_w, zoom_level *  default_zoom_width, rate))
var new_h = round(lerp(view_h, zoom_level * default_zoom_height, rate))
			
if new_w & 1 {
	new_w++	
}
if new_h & 1 {
	new_h++	
}

camera_set_view_size(camera, new_w, new_h)

//	Realignment
var shift_x = camera_get_view_x(camera) - (new_w - view_w) * 0.5
var shift_y = camera_get_view_y(camera) - (new_h - view_h) * 0.5

camera_set_view_pos(camera,shift_x, shift_y)


////	Clamp app x,y within room
var edgeX = camera_get_view_width(camera)/2
var edgeY = camera_get_view_height(camera)/2
x = clamp(x,0+edgeX,room_width-edgeX)
y = clamp(y,0+edgeY,room_height-edgeY)

#endregion
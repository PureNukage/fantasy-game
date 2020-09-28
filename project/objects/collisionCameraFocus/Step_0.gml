if place_meeting(x,y,player) and app.cameraOnPlayer and !set {
	app.cameraSetFocus(focusX, focusY, duration, 0.02, cinematic)
	set = true
	if temporary {
		debug.log("Temporary cleaning up")
		instance_destroy()
	}
}

else if !place_meeting(x,y,player) and set {
	if app.cameraOnPlayer == false {
		app.cameraReset()
	}
	set = false
}
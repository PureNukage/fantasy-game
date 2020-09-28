var centerX = display_get_gui_width()/2

var responseCount = array_length(responses)
var responseData = []
if responseCount > 0 {
	for(var i=0;i<responseCount;i++) {
		responseData[i][0] = string_width(responses[i][0]) + 32
		responseData[i][1] = string_height(responses[i][0]) + 32
	}
}

draw_set_font(fnt_dialogue)
var width = string_width(textComplete) + 32
var height = string_height(textComplete) + 32 + (responseCount * 48)

var X = centerX - width/2
var Y = display_get_gui_height() - height - 32

draw_set_color(c_black)
draw_roundrect(X-2,Y-2, X+width+2,Y+height+2, false)

draw_set_color(c_gray)
draw_roundrect(X,Y, X+width,Y+height, false)

draw_set_color(c_white)
draw_text(X+15,Y+15,textCurrent)

draw_reset()

//	Draw responses
if responseCount > 0 {
	var xx = X
	var yy = Y + height + 16
	for(var i=0;i<responseCount;i++) {
		var width = responseData[i][0]
		var height = responseData[i][1]
		draw_set_color(c_black)
		draw_roundrect(xx,yy, xx+width,yy+height,false)
		
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_text(xx+width/2,yy+height/2,responses[i][0])
	}
}
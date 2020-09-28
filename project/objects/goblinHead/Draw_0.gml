//	Draw shadow
if !falling {
	draw_set_color(c_black)
	//var Alpha = 1.25 - (abs(groundY - (y-z)) / 100)
	//Alpha = clamp(Alpha, 0.2, 0.5)
	var Alpha = 1 - (abs((y-z) - groundY) / 100)
	Alpha = clamp(Alpha, 0.5, 0.8)
	draw_set_alpha(Alpha - .25)
	var Size = Alpha
	Size = clamp(Size, 0.2, 1)
	var Width = 4 + (8 * Size)
	var Height = 1 + (2 * Size)
	draw_ellipse(groundX-Width,groundY-Height,groundX+Width,groundY+Height,false)

	draw_reset()
}

if damagedFlash shader_set(shader_flash)

if !fallen draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)

shader_reset()
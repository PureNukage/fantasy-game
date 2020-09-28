if surface_exists(surf) and draw_light {
	draw_surface(surf, 0,0)
	if surface_exists(surf) surface_free(surf)
}
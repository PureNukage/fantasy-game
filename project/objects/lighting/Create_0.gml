darkness = 0.8

if room == RoomTown darkness = 0

draw_light = true

surf = surface_create(room_width, room_height)

surface_set_target(surf)
draw_clear_alpha(c_black, 0)

surface_reset_target()
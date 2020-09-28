inventory = {
	width: 150,
	height: 100,
	slots: []
}
inventory.x = display_get_gui_width() - inventory.width - 15
inventory.y = display_get_gui_height() - inventory.height - 15
inventory.slots[0] = new create_item("key")
inventory.slots[1] = new create_item("torch")
inventory.slots[2] = -1
inventory.slots[3] = -1

interaction = false
interactionID = -1
interactionCooldown = -1

//	APIs
draw_health = true
draw_stamina = true
draw_inventory = true
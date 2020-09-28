spawnpoint = false
text = "area"

ID = -1

dinged = false
dingSoundPlayed = false
function ding() {
	sprite_index = s_bell_animation
	
	if animation_end {
		dinged = false
		sprite_index = s_bell
	}
	
	app.save(id)
}
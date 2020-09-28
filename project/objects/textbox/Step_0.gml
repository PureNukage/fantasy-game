if textScrolling scroll()

else if input.keyInteract {
	distanceTarget.dialogueIndex = next
	instance_destroy()
	gui.interactionCooldown = 15
	
	if sign(next) == 1 {
		var ID = distanceTarget
		var String = ID.dialogue[ID.dialogueIndex][0]
		var Next = ID.dialogue[ID.dialogueIndex][1]
		create_dialogue(String, ID, Next)
	}
	
	else {
		distanceTarget.dialogueIndex = distanceTarget.dialogueIndex * -1
	}
}

var distance = 200
if distanceTarget > -1 and instance_exists(distanceTarget) and point_distance(distanceTarget.x,distanceTarget.y, player.x,player.y) >= distance {
	instance_destroy()	
}
event_inherited()

mask_index = s_goblin_collision

path = path_add()
pos = 1
xGoto = -1
yGoto = -1
wander = true
wanderTimer = -1
aggro = false
attack = false
attackRange = 100
attackDelayMax = 30
attackDelay = 0
attackX = -1
attackY = -1
attackForce = -1
goal = -1

function aggroCheck() {
	if !player.alive {
		if aggro = true {
			debug.log("Player is dead, losing my aggro state!")
			aggro = false
			attack = false
			goal = -1
			attackX = -1
			attackY = -1
			attackForce = -1
			wander = true
		}
	}
}

function playerCheck(distance) {
	
	if player.alive {
	
		if point_distance(x,y, player.x,player.y) < distance {
		
			if !collision_line(x,y, player.x,player.y, collision, true, true) {
			
				debug.log("Player nearby, going aggro!")
			
				wander = false
			
				aggro = true
			
				goal = -1
			
			}
		
		}
	}
	
}
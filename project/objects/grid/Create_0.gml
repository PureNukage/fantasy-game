mpGrid = -1
function mpgrid_build() {

	cellWidth = 16
	cellHeight = 16
	gridWidth = room_width / cellWidth
	gridHeight = room_height / cellHeight

	if mpGrid > -1 mp_grid_destroy(mpGrid)
	
	mpGrid = mp_grid_create(0,0,gridWidth,gridHeight,cellWidth,cellHeight)

	mp_grid_add_instances(mpGrid,collision,true)
	mp_grid_add_instances(mpGrid,collisionMap,true)
	mp_grid_add_instances(mpGrid,collisionRoomChange,true)
	
}

mpgrid_build()
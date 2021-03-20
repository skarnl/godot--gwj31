extends Spatial


const DIMENSIONS := Vector3(5, 3, 5)

var north_wall : Spatial
var south_wall : Spatial
var east_wall : Spatial
var west_wall : Spatial


func set_north_wall(wall_packed : PackedScene) -> void:
	if north_wall:
		remove_child(north_wall)
	
	var wall : Spatial = wall_packed.instance()
	
	wall.translation = Vector3(0, 0, DIMENSIONS.z / 2.0)
	wall.rotation_degrees.y = 90
	
	add_child(wall)
	north_wall = wall


func set_south_wall(wall_packed : PackedScene) -> void:
	if south_wall:
		remove_child(south_wall)
	
	var wall : Spatial = wall_packed.instance()
	
	wall.translation = Vector3(0, 0, -DIMENSIONS.z / 2.0)
	wall.rotation_degrees.y = 270
	
	add_child(wall)
	south_wall = wall


func set_east_wall(wall_packed : PackedScene) -> void:
	if east_wall:
		remove_child(east_wall)
	
	var wall : Spatial = wall_packed.instance()
	
	wall.translation = Vector3(DIMENSIONS.z / 2.0, 0, 0)
	wall.rotation_degrees.y = 0
	
	add_child(wall)
	east_wall = wall


func set_west_wall(wall_packed : PackedScene) -> void:
	if west_wall:
		remove_child(east_wall)
	
	var wall : Spatial = wall_packed.instance()
	
	wall.translation = Vector3(-DIMENSIONS.z / 2.0, 0, 0)
	wall.rotation_degrees.y = 180
	
	add_child(wall)
	west_wall = wall

class_name RoomData
extends Node


enum RoomTypes { EMPTY, NORMAL, GARDEN }
enum WallTypes { PLAIN, WINDOW, DOOR, PAINTING, HEDGE, HEDGE_DOOR }
enum FurnitureTypes { NONE, DESK, TABLE, MINI_CARPET }
enum FloorTypes { CARPET, PLANKS, TILES, STONE, GRASS }
enum Compass { NORTH, SOUTH, EAST, WEST }

var room_type := 0

var north_wall := 0
var south_wall := 0
var east_wall := 0
var west_wall := 0

var furniture_ne := 0
var furniture_nw := 0
var furniture_se := 0
var furniture_sw := 0

var floor_type := 0

var rng = RandomNumberGenerator.new()
var position : Vector2


func randomize_layout(theme : int) -> void:
	match theme:
		RoomTypes.EMPTY:
			set_all_walls(WallTypes.PLAIN)
			
			furniture_ne = 0
			furniture_nw = 0
			furniture_se = 0
			furniture_sw = 0
			
			floor_type = 0
		
		RoomTypes.NORMAL:
			set_all_walls(WallTypes.PLAIN)
			set_random_walls(WallTypes.WINDOW)
			set_random_walls(WallTypes.PAINTING)
			
			floor_type = randi() % 3
		
		RoomTypes.GARDEN:
			set_all_walls(WallTypes.HEDGE)
			
			floor_type = randi() % 4


func set_all_walls(wall_type : int) -> void:
	north_wall = wall_type
	south_wall = wall_type
	east_wall = wall_type
	west_wall = wall_type


func set_random_walls(wall_type : int) -> void:
	for i in range(0, 4):
		
		var wall := randi() % 4
		
		match wall:
			0: north_wall = wall_type
			1: south_wall = wall_type
			2: east_wall = wall_type
			3: west_wall = wall_type


func is_door(wall : int) -> bool:
	if wall in [WallTypes.DOOR, WallTypes.HEDGE_DOOR]:
		return true
	return false


func make_door(wall_direction : int) -> void:
	match room_type:
		RoomTypes.NORMAL:
			match wall_direction:
				Compass.NORTH: north_wall = WallTypes.DOOR
				Compass.SOUTH: south_wall = WallTypes.DOOR
				Compass.EAST: east_wall = WallTypes.DOOR
				Compass.WEST: west_wall = WallTypes.DOOR
		
		RoomTypes.GARDEN:
			match wall_direction:
				Compass.NORTH: north_wall = WallTypes.HEDGE_DOOR
				Compass.SOUTH: south_wall = WallTypes.HEDGE_DOOR
				Compass.EAST: east_wall = WallTypes.HEDGE_DOOR
				Compass.WEST: west_wall = WallTypes.HEDGE_DOOR



func get_top_repr() -> String:
	var opening_n := " " if north_wall in [WallTypes.DOOR, WallTypes.HEDGE_DOOR] else "█"
	var representation := "█%s█" % [opening_n]
	
	return representation


func get_middle_repr() -> String:
	var opening_e := " " if east_wall in [WallTypes.DOOR, WallTypes.HEDGE_DOOR] else "█"
	var opening_w := " " if west_wall in [WallTypes.DOOR, WallTypes.HEDGE_DOOR] else "█"
	var representation := "%sO%s" % [opening_w, opening_e]
	
	return representation


func get_bottom_repr() -> String:
	var opening_s := " " if south_wall in [WallTypes.DOOR, WallTypes.HEDGE_DOOR] else "█"
	var representation := "█%s█" % [opening_s]
	
	return representation

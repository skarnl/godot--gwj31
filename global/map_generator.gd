extends Node


# Super easy to use! To create a new map, simply just do `generate_map(size)`!
# You can access the size of the map using `map_dimensions`, and you can get
# map data with `map_data`.
# Map data is represented with an array of RoomData.


var map_data := [] # Only RoomData should go in here.
var map_dimensions := Vector2(2, 8)


#func _ready() -> void:
#	generate_map(map_dimensions)


func bloat_map() -> void:
	var y := 0
	
	for i in map_dimensions.x * map_dimensions.y:
		var room := RoomData.new()
		var x : int = int(fmod(i, map_dimensions.x))
		
		room.position.x = x
		room.position.y = y
		map_data.append(room)
		
		if x == map_dimensions.x - 1:
			y += 1


func clear_map() -> void:
	map_data = []


func generate_map(size : Vector2) -> void:
	map_dimensions = size
	
	clear_map()
	bloat_map()
	
	for x in map_dimensions.x:
		for y in map_dimensions.y:
			set_room(Vector2(x, y), generate_room())
	
	make_doors_for_rooms()
	
	for room in map_data:
		update_room(room.position)
	
	# Represent how the map looks in text because the interpretor isn't made yet.
#	represent_map()


func generate_room() -> RoomData:
	var room := RoomData.new()
	
	room.randomize_layout(RoomData.RoomTypes.NORMAL)
	
	return room


func get_room(room_coords : Vector2) -> RoomData:
	var room : RoomData = null
	if room_coords.x < map_dimensions.x and room_coords.y < map_dimensions.y:
		for r in map_data:
			if r.position == room_coords:
				room = r
	
	return room


func set_room(room_coords : Vector2, new_room : RoomData) -> void:
	for r in map_data:
		if r.position == room_coords:
			r = new_room


func update_room(room_coords : Vector2) -> void:
	var north_room := get_room(room_coords + Vector2.UP)
	var south_room := get_room(room_coords + Vector2.DOWN)
	var east_room := get_room(room_coords + Vector2.RIGHT)
	var west_room := get_room(room_coords + Vector2.LEFT)
	var room := get_room(room_coords)
	
	if north_room and north_room.is_door(north_room.south_wall):
		room.make_door(RoomData.Compass.NORTH)
	if south_room and south_room.is_door(south_room.north_wall):
		room.make_door(RoomData.Compass.SOUTH)
	if east_room and east_room.is_door(east_room.west_wall):
		room.make_door(RoomData.Compass.EAST)
	if west_room and west_room.is_door(west_room.east_wall):
		room.make_door(RoomData.Compass.WEST)


func make_doors_for_rooms() -> void:
	for room in map_data:
		# If we end up having time for the multi-setting idea, come back to this.
		room.room_type = RoomData.RoomTypes.NORMAL
		
		match room.room_type:
			RoomData.RoomTypes.NORMAL:
				room.set_random_walls(RoomData.WallTypes.DOOR)
			RoomData.RoomTypes.GARDEN:
				room.set_random_walls(RoomData.WallTypes.HEDGE_WALL)


func represent_map() -> void:
	for y in map_dimensions.y:
		var top : PoolStringArray
		var middle : PoolStringArray
		var bottom : PoolStringArray
		
		for x in map_dimensions.x:
			top.append(get_room(Vector2(x, y)).get_top_repr())
			middle.append(get_room(Vector2(x, y)).get_middle_repr())
			bottom.append(get_room(Vector2(x, y)).get_bottom_repr())
		
		var top_r : String
		var middle_r : String
		var bottom_r : String
		
		for s in top: top_r += s
		for s in middle: middle_r += s
		for s in bottom: bottom_r += s
		
		print(top_r)
		print(middle_r)
		print(bottom_r)

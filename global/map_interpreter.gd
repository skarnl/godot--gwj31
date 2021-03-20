extends Node


const WALLS := {
	RoomData.WallTypes.PLAIN : preload("res://entities/room_walls/plain_wall.tscn"),
	RoomData.WallTypes.WINDOW : preload("res://entities/room_walls/window_wall.tscn"),
	RoomData.WallTypes.DOOR : preload("res://entities/room_walls/wall_door.tscn"),
	RoomData.WallTypes.PAINTING : preload("res://entities/room_walls/wall_painting.tscn"),
	RoomData.WallTypes.HEDGE : preload("res://entities/room_walls/hedge.tscn"),
	RoomData.WallTypes.HEDGE_DOOR : preload("res://entities/room_walls/hedge_door.tscn")
}

const ROOM := preload("res://entities/room.tscn")


# Pass in `map_data` from `MapGenerator.map_data`
func interpret(map_data : Array) -> void:
	for room in map_data:
		Map.new_room(room.position, create_room(room))


func create_room(room_data : RoomData) -> Spatial:
	var room : Spatial = ROOM.instance()
	
	room.set_north_wall(WALLS[room_data.north_wall])
	room.set_south_wall(WALLS[room_data.south_wall])
	room.set_east_wall(WALLS[room_data.east_wall])
	room.set_west_wall(WALLS[room_data.west_wall])
	
	return room

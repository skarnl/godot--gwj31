extends Spatial


const ROOM_DIMENSIONS := Vector3(5, 3, 5)
const MAP_SIZE := Vector2(5, 5)


func _ready() -> void:
	new_map()


func new_map() -> void:
	MapInterpreter.interpret(MapGenerator.generate_map(MAP_SIZE))


func new_room(offset : Vector2, room_instance : Spatial) -> void:
	room_instance.translation = ROOM_DIMENSIONS * Vector3(offset.x, 0, offset.y)
	
	add_child(room_instance)

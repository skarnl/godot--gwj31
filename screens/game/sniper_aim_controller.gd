extends Spatial

onready var sniper := $Sniper
onready var target_points_container := $PossibleTargetLocations

var target_points: Array
var current_target_point_index := 0


func _ready():
	target_points = target_points_container.get_children()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed('switch_target'):
		var next_target_location = _get_next_target_location()
		sniper.move_target_to(next_target_location)


func _get_next_target_location() -> Vector3:
	current_target_point_index += 1
		
	if current_target_point_index >= target_points.size():
		current_target_point_index = 0
	
	var next_target = target_points[current_target_point_index]
	return next_target.translation

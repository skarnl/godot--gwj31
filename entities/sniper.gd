extends Spatial


onready var gun := $Gun
onready var laser_origin := $LaserOrigin
onready var laser := $LaserOrigin/Laser
onready var target := $Target

var original_target_position: Vector3;
var time := 0.0

func _ready() -> void:
	gun.hide()
	target.hide()
	
	original_target_position = target.translation


func _process(delta: float) -> void:
	_move_target(delta)
	_draw_laser()

# move the target slightly, to fake the laser of moving around	
func _move_target(delta) -> void:
	time += delta
	
	var size = 0.2
	var z_pos = -1 + sin(time) * 1.0 * size
	
	target.translation = original_target_position + Vector3(0, 0, z_pos)


func _draw_laser() -> void:
	laser.height = gun.translation.distance_to(target.translation)
	laser.translation.z = laser.height / 2 * -1
	laser_origin.look_at_from_position(gun.translation, target.translation, Vector3.UP)

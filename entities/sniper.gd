extends Spatial

onready var gun := $Gun
onready var laser_origin := $LaserOrigin
onready var laser := $LaserOrigin/Laser
onready var target := $Target

func _ready() -> void:
	laser.height = gun.translation.distance_to(target.translation)
	laser.translation.z = laser.height / 2 * -1
	laser_origin.look_at_from_position(gun.translation, target.translation, Vector3.UP)

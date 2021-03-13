extends Node2D

var random = RandomNumberGenerator.new()

var screen_size = Vector2.ZERO
var aimingOffset: Vector2 = Vector2.ZERO

var DEBUG = OS.is_debug_build()

onready var target = $Target

func _ready():
	random.randomize()
	
	screen_size = get_viewport().size
	_init_random_offset()

func _init_random_offset():
	aimingOffset = Vector2(random.randi_range(-100, 100), random.randi_range(-100, 100))
	
	$DebugCrosshair.aimingOffset = aimingOffset

func _input(event) -> void:
	if event is InputEventMouseButton:
		if (event.pressed):
			var adjustedAimPosition = event.position + aimingOffset
			
			if (!_check_if_hit(adjustedAimPosition)):
				$ClickSpots.spawnMissedShot(adjustedAimPosition)
			else:
				$Target.stopMoving()

func _check_if_hit(position: Vector2) -> bool:
	return $Target.is_hit(position)

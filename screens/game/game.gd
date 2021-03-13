extends Node2D

var random = RandomNumberGenerator.new()

var aimingOffset: Vector2 = Vector2.ZERO
var OFFSET_RANGE = 200

var DEBUG = OS.is_debug_build()

onready var target = $Target

func _ready():
	random.randomize()
	
	_init_random_offset()

func _init_random_offset():
	aimingOffset = Vector2(random.randi_range(-1 * OFFSET_RANGE, OFFSET_RANGE), random.randi_range(-1 * OFFSET_RANGE, OFFSET_RANGE))
	
	$DebugCrosshair.aimingOffset = aimingOffset

func _input(event) -> void:
	if event is InputEventMouseButton:
		if (event.pressed):
			var adjustedAimPosition = event.position + aimingOffset
			
			if (!$Target.is_hit(adjustedAimPosition)):
				$ClickSpots.spawnMissedShot(adjustedAimPosition)
			else:
				$Target.hit()

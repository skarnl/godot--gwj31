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
			if (!_check_if_hit(event.position)):
				$ClickSpots.spawnMissedShot(event.position)
			else:
				$Target.stopMoving()

func _check_if_hit(position: Vector2) -> bool:
	var targetWidth = target.texture.get_width()
	var targetHeight = target.texture.get_height()
	
	var hitHorizontal = position.x > target.position.x - targetWidth / 2 && position.x < target.position.x + targetWidth/2
	var hitVertical = position.y > target.position.y  - targetHeight / 2 && position.y < target.position.y + targetHeight/2
		
	return hitHorizontal && hitVertical

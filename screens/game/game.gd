extends Node2D

var random = RandomNumberGenerator.new()

var screen_size = Vector2.ZERO
var randomOffset

onready var target = $Target

func _ready():
	random.randomize()
	
	screen_size = get_viewport().size
	

func _init_random_offset():
	randomOffset = 0 #random.randi_range(0, 10)

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

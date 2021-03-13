
extends Sprite

var counter = 0
var direction = 1
var movementSpeed = 3

func _ready():
	pass
	
func _process(event) -> void:
	if (counter > 20):
		direction = -1
	
	if (counter < -20):
		direction = 1	
	
	counter += direction
	
	position.x += direction * movementSpeed
	
func stopMoving() -> void:
	set_process(false)

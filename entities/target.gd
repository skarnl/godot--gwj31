extends Node2D

var counter = 0
var direction = 1
var movementSpeed = 3

enum MovementStates {IDLE, WALKING, LOOKING_AROUND, DEAD }
enum AlertnessStates { IGNORANT, SUSPICIOUS, ALERTED, AWARE }

var current_movement_state = MovementStates.IDLE
var current_alert_state = AlertnessStates.IGNORANT

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

func is_hit(bulletPosition: Vector2) -> bool:
	var targetWidth = $face.texture.get_width()
	var targetHeight = $face.texture.get_height()
	
	var hitHorizontal = bulletPosition.x > position.x - targetWidth / 2 && bulletPosition.x < position.x + targetWidth/2
	var hitVertical = bulletPosition.y > position.y  - targetHeight / 2 && bulletPosition.y < position.y + targetHeight/2
		
	return hitHorizontal && hitVertical

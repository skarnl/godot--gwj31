extends Node2D

var counter = 0
var direction = 1
var movementSpeed = 3

enum MovementStates {IDLE, WALKING, LOOKING_AROUND, DEAD }
enum AlertnessStates { IGNORANT, SUSPICIOUS, ALERTED, AWARE }

var current_movement_state = MovementStates.IDLE
var current_alert_state = AlertnessStates.IGNORANT

var walkToPoint: Vector2 = Vector2.ZERO
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	$sprite.play('walk')
	$ChangeDirectionTimer.connect('timeout', self, '_on_ChangeDirectionTimer_timeout')
	_on_ChangeDirectionTimer_timeout()
	
func _process(event) -> void:
#	if state is walking
	walk()

func walk() -> void:
	if (global_position.distance_to(walkToPoint) > movementSpeed):
		var motion = (walkToPoint - global_position)
		position += (motion.normalized() * movementSpeed)
	else:
		changeWalkToPoint()


func _on_ChangeDirectionTimer_timeout() -> void:
	changeWalkToPoint()


func changeWalkToPoint() -> void:
	print('_on_ChangeDirectionTimer_timeout')
	
#	prob add a border
	var screen_size = get_viewport().size

	var xpos: int = random.randi_range(0, screen_size.x)
	var ypos: int = random.randi_range(0, screen_size.y)
	
	walkToPoint = Vector2(xpos, ypos)
	
	var motion = (walkToPoint - global_position)
	var flip = motion.normalized().x < 0
	$sprite.flip_h = flip


func is_hit(bulletPosition: Vector2) -> bool:
	var targetWidth = 126
	var targetHeight = 146
	
	var hitHorizontal = bulletPosition.x > position.x - targetWidth / 2 && bulletPosition.x < position.x + targetWidth/2
	var hitVertical = bulletPosition.y > position.y  - targetHeight / 2 && bulletPosition.y < position.y + targetHeight/2
		
	return hitHorizontal && hitVertical


func hit() -> void:
	set_process(false)
	$sprite.play('dead')

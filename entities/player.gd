extends KinematicBody


const GIMBAL_Y_MIN_ROTATION := -80
const GIMBAL_Y_MAX_ROTATION := 80
const MOUSE_SENSITIVITY := 200 # will be divided by 1000

enum States { IDLE, WALK, DIALOGUE }

export var move_speed : Vector3

var _direction := Vector3.ZERO
var _state : int = States.WALK

onready var _gimbal_x := $GimbalX
onready var _gimbal_y := $GimbalX/GimbalY
onready var camera := $GimbalX/GimbalY/Camera


func _physics_process(delta : float) -> void:
	state_machine()


func _input(event : InputEvent) -> void:
	camera_movement(event)


func state_machine() -> void:
	match _state:
		States.IDLE:
			pass
		
		States.WALK:
			input_movement()
			apply_movement()
		
		States.DIALOGUE:
			pass


func input_movement() -> void:
	# Reset or diminish direction so the player is not constantly moving
	# without input
	_direction = Vector3.ZERO
	
	# Get the Transform of the camera
	var camera_transform : Transform = camera.get_global_transform()
	
	# Shorten inputs to smaller named variables
	var left := Input.is_action_pressed("move_left")
	var right := Input.is_action_pressed("move_right")
	var forward := Input.is_action_pressed("move_forward")
	var backward := Input.is_action_pressed("move_backward")
	
	# Convert inputs to ints and calculate the direction in which the player
	# intends to travel in
	var movement_vector := Vector2(
		int(right) - int(left),
		int(forward) - int(backward)
	)
	
	# Apply all calculations and movement to a variable for direction
	_direction += camera_transform.basis.x * movement_vector.x
	_direction += -camera_transform.basis.z * movement_vector.y
	_direction = _direction.normalized()


func apply_movement() -> void:
	move_and_slide(_direction * move_speed, Vector3.UP)


func camera_movement(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var camera_change := Vector2(
			deg2rad(event.relative.x),
			deg2rad(event.relative.y)
		) * MOUSE_SENSITIVITY / 1000
		
		_gimbal_x.rotate_y(-camera_change.x)
		_gimbal_y.rotate_x(-camera_change.y)
		
		_gimbal_y.rotation_degrees.x = clamp(
			_gimbal_y.rotation_degrees.x,
			GIMBAL_Y_MIN_ROTATION,
			GIMBAL_Y_MAX_ROTATION
		)

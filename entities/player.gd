extends KinematicBody


const GIMBAL_Y_MIN_ROTATION := -80
const GIMBAL_Y_MAX_ROTATION := 80
const MOUSE_DESENTIFIER := 1000
const GRAVITY := 9.8

enum States { IDLE, WALK, DIALOGUE }

export var move_speed : Vector3

var _direction := Vector3.ZERO
var _velocity := Vector3.ZERO
var _state : int = States.WALK
var _last_focus : InteractableInterface

onready var _gimbal_x := $GimbalX
onready var _gimbal_y := $GimbalX/GimbalY
onready var camera := $GimbalX/GimbalY/Camera
onready var interact_area := $GimbalX/GimbalY/InteractArea
onready var interact_shape := $GimbalX/GimbalY/InteractArea/CollisionShape


func _physics_process(delta : float) -> void:
	state_machine(delta)
	interact_focus()


func _input(event : InputEvent) -> void:
	camera_movement(event)
	interact(event)


func state_machine(delta : float) -> void:
	match _state:
		States.IDLE:
			pass
		
		States.WALK:
			input_movement()
			apply_movement(delta)
		
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


func apply_movement(delta : float) -> void:
	_velocity.x = _direction.x * move_speed.x
	_velocity.z = _direction.z * move_speed.z
	_velocity.y += (-GRAVITY * delta) * int(not is_on_floor())
	
	move_and_slide(_velocity, Vector3.UP)


func camera_movement(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var camera_change : Vector2 = Vector2(
			deg2rad(event.relative.x),
			deg2rad(event.relative.y)
		) * Game.settings.look_sensitivity / MOUSE_DESENTIFIER
		
		_gimbal_x.rotate_y(-camera_change.x)
		_gimbal_y.rotate_x(-camera_change.y)
		
		_gimbal_y.rotation_degrees.x = clamp(
			_gimbal_y.rotation_degrees.x,
			GIMBAL_Y_MIN_ROTATION,
			GIMBAL_Y_MAX_ROTATION
		)


func interact_focus() -> void:
	var focus := get_closest_interactable()
	
	if _last_focus:
		_last_focus.unfocus()
	if focus:
		focus.focus()
	
	_last_focus = focus


func interact(event : InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var interactable := get_closest_interactable()
		interactable.interact()


func get_closest_interactable() -> InteractableInterface:
	var interactables := get_interactables()
	var shortest_distance : float = interact_shape.shape.length
	var result : InteractableInterface = null
	
	for interactable in interactables:
		var distance : float = transform.origin.distance_to(interactable.transform.origin)
		
		if distance < shortest_distance:
			shortest_distance = distance
			result = interactable
	
	return result


func get_interactables() -> Array:
	var potentials : Array = interact_area.get_overlapping_areas()
	var interactables : Array
	
	for potential in potentials:
		if potential is InteractableInterface:
			interactables.append(potential)
	
	return interactables

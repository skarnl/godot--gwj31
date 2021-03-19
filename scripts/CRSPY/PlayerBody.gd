extends KinematicBody
# Made by CrispyOwl717

# Player States
enum {
	IDLE_PLAYER_MOVEMENT_STATE,
	WALK_FORWARD_MOVEMENT_STATE,
	WALK_BACKWARD_MOVEMENT_STATE,
	STRAFING_MOVEMENT_STATE
}
var playerMovementState = IDLE_PLAYER_MOVEMENT_STATE

enum {
	STANDING_PLAYER_STANCE_STATE,
	WALKING_PLAYER_STANCE_STATE,
	SPRINTING_PLAYER_STANCE_STATE,
	SLOW_WALK_PLAYER_STANCE_STATE
}
var playerStanceState = STANDING_PLAYER_STANCE_STATE

# Player Movement Properties
const ACCELERATION: float = 15.0
const FRICTION: float = 0.45
const DAMPING: float = 0.1
const DEAD_ZONE: float = 0.05
const GRAVITY: float = -42.0

export var strafeSpeed: float = 1.25
export var walkForwardSpeed: float = 1.35
export var walkBackwardSpeed: float = 1.00
export var sprintSpeed: float = 2.35
export var slowWalkSpeed: float = 0.65
var maxSpeed: float = 0.0

var movementAxisValue: Vector2 = Vector2.ZERO
var velocity: Vector3 = Vector3.ZERO
var isMoving: bool = false

# Camera States
enum {
	NORMAL_CAM_STATE,
	ZOOM_CAM_STATE
}
var cameraState = NORMAL_CAM_STATE

# Camera Properties
export var mouseSensitivity: float = 0.15
export var minLookAngle: float = -70.0
export var maxLookAngle: float = 70.0

export var normalFOV: float = 55.0
export var zoomFOV: float = 45.0
export var sprintFOV: float = 65.0
export var walkBackwardFOV: float = 58.0
export var fovSpeed: float = 3.0
var targetFOV: float = 55.0

export var sprintTiltDeg: float = -8.0 # X-Rot
export var walkForwardTiltDeg: float = -3.0 # X-Rot
export var walkBackwardTiltDeg: float = 3.0 # X-Rot
export var strafeTiltDeg: float = 3.0 #Z-Rot
var targetZTilt: float = 0.0
var targetXTilt: float = 0.0

# Camera Shake Properties
var idleShakeRange: float = 3.5
var idleShakePower: float = 12.0
var strafeShakeRange: float = 7.5
var strafeShakePower: float = 13.0
var walkForwardShakeRange: float = 9.5
var walkForwardShakePower: float = 20.0
var walkBackwardShakeRange: float = 6.5
var walkBackwardShakePower: float = 15.0
var slowWalkShakeRange: float = 2.5
var slowWalkShakePower: float = 7.0
var sprintShakeRange: float = 25.0
var sprintShakePower: float = 150.0

var shakeDecay: float = 1.0
var dofLerpSpeed: float = 5.0

var currentShakePower: float = 0.0
var currentShakeRange: float = 0.0
var currentShakeTimerReset: float = 0.0
var currentShakeAmount: Vector2 = Vector2.ZERO
var cameraLerpSpeed: float = 5.0

var shakeTimer: float = 0.0
var cameraMovementNoise: OpenSimplexNoise = OpenSimplexNoise.new()

# References
export(NodePath) onready var footCollider = get_node(footCollider) as CollisionObject
export(NodePath) onready var bodyCollider = get_node(bodyCollider) as CollisionObject
export(NodePath) onready var cameraShaker = get_node(cameraShaker) as Spatial
export(NodePath) onready var cameraRoot = get_node(cameraRoot) as Spatial
export(NodePath) onready var firstPersonCam = get_node(firstPersonCam) as Camera
export(NodePath) onready var rayCast = get_node(rayCast) as RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Seed for Cam Shake
	randomize()
	cameraMovementNoise.seed = randi()
	cameraMovementNoise.octaves = 6
	cameraMovementNoise.period = 80.0
	cameraMovementNoise.persistence = 0.65

	currentShakeRange = idleShakeRange
	currentShakePower = idleShakePower

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

###### Player Movement
func _physics_process(delta):
	# Movement System
	processInput()
	checkState()
	processState()
	processMovement(delta)
	# Camera System
	processCamera(delta)
	processDynamicDOF(delta)
	pass

func processInput():
	movementAxisValue.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movementAxisValue.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

	if Input.is_action_pressed("zoomIn"):
		cameraState = ZOOM_CAM_STATE
	else:
		cameraState = NORMAL_CAM_STATE

	if Input.is_action_pressed("sprint") and is_on_floor() and -movementAxisValue.y > 0:
		playerStanceState = SPRINTING_PLAYER_STANCE_STATE
		pass
	elif Input.is_action_pressed("slowWalk") and is_on_floor():
		playerStanceState = SLOW_WALK_PLAYER_STANCE_STATE
		pass
	elif movementAxisValue.length() == 0.0:
		playerStanceState = STANDING_PLAYER_STANCE_STATE
		pass
	else:
		playerStanceState = WALKING_PLAYER_STANCE_STATE
	pass

func checkState():
	if playerStanceState == WALKING_PLAYER_STANCE_STATE:
		if movementAxisValue.length() == 0.0:
			playerMovementState = IDLE_PLAYER_MOVEMENT_STATE
		elif -movementAxisValue.y > 0:
			playerMovementState = WALK_FORWARD_MOVEMENT_STATE
		elif -movementAxisValue.y < 0:
			playerMovementState = WALK_BACKWARD_MOVEMENT_STATE
		elif movementAxisValue.x < 0 || movementAxisValue.x > 0:
			playerMovementState = STRAFING_MOVEMENT_STATE
	pass

func processState():
	#Movement and Shake Speed 
	if playerStanceState == WALKING_PLAYER_STANCE_STATE:
		if playerMovementState == IDLE_PLAYER_MOVEMENT_STATE:
			maxSpeed = 0.0
			currentShakeRange = idleShakeRange
			currentShakePower = idleShakePower
			pass
		elif playerMovementState == WALK_FORWARD_MOVEMENT_STATE:
			maxSpeed = walkForwardSpeed
			currentShakeRange = walkForwardShakeRange
			currentShakePower = walkForwardShakePower
			targetXTilt = deg2rad(walkForwardTiltDeg)
			pass
		elif playerMovementState == WALK_BACKWARD_MOVEMENT_STATE:
			maxSpeed = walkBackwardSpeed
			currentShakeRange = walkBackwardShakeRange
			currentShakePower = walkBackwardShakePower
			targetXTilt = deg2rad(walkBackwardTiltDeg)
			pass
		elif playerMovementState == STRAFING_MOVEMENT_STATE:
			maxSpeed = strafeSpeed
			currentShakeRange = strafeShakeRange
			currentShakePower = strafeShakePower
			if movementAxisValue.x < 0.0:
				targetZTilt = deg2rad(strafeTiltDeg)
			elif movementAxisValue.x > 0.0:
				targetZTilt = deg2rad(-strafeTiltDeg)
			else:
				targetZTilt = deg2rad(0.0)

		pass

	elif playerStanceState == STANDING_PLAYER_STANCE_STATE:
		maxSpeed = 0.0
		currentShakeRange = idleShakeRange
		currentShakePower = idleShakePower
		targetXTilt = deg2rad(0.0)
		targetZTilt = deg2rad(0.0)
		pass

	elif playerStanceState == SPRINTING_PLAYER_STANCE_STATE:
		maxSpeed = sprintSpeed
		currentShakeRange = sprintShakeRange
		currentShakePower = sprintShakePower
		targetXTilt = deg2rad(sprintTiltDeg)
		targetZTilt = deg2rad(0.0)
		pass

	elif playerStanceState == SLOW_WALK_PLAYER_STANCE_STATE:
		maxSpeed = slowWalkSpeed
		currentShakeRange = slowWalkShakeRange
		currentShakePower = slowWalkShakePower
		targetXTilt = deg2rad(0.0)
		targetZTilt = deg2rad(0.0)
		pass

	# Camera FOV & Tilt Settings
	if cameraState == ZOOM_CAM_STATE:
		targetFOV = zoomFOV
	else:
		if	playerStanceState == SPRINTING_PLAYER_STANCE_STATE:
			targetFOV = sprintFOV
			
		elif playerStanceState == WALK_BACKWARD_MOVEMENT_STATE:
			targetFOV = walkBackwardFOV
		else:
			targetFOV = normalFOV
			# if playerMovementState == STRAFING_MOVEMENT_STATE:
			# 	if movementAxisValue.x < DEAD_ZONE:
			# 		curTiltDegZ = -strafeTiltDeg
			# 	elif movementAxisValue.x > DEAD_ZONE:
			# 		curTiltDegZ = strafeTiltDeg
			# 	else:
			# 		curTiltDegZ = 0.0

	pass

func _processDirection() -> Vector3:
	# Movement needs to adapt to the direction the camera is facing
	var lookingDirection: = Vector3.ZERO
	lookingDirection += firstPersonCam.global_transform.basis.x * movementAxisValue.x
	lookingDirection += firstPersonCam.global_transform.basis.z * movementAxisValue.y
	lookingDirection = lookingDirection.normalized()
	return lookingDirection

func processMovement(delta):    
	# Horizontal Movement (Spring Dampened)
	if abs(movementAxisValue.x) > DEAD_ZONE:
		velocity.x += movementAxisValue.x * ACCELERATION * delta
		velocity.x *= pow(1 - DAMPING, delta * 10)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION)
	velocity.x = _processDirection().x * maxSpeed

	# Vertical Movement
	velocity.y += GRAVITY * delta

	# Depth Movement
	if abs(movementAxisValue.y) > DEAD_ZONE:
		velocity.z += movementAxisValue.y * ACCELERATION * delta
		velocity.z *= pow(1 - DAMPING, delta * 10)
	else:
		velocity.z = lerp(velocity.z, 0, FRICTION)
	velocity.z = _processDirection().z * maxSpeed

	# Apply Movement
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity.x = clamp(velocity.x, -maxSpeed * 0.9, maxSpeed * 0.9)
	velocity.z = clamp(velocity.z, -maxSpeed, maxSpeed)
	pass

###### Camera Movement
func _input(event):
	if event is InputEventMouseMotion:
		# Rotate Body Left/Right
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		# Rotate Camera Root Up/Down
		cameraRoot.rotate_x(deg2rad(-event.relative.y * mouseSensitivity))
		cameraRoot.rotation.x = clamp(cameraRoot.rotation.x, deg2rad(minLookAngle), deg2rad(maxLookAngle))

# Game Juice/Feel
func processCamera(delta):
	# Tilts
	firstPersonCam.rotation.x = lerp(firstPersonCam.rotation.x, targetXTilt, delta * cameraLerpSpeed)
	firstPersonCam.rotation.z = lerp(firstPersonCam.rotation.z, targetZTilt, delta * cameraLerpSpeed)

	# FOV & Camera Shake
	firstPersonCam.fov = lerp(firstPersonCam.fov, targetFOV, delta * fovSpeed)
	processShake(delta)
	pass
	   
# This is a more realistic headbobber
func processShake(delta: float) -> void:
	shakeTimer += delta
	shakeDecay = pow(shakeDecay, 2)

	# Apply Shake to Camera Holder
	currentShakeAmount.x = cameraMovementNoise.get_noise_3d(shakeTimer * currentShakePower, 0.0, 0.0) * currentShakeRange * shakeDecay
	cameraShaker.rotation.x = lerp(cameraShaker.rotation.x, deg2rad(currentShakeAmount.x), delta * cameraLerpSpeed)
	currentShakeAmount.y = cameraMovementNoise.get_noise_3d(0.0, shakeTimer * currentShakePower, 0.0) * currentShakeRange * shakeDecay
	cameraShaker.rotation.y = lerp(cameraShaker.rotation.y, deg2rad(currentShakeAmount.y), delta * cameraLerpSpeed)
	pass

# It'll autofocus on interacted object
func processDynamicDOF(delta: float) -> void:
	var distanceFromHitObject = (global_transform.origin - rayCast.get_collision_point()).length()
	if cameraState == ZOOM_CAM_STATE:
		firstPersonCam.environment.dof_blur_far_distance = lerp(firstPersonCam.environment.dof_blur_far_distance, distanceFromHitObject, delta * dofLerpSpeed)
	else:
		firstPersonCam.environment.dof_blur_far_distance = lerp(firstPersonCam.environment.dof_blur_far_distance, 1000, delta * dofLerpSpeed)
	pass

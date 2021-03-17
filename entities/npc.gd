extends KinematicBody


enum States { IDLE, WANDERING, DESTINATION, TALKING, DEAD }

const MAX_IDLE_TIME := 1.0
const MIN_IDLE_TIME := 0.0
const GRAVITY := 9.8
const DISTANCE_MIN := 0.01

export (NodePath) var navigation_node : String # Should link to `Navigation`.
export var move_speed : float

var _direction := Vector3.ZERO
var _velocity := Vector3.ZERO
var _path : PoolVector3Array
var _path_index := 0
var _state : int
var _last_state : int
var is_target := false

onready var navigator : Navigation = get_node(navigation_node)
onready var idle_timer := $IdleTimer


func _ready() -> void:
	switch_state(States.IDLE)


func _physics_process(delta : float) -> void:
	state_machine(delta)


func state_machine(delta : float) -> void:
	match _state:
		States.IDLE:
			if !idle_timer.time_left:
				switch_state(States.WANDERING)
			apply_movement(delta)
		
		States.WANDERING:
			calculate_movement()
			apply_movement(delta)
		
		States.DESTINATION:
			calculate_movement()
			apply_movement(delta)
		
		States.TALKING:
			pass


func state_loaded(loaded_state : int) -> void:
	match loaded_state:
		States.IDLE:
			idle_timer.wait_time = rand_range(MIN_IDLE_TIME, MAX_IDLE_TIME)
			idle_timer.start()
		
		States.WANDERING:
#			var attractions := get_tree().get_nodes_in_group("npc_wander_attraction")
#			var attraction = attractions[len(attractions)]
			
#			create_path(attraction.global_trasform.origin)
			create_path(global_transform.origin + Vector3(
				rand_range(-8.0, 8.0),
				0.0,
				rand_range(-8.0, 8.0)
			))
			_path.remove(0)
		
		States.DESTINATION:
			pass
		
		States.TALKING:
			pass
			
		States.DEAD:
			print("explode die killed ouch!")
			set_physics_process(false)
			rotate_y(90)


func switch_state(new_state : int) -> void:
	_last_state = _state
	_state = new_state
	
	state_loaded(new_state)


func create_path(target_pos : Vector3) -> void:
	_path = navigator.get_simple_path(global_transform.origin, target_pos)


func calculate_movement() -> void:
	if _path:
		_direction.x = _path[_path_index].x - global_transform.origin.x
		_direction.z = _path[_path_index].z - global_transform.origin.z
		
		if _direction.length() < DISTANCE_MIN * move_speed:
			#global_transform.origin.x = _path[_path_index].x
			#global_transform.origin.z = _path[_path_index].z
			_path_index += 1
		
		if _path_index == len(_path) or not _velocity:
			_path_index = 0
			_path = []
			switch_state(States.IDLE)


func apply_movement(delta : float) -> void:
	_direction = _direction.normalized()
	
	_velocity.x = _direction.x * move_speed
	_velocity.z = _direction.z * move_speed
	_velocity.y += (-GRAVITY * delta) * int(not is_on_floor())
	
	move_and_slide(_velocity, Vector3.UP)
	
	_direction = Vector3.ZERO


func _on_InteractableInterface_on_interact() -> void:
	switch_state(States.TALKING)


func die() -> void:
	switch_state(States.DEAD)

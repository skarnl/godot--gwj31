extends Spatial

signal target_killed


onready var gun := $Gun
onready var laser_origin := $LaserOrigin
onready var laser := $LaserOrigin/Laser
onready var target := $Target
onready var laser_pointer = $Target/Area
onready var raycast := $RayCast

var original_target_position: Vector3
var last_floor_position: Vector3
var time := 0.0

var new_target_position: Vector3
var moving := false
var aiming_at_target := false


func _ready() -> void:
	gun.hide()
	target.hide()
	
	original_target_position = target.translation
	laser_pointer.connect('body_entered', self, 'on_points_at_target')


func on_points_at_target(body: Node) -> void:
	print('on_points_at_target')
	
#	if body.is_in_group('npc') and !aiming_at_target:
#		_aim_at_target(body.translation)
#	else:
#		print("Ignore " + body.get_name())


func _aim_at_target(target_position: Vector3) -> void:
	
	print('_aim_at_target')
	
	# store the last aiming position
	last_floor_position = original_target_position
	
	aiming_at_target = true
	move_target_to(target_position + Vector3.UP) # Vector3.UP is to aim at the 'head'
	
#	this is only used now to stop the target from moving ^^
#	emit_signal('target_killed')
	

func _process(delta: float) -> void:
	if !moving:
		_wiggle_target(delta)
	else:
		_move_target_to_new_position(delta)
		
	_draw_laser()

# wiggle the target slightly, to fake the laser of moving around	
func _wiggle_target(delta) -> void:
	time += delta
	
	var wiggle_size = 0.2
	var z_pos = sin(time) * wiggle_size
	
	target.translation = original_target_position + Vector3(0, 0, z_pos)


func _physics_process(delta):
	var space_state = get_world().direct_space_state
	# use global coordinates, not local to node
	var result = space_state.intersect_ray(gun.translation, target.translation, [self])
	
	if !aiming_at_target and result and result.collider.is_in_group('npc'):
		_aim_at_target(result.collider.translation)
		
	if aiming_at_target and !result:
		aiming_at_target = false
		move_target_to(last_floor_position)
	

func _draw_laser() -> void:	
	laser.height = gun.translation.distance_to(target.translation)
	laser.translation.z = laser.height / 2 * -1
	laser_origin.look_at_from_position(gun.translation, target.translation, Vector3.UP)


# small deprecation function so I don't have to change it everywhere
func move_target_to(destination: Vector3) -> void:
	push_error('Convert code to `aim_at`')
	

func aim_at(spatial: Spatial) -> void:
	if moving:
		return
	
	moving = true
	
	new_target_position = spatial.global_transform.origin
	
	
func _move_target_to_new_position(delta: float) -> void:
	var distance = target.translation.distance_to(new_target_position)

	if distance > 1:
		var speed = 10 # Change this to increase it to more units/second
		target.translation = target.translation.move_toward(new_target_position, delta * speed)
	else:
		original_target_position = target.translation
		moving = false







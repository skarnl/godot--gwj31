extends Spatial

signal target_killed


onready var gun := $Gun
onready var laser_origin := $LaserOrigin
onready var laser := $LaserOrigin/Laser
onready var target := $Target
onready var laser_pointer = $Target/Area

var original_target_position: Vector3
var time := 0.0

var new_target_position: Vector3
var moving := false


func _ready() -> void:
	gun.hide()
	target.hide()
	
	original_target_position = target.translation
	laser_pointer.connect('body_entered', self, 'on_points_at_target')


func on_points_at_target(body: Node) -> void:
	if body.is_in_group('npc'):
		emit_signal('target_killed')
	else:
		print("Ignore " + body.get_name())


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


func _draw_laser() -> void:
	laser.height = gun.translation.distance_to(target.translation)
	laser.translation.z = laser.height / 2 * -1
	laser_origin.look_at_from_position(gun.translation, target.translation, Vector3.UP)


func move_target_to(destination: Vector3) -> void:
	if moving:
		return
	
	moving = true
	
	new_target_position = destination
	
	
func _move_target_to_new_position(delta: float) -> void:
	var distance = target.translation.distance_to(new_target_position)

	if distance > 1:
		var speed = 10 # Change this to increase it to more units/second
		target.translation = target.translation.move_toward(new_target_position, delta * speed)
	else:
		original_target_position = target.translation
		moving = false







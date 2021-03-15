extends Spatial


const BODY_TEXTURES := [
	preload("res://assets/textures/body1.png"),
	preload("res://assets/textures/body2.png"),
	preload("res://assets/textures/body3.png"),
	preload("res://assets/textures/body4.png"),
	preload("res://assets/textures/body5.png"),
	preload("res://assets/textures/body6.png"),
	preload("res://assets/textures/body7.png"),
	preload("res://assets/textures/body8.png"),
]
const HEAD_TEXTURES := [
	preload("res://assets/textures/head1.png"),
	preload("res://assets/textures/head2.png"),
	preload("res://assets/textures/head3.png"),
	preload("res://assets/textures/head4.png"),
	preload("res://assets/textures/brain.png"),
	preload("res://assets/textures/tree1.png"),
	preload("res://assets/textures/eyeball.png"),
	preload("res://assets/textures/interact_hand.png"),
]
const NO_HEADS := [
	preload("res://assets/textures/body6.png"),
	preload("res://assets/textures/body8.png"),
]
const DEFAULT_EYE_HEIGHT := 4.0
const NO_HEAD_EYE_HEIGHT := 2.0

onready var body := $BodyMaterial
onready var head := $HeadMaterial
onready var eye1 := $EyeballMaterial1
onready var eye2 := $EyeballMaterial2
onready var body_mat : SpatialMaterial = body.mesh.material
onready var head_mat : SpatialMaterial = head.mesh.material
onready var eye1_mat : SpatialMaterial = eye1.mesh.material
onready var eye2_mat : SpatialMaterial = eye2.mesh.material


func _ready() -> void:
	generate_new_suit()


func generate_new_suit() -> void:
	var body_texture : StreamTexture = BODY_TEXTURES[randi() % len(BODY_TEXTURES)]
	var head_texture : StreamTexture = HEAD_TEXTURES[randi() % len(HEAD_TEXTURES)]
	
	body_mat.albedo_texture = body_texture
	
	if not body_texture in NO_HEADS:
		eye1.translation.y = DEFAULT_EYE_HEIGHT
		eye2.translation.y = DEFAULT_EYE_HEIGHT
		
		head.show()
		head_mat.albedo_texture = head_texture
	else:
		eye1.translation.y = NO_HEAD_EYE_HEIGHT
		eye2.translation.y = NO_HEAD_EYE_HEIGHT
		
		head.hide()
	
	set_hint_color(Color(
		rand_range(0.7, 1.0),
		rand_range(0.7, 1.0),
		rand_range(0.7, 1.0)
	))


func set_hint_color(hint_color : Color) -> void:
	body_mat.albedo_color = hint_color
	head_mat.albedo_color = hint_color
	eye1_mat.albedo_color = hint_color
	eye2_mat.albedo_color = hint_color

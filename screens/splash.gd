extends Control


export(String) var game_title : String

onready var title_node := $VBoxContainer/Title
onready var animation := $AnimationPlayer
onready var timer := $Timer


func _ready() -> void:
	setup()
	intro()


func setup() -> void:
	title_node.text = game_title



func intro() -> void:
	animation.play("forefade")
	yield(animation, "animation_finished")
	animation.play("default")
	yield(animation, "animation_finished")
	
	_fade_to_main_menu()


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		_fade_to_main_menu()


func _fade_to_main_menu() -> void:
	animation.play("fadeout")
	yield(animation, "animation_finished")	
	Game.transition_to(Game.GameState.MAIN_MENU)

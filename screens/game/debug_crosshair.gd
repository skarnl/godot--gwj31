extends Node2D

var aimingOffset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if !OS.is_debug_build():
		hide()
		set_process_input(false)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		position = event.position + aimingOffset

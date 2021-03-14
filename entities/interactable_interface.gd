tool
class_name InteractableInterface
extends Area


signal on_interact
signal on_focused
signal on_unfocused

export var shape : Shape setget _set_shape

onready var collision_shape := $CollisionShape
onready var hint_mesh := $Hint


func _set_shape(new_shape : Shape) -> void:
	shape = new_shape
	collision_shape.shape = shape


func interact() -> void:
	emit_signal("on_interact")


func focus() -> void:
	hint_mesh.show()
	emit_signal("on_focus")


func unfocuse() -> void:
	hint_mesh.hide()
	emit_signal("on_unfocus")

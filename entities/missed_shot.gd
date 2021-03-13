extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite.play()
	
	yield($AnimatedSprite, 'animation_finished')
	
	queue_free()

extends CanvasLayer


onready var target_killed_notice := $TargetKilledText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()


func show_target_killed() -> void:
	target_killed_notice.show()
	
	
func reset() -> void:
	target_killed_notice.hide()

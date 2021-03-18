extends Control


func _ready() -> void:
	hide()
	
	
func open() -> void:
	show()
	set_process_input(true)
	
func close() -> void:
	set_process_input(true)

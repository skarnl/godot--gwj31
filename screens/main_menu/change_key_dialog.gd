extends Panel

signal key_selected(scancode)


func _ready():
	close()


func _input(event):
	if not event is InputEventKey or not event.is_pressed():
		return
	
	emit_signal("key_selected", event.scancode)
	
	get_tree().set_input_as_handled()
	
	close()


func open():
	show()
	set_process_input(true)


func close():
	hide()
	set_process_input(false)


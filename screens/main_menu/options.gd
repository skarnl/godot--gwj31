extends Control

signal close_options

onready var back_button := $BackButton
onready var key_list := $Content/ScrollContainer/KeyList
onready var change_key_dialog := $ChangeKeyDialog

func _ready() -> void:
	hide()
	
	key_list.connect('change_key_pressed', self, '_on_KeyList_change_key_pressed')
	back_button.connect('pressed', self, '_on_back_to_main_pressed')
	
	build_key_list()
	
	
func build_key_list() -> void:
	var keys = Settings.getInputMapping()
	
	key_list.clear()
	
	for action_index in keys:
		key_list.add_item(action_index, keys[action_index])
		
	
func open() -> void:
	show()
	key_list.focus()
	
	
func _on_back_to_main_pressed() -> void:
	emit_signal('close_options')


func _on_KeyList_change_key_pressed(action_index, type) -> void:
	set_process_input(false)
	
	change_key_dialog.open()
	
	var key_scancode = yield(change_key_dialog, "key_selected")
	
	if key_scancode == KEY_ESCAPE:
		Settings.removeInputMappingKey(action_index, type)
		key_list.update_key(action_index, null, type)
	else:
		Settings.changeInputMappingKey(action_index, key_scancode, type)
		key_list.update_key(action_index, key_scancode, type)
	
	set_process_input(true)

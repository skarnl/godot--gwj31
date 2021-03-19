extends Control

signal close_options

onready var back_button := $BackButton
onready var key_list := $Content/ScrollContainer/KeyList

func _ready() -> void:
	back_button.connect('pressed', self, '_on_back_to_main_pressed')
	hide()
	
	build_key_list()
	
	
func build_key_list() -> void:
	key_list.add_item({ 'action': 'forward', 'key': 'w', 'alternative': ''})
	key_list.add_item({ 'action': 'backward', 'key': 's', 'alternative': ''})
	key_list.add_item({ 'action': 'left', 'key': 'a', 'alternative': ''})
	key_list.add_item({ 'action': 'right', 'key': 'd', 'alternative': 'p'})
	key_list.add_item({ 'action': 'interact', 'key': 'e', 'alternative': ''})

	
func open() -> void:
	show()
	key_list.focus()
	
	
func _on_back_to_main_pressed() -> void:
	emit_signal('close_options')

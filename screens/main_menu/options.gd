extends Control

signal options_closed

onready var back_button := $BackButton
onready var key_list := $Content/ScrollContainer/KeyList

func _ready() -> void:
	back_button.connect('pressed', self, 'close')
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
	
	
func close() -> void:
	hide()
	emit_signal('options_closed')

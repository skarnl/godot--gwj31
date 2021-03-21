extends VBoxContainer


signal change_key_pressed(index, type)


var ListItem = preload('res://screens/main_menu/key_list_item.tscn')


func _ready() -> void:
	pass # Replace with function body.


func add_item(action_index, keySettings) -> void:
	var item = ListItem.instance()
	
	item.connect('change_key_pressed', self, '_on_Item_change_key_pressed', [action_index])	
	item.init(keySettings)
	add_child(item)


func clear() -> void:
	# remove all children
	pass


# helper to focus on the first key in the list
func focus() -> void:
	if get_child_count() > 0:
		var children = get_children()
		children[0].focus()


func _on_Item_change_key_pressed(type, action_index) -> void:
	emit_signal('change_key_pressed', action_index, type)


func update_key(index, key_scancode, type) -> void:
	var key_list_item = get_child(index)
	key_list_item.update_key(key_scancode, type)

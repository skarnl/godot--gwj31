extends VBoxContainer


var ListItem = preload('res://screens/main_menu/key_list_item.tscn')


func _ready() -> void:
	pass # Replace with function body.


func add_item(options) -> void:
	var item = ListItem.instance()
	item.init(options.action, options.key, options.alternative)
	add_child(item)


func clear() -> void:
	# remove all children
	pass

# helper to focus on the first key in the list
func focus() -> void:
	if get_child_count() > 0:
		var children = get_children()
		children[0].focus()

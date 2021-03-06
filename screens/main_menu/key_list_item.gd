extends HBoxContainer



signal change_key_pressed(type)


func _ready() -> void:
	$KeyButton.connect('pressed', self, '_on_KeyButton_pressed', ['key'])
	$AlternativeButton.connect('pressed', self, '_on_KeyButton_pressed', ['alt_key'])


func init(key_settings) -> void:
	$Action.text = key_settings.name

	$KeyButton.text = OS.get_scancode_string(key_settings.key)

	if key_settings.alt_key:
		$AlternativeButton.text = OS.get_scancode_string(key_settings.alt_key)
	else:
		$AlternativeButton.text = '[empty]'


# helper to focus on the button
func focus() -> void:
	$KeyButton.grab_focus()


func _on_KeyButton_pressed(type: String) -> void:
	emit_signal('change_key_pressed', type)


func update_key(key_scancode, type: String) -> void:
	var value = '[empty]'
	
	if key_scancode:
		value = OS.get_scancode_string(key_scancode)
	
	if type == 'key':
		$KeyButton.text = value
	else:
		$AlternativeButton.text = value

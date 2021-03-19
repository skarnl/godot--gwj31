extends Node

enum Category { INPUT, KEY_BINDINGS, SOUND }
enum InputSettings { LOOK_SENSITIVITY }
enum KeySettings { FORWARD, BACKWARD, LEFT, RIGHT, INTERACT, PAUSE }
enum SoundSettings { ENABLE_MUSIC, MUSIC_VOLUME, ENABLE_SFX, SFX_VOLUME }


var _settings := {
	Category.INPUT : {
		InputSettings.LOOK_SENSITIVITY: 200,
	},
	Category.KEY_BINDINGS: {
		KeySettings.FORWARD: {
			"name": "forward",
			"input_name": "move_forward",
			"key": KEY_W,
			"alt_key": null,
		},
		KeySettings.BACKWARD: {
			"name": "backward",
			"input_name": "move_backward",
			"key": KEY_S,
			"alt_key": null,
		},
		KeySettings.LEFT: {
			"name": "left",
			"input_name": "move_left",
			"key": KEY_A,
			"alt_key": null,
		},
		KeySettings.RIGHT: {
			"name": "right",
			"input_name": "move_right",
			"key": KEY_D,
			"alt_key": null,
		},	
		KeySettings.INTERACT: {
			"name": "interact",
			"input_name": "interact",
			"key": KEY_E,
			"alt_key": null,
		},
		KeySettings.PAUSE: {
			"name": "pause",
			"input_name": "pause",
			"key": KEY_ESCAPE,
			"alt_key": null,
		},	
	},
	Category.SOUND: {
		SoundSettings.ENABLE_MUSIC : true,
		"music_volume": 1,
		"sfx" : true,
		"sfx_volume": 1,
		"master_volume": 1
	}
}


func _validate(category, settings_key = null) -> void:
	if settings_key:
		if not _settings.has(category) or not _settings[category].has(settings_key):
			push_error("No settings exist for: " + category + ", " + settings_key)
	else:
		if not _settings.has(category):
			push_error("No settings exist for: " + category)


func get_input_mapping() -> Dictionary:
	return _settings[Category.KEY_BINDINGS]


func change_input_mapping_key(action_index: int, key_scancode, type: String) -> void:
	var action_settings = _settings[Category.KEY_BINDINGS][action_index]
	var action_name = action_settings.input_name
	
	action_settings[type] = key_scancode
	
	InputMap.action_erase_events(action_name)

	if (action_settings['key']):
		_add_action_event(action_name, action_settings['key'])
		
	if (action_settings['alt_key']):
		_add_action_event(action_name, action_settings['alt_key'])
	
	_settings[Category.KEY_BINDINGS][action_index] = action_settings
	
	
func _add_action_event(action_name: String, key_scancode: int) -> void:
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)


func update_setting(category, settings_key, value) -> void:
	_validate(category, settings_key)
	_settings[category][settings_key] = value


func get_setting(category, settings_key):
	_validate(category, settings_key)
	return _settings[category][settings_key]

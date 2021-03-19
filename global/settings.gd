extends Node

enum Category { INPUT, KEY_BINDINGS, SOUND }
enum InputSettings { LOOK_SENSITIVITY }
enum KeySettings { FORWARD, BACKWARD, LEFT, RIGHT, INTERACT }
enum SoundSettings { ENABLE_MUSIC, MUSIC_VOLUME, ENABLE_SFX, SFX_VOLUME }


var _settings := {
	Category.INPUT : {
		InputSettings.LOOK_SENSITIVITY: 200,
	},
	Category.KEY_BINDINGS: {
		KeySettings.FORWARD: "w",
		"backward": "s",
		"left": "a",
		"right": "d",
		"interact": "e",
	},
	Category.SOUND: {
		SoundSettings.ENABLE_MUSIC : true,
		"music_volume": 1,
		"sfx" : true,
		"sfx_volume": 1,
		"master_volume": 1
	}
}


func _validate(category, settingsKey) -> void:
	if not _settings.has(category) or not _settings[category].has(settingsKey):
		push_error("No settings exist for: " + category + ", " + settingsKey)


func updateSetting(category, settingsKey, value) -> void:
	_validate(category, settingsKey)
	_settings[category][settingsKey] = value
	

func getSetting(category, settingsKey):
	_validate(category, settingsKey)
	return _settings[category][settingsKey]

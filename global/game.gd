# this script will hold the overall game state

extends Node


var Screens = {
	MAIN_MENU = 'res://screens/main_menu/main_menu.tscn',
	GAME = 'res://screens/game/game.tscn',
	PLAYER_MOVEMENT_TEST = 'res://screens/game/player_movement_test_world.tscn'
}


enum GameState {
	SPLASH,
	MAIN_MENU,
	GAME,
	PAUSED,
	GAME_OVER
}

var _current_state: int = GameState.SPLASH setget _set_current_state
var _previous_state: int


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	

func start_game():
	transition_to(GameState.GAME)
	

# change the state to the next
func transition_to(new_state: int) -> void:
	match new_state:
		GameState.MAIN_MENU:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			_current_state = new_state
			SceneLoader.goto_scene(Screens.MAIN_MENU)
		
		GameState.GAME:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
			if _current_state in {GameState.MAIN_MENU: true}:
				_current_state = new_state
				SceneLoader.goto_scene(Screens.PLAYER_MOVEMENT_TEST)
				
#			match new_state:
#				GameState.PAUSED:
#					_current_state = GameState.PAUSED
#					emit_signal("game_paused")
#					get_tree().paused = true
#
#				GameState.GAME_DIALOG_OPENED:
#					_current_state = GameState.GAME_DIALOG_OPENED
#					get_tree().paused = true
#
#				GameState.GAME_OVER:
#					_current_state = GameState.GAME_OVER
#					get_tree().paused = true
#					emit_signal("game_over")
#
#		GameState.GAME_DIALOG_OPENED:
#				match new_state:
#					GameState.GAME:
#						_current_state = GameState.GAME
#						get_tree().paused = false
#
#						if is_current_level_finished:
#							emit_signal("level_finished")
#							get_tree().paused = true
#
#					GameState.PAUSED:
#						_current_state = GameState.PAUSED
#						emit_signal("game_paused")
#						get_tree().paused = true
#
#		GameState.GAME_OVER:
#			if new_state == GameState.MENU:
#				_current_state = GameState.MENU
#				get_tree().paused = false
#				SceneLoader.goto_scene('res://menu/main_menu.tscn')
#
#		GameState.PAUSED:
#			match new_state:
#				GameState.MENU:
#					_current_state = GameState.MENU
#					get_tree().paused = false
#					emit_signal("game_resumed")
#					SceneLoader.goto_scene('res://menu/main_menu.tscn')
#
#				GameState.GAME:
#					_current_state = GameState.GAME
#					get_tree().paused = false
#					emit_signal("game_resumed")
#
#				GameState.GAME_DIALOG_OPENED:
#					_current_state = GameState.GAME_DIALOG_OPENED
#					emit_signal("game_resumed")


# pause handler
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			match _current_state:
				GameState.GAME:
					transition_to(GameState.PAUSED)
			
				GameState.PAUSED:
					transition_to(GameState.GAME)


func _set_current_state(new_state:int) -> void:
	_previous_state = _current_state
	_current_state = new_state

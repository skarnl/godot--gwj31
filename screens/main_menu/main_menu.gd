extends Control


onready var start_button := $MainButtons/Buttons/StartButton
onready var options_button := $MainButtons/Buttons/OptionsButton
onready var credits_button := $MainButtons/Buttons/CreditsButton

onready var main_buttons := $MainButtons
onready var options_menu := $Options

enum MenuStates { MAIN_BUTTONS, OPTIONS, CREDITS }
var current_state


func _ready() -> void:
	_initialize_listeners()
	
	_change_state_to(MenuStates.MAIN_BUTTONS)


func _initialize_listeners() -> void:
	start_button.connect('pressed', self, '_on_Button_pressed', ['start'])
	options_button.connect('pressed', self, '_on_Button_pressed', ['options'])
	credits_button.connect('pressed', self, '_on_Button_pressed', ['credits'])
	
	options_menu.connect("close_options", self, '_on_Options_closed')


func _change_state_to(new_state) -> void:
	_handle_state_leave(current_state)
	
	current_state = new_state
	
	_handle_state_enter(new_state)
	
	
func _handle_state_leave(old_state) -> void:
	match old_state:
		MenuStates.MAIN_BUTTONS:
			main_buttons.hide()
			pass
			
		MenuStates.OPTIONS:
			options_menu.hide()
			pass
			
		MenuStates.CREDITS:
			# credits.close()
			pass


func _handle_state_enter(new_state) -> void:
	match new_state:
		MenuStates.MAIN_BUTTONS:
			main_buttons.show()
			start_button.grab_focus()
			pass
			
		MenuStates.OPTIONS:
			options_menu.open()
			pass
			
		MenuStates.CREDITS:
			print("open credits")
			# credits.open()
			pass


func _on_Button_pressed(action) -> void:
	match action:
		'start': 
			Game.start_game()
			
		'options':
			_change_state_to(MenuStates.OPTIONS)
			
		'credits':
			_change_state_to(MenuStates.CREDITS)


func _on_Options_closed() -> void:
	_change_state_to(MenuStates.MAIN_BUTTONS)

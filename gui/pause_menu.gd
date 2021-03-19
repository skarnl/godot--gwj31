extends Control


onready var continue_button := $Buttons/Buttons/ContinueButton
onready var options_button := $Buttons/Buttons/OptionsButton
onready var quit_button := $Buttons/Buttons/QuitButton

onready var buttons := $Buttons
onready var options_menu := $Options

enum MenuStates { PAUSE_MENU, OPTIONS }
var current_state


func _ready() -> void:
	hide()
	
	_initialize_listeners()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed('pause'):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_change_state_to(MenuStates.PAUSE_MENU)



func _initialize_listeners() -> void:
	continue_button.connect('pressed', self, '_on_Button_pressed', ['continue'])
	options_button.connect('pressed', self, '_on_Button_pressed', ['options'])
	quit_button.connect('pressed', self, '_on_Button_pressed', ['quit'])
	
	options_menu.connect("close_options", self, '_on_Options_closed')


func _change_state_to(new_state) -> void:
	_handle_state_leave(current_state)
	
	current_state = new_state
	
	_handle_state_enter(new_state)
	
	
func _handle_state_leave(old_state) -> void:
	match old_state:
		MenuStates.PAUSE_MENU:
			buttons.hide()
			
		MenuStates.OPTIONS:
			options_menu.hide()


func _handle_state_enter(new_state) -> void:
	match new_state:
		MenuStates.PAUSE_MENU:
			buttons.show()
			continue_button.grab_focus()
			
		MenuStates.OPTIONS:
			options_menu.open()
			


func _on_Button_pressed(action) -> void:
	match action:
		'continue': 
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			hide()
			
		'options':
			_change_state_to(MenuStates.OPTIONS)
			
		'quit':
			get_tree().paused = false
			Game.transition_to(Game.GameState.MAIN_MENU)


func _on_Options_closed() -> void:
	_change_state_to(MenuStates.PAUSE_MENU)

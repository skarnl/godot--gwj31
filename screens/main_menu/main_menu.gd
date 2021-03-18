extends Control


onready var start_button := $Buttons/StartButton
onready var options_button := $Buttons/OptionsButton
onready var credits_button := $Buttons/CreditsButton
onready var options_menu := $Options


func _ready() -> void:
	start_button.grab_focus()
	
	start_button.connect('pressed', self, '_on_Button_pressed', ['start'])
	options_button.connect('pressed', self, '_on_Button_pressed', ['options'])
	credits_button.connect('pressed', self, '_on_Button_pressed', ['credits'])
	
	options_menu.connect('options_closed', self, '_on_Options_closed')


func _on_Button_pressed(action) -> void:
	print(action)
	
	match action:
		'start': 
			Game.start_game()
			
		'options':
			_open_options()
			
		'credits':
			_open_credits()

func _open_options() -> void:
	options_menu.open()
	
func _open_credits() -> void:
	pass
	
		
func _on_Options_closed() -> void:
	start_button.grab_focus()

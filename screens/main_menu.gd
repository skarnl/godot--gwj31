extends Control


onready var start_button := $Buttons/StartButton
onready var options_button := $Buttons/OptionsButton
onready var credits_button := $Buttons/CreditsButton


func _ready() -> void:
	start_button.grab_focus()
	
	start_button.connect('pressed', self, '_on_Button_pressed', ['start'])
	options_button.connect('pressed', self, '_on_Button_pressed', ['options'])
	credits_button.connect('pressed', self, '_on_Button_pressed', ['credits'])


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
	pass
	
func _open_credits() -> void:
	pass
	
		

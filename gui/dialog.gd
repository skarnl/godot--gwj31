extends Control

signal answer_given(correct)


onready var answers = $VBoxContainer/Answers


var correct_answer_index = 2


func _ready() -> void:
	hide()
	
	for index in answers.get_child_count():
		var is_correct_answer = index == correct_answer_index
		var button = answers.get_child(index)
	
		button.connect('pressed', self, '_on_button_pressed', [is_correct_answer])
	
		if is_correct_answer:
			button.text += ' {right answer}'

func _on_button_pressed(correct) -> void:
	emit_signal('answer_given', correct)
	hide()


func _input(event: InputEvent) -> void:
	if visible and event is InputEventKey and (event.is_action_pressed('pause') or event.is_action_pressed('interact')):
		hide()

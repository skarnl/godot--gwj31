extends HBoxContainer


func init(actionName: String, key: String, alternative: String = '') -> void:
	$Action.text = actionName
	
	$KeyButton.text = key
	
	if alternative != '':
		$AlternativeButton.text = alternative
	else:
		$AlternativeButton.text = '[empty]'

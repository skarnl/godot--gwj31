extends Sprite

signal moved
signal hit_head

var _precursorReference
var previous_position


func set_precursor(snakePartReference):
	_precursorReference = snakePartReference
	_precursorReference.connect("moved", self, "_on_Precursor_moved")
	
	position = _precursorReference.position
	
	hide()

	
func _on_Precursor_moved(precursor_position):
	show()
	previous_position = position
	
	position = precursor_position
	
	emit_signal("moved", previous_position)


func destroy():
	_precursorReference.disconnect("moved", self, "_on_Precursor_moved")
	queue_free()

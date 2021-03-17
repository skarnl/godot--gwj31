extends Node


# How to use ObjectiveManager:
# Very simple! To assign an objective, just call `assign_objective`.
# For example:
#```
##ObjectiveManager.assign_objective(
##	ObjectiveManager.ObjectiveTypes.DEPARTURE,
##	ObjectiveManager.departure_args(random_npc())
##)
#```
# You should use `???_args` where "???" holds the same name as your objective
# type. Follow this guide to understand:
### `FETCH` - `fetch_args(item)`
### `DEPARTURE` - `departure_args(npc)`
### `COMMUNICATE` - `communicate_args(npc)`
#
# Now, you'll want to update your objective. To do so, call `resolve_objective`.
# For example:
## `ObjectiveManager.resolve_objective(self)`
# Where `self` is the most relevant object to the current mission.
# If you're unsure, try to follow this guide:
## `FETCH` - You should pass in the item that must be fetched.
## `DEPARTURE` - You should pass in the NPC that should be departing.
## `COMMUNICATE` - You should pass in the NPC that must be communicated with.
#
# Try to think of `resolve_objective` as more of an update, less than an
# objective. It performs all the necessary checks in the function, so you
# should just call it at any appropriate time, without any checks if possible.


signal on_objective_complete

enum ObjectiveTypes {
	FETCH, # Fetch an item and bring it to the target
	DEPARTURE, # Make an NPC party member leave the party
	COMMUNICATE, # Talk to a random NPC for the target
}

var objective_type : int
var _objective_data := {}
var objective_achieved := false


func assign_objective(
	desired_objective_type : int,
	objective_arguments : Dictionary
) -> void:
	objective_achieved = false
	objective_type = desired_objective_type
	_objective_data = objective_arguments


func resolve_objective(objective_object : Spatial) -> void:
	if not objective_achieved:
		match objective_type:
			ObjectiveTypes.FETCH:
				if objective_object == _objective_data["item"]:
					complete_objective()
			
			ObjectiveTypes.DEPARTURE:
				if objective_object == _objective_data["departee"]:
					complete_objective()
			
			ObjectiveTypes.COMMUNICATE:
				if objective_object == _objective_data["communicatee"]:
					complete_objective()


func complete_objective() -> void:
	objective_achieved = true
	emit_signal("on_objective_complete")


func fetch_args(item : Spatial) -> Dictionary:
	var result := {
		"item": item
	}
	
	return result


func departure_args(departee : Spatial) -> Dictionary:
	var result := {
		"departee": departee
	}
	
	return result


func communicate_args(communicatee : Spatial) -> Dictionary:
	var result := {
		"communicatee": communicatee
	}
	
	return result

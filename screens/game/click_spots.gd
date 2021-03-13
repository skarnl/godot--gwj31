extends Node2D

var missedShotPrefab = preload("res://entities/missed_shot.tscn")

func spawnMissedShot(pos:Vector2) -> void :
	var shot = missedShotPrefab.instance()
	shot.position = pos
	
	add_child(shot)

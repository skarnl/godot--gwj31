extends Spatial

onready var hud := $HUD
onready var sniper := $Sniper
onready var npc := $NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sniper.connect('target_killed', self, '_on_target_killed')


func _on_target_killed() -> void:
	npc.die()
	hud.show_target_killed()

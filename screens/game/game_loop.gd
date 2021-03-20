extends Spatial

onready var hud := $HUD
onready var sniper := $Sniper
onready var npc := $NPC
onready var dialog := $Dialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sniper.connect('target_killed', self, '_on_target_killed')
	
	dialog.connect('answer_given', self, '_on_answer_given')
	
	_setup_target_interaction()
	
	
func _setup_target_interaction() -> void:
	$BlueNPCInteractable.connect('on_interact', self, '_on_target_interaction')
	
	

func _on_target_interaction() -> void:
	dialog.show()
	get_tree().paused = true
	

func _on_answer_given(answer_correct) -> void:
	print('answer_given', answer_correct)
	
	if answer_correct:
		sniper.aim_at($BlueNPC)
	else:
		sniper.aim_at($Player)
	
	get_tree().paused = false
	

func _on_target_killed() -> void:
	npc.die()
	hud.show_target_killed()

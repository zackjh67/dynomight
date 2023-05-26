extends Action

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _interact():
	G.emit_signal('global_dialogue_started')
	DialogueManager.show_global_dialogue_balloon(\
		$DialogueConfig.node_title, \
		load($DialogueConfig.dialogue_path)
	)
	await DialogueManager.dialogue_finished
	G.emit_signal('global_dialogue_finished')

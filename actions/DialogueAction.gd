extends Action

export var dialogue_config = {
	'text': 'Hello World',
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	G.open_dialogue(dialogue_config)
	yield(G.Dialogue, 'dialogue_finished')
	emit_signal('action_finished')

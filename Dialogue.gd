extends CanvasLayer

signal dialogue_finished
signal dialogue_started


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open_dialogue(config:DialogueConfig):
	
	emit_signal('dialogue_started')
	self.show()
	$Label.text = config.text
	if !config.keep:
		yield(get_tree().create_timer(Constants.GLOBAL_DIALOGUE_TIMEOUT/G.FAST_FORWARD), "timeout")
		close_dialogue()
	
func close_dialogue():
	self.hide()
	$Label.text = ''
	emit_signal('dialogue_finished')

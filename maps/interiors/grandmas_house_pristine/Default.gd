extends YSort


var snack_ate = false

func action_finished():
	var noodles = get_node("noodles")
	if noodles and snack_ate:
		remove_child(noodles)
		$Doors/Outside.locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$noodles/AreaInteractable/Actions/DialogueAction.connect('action_finished', self, 'action_finished')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

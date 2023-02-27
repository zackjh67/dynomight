extends YSort

onready var state = $State
var _state_key = 'Pristine.Grandmas.Default'
var _initial_state = {
	'snack_ate': { 'value': false, '_persist': true },
}

func action_finished():
	var noodles = get_node("noodles")
	if noodles and state.get('snack_ate'):
		eat_the_noodles()

# Called when the node enters the scene tree for the first time.
func _ready():
	state.init(_state_key, _initial_state)
	if state.get('snack_ate'):
		print(state.get('snack_ate'))
		print('snack ate true lol')
		eat_the_noodles()
	else:
		$noodles/AreaInteractable/Actions/DialogueAction.connect('action_finished', self, 'action_finished')
	print('what the fuck? ', state.state)

func eat_the_noodles():
	var noodles = get_node("noodles")
	state.set('snack_ate', true)
	remove_child(noodles)
	$Doors/Outside.locked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

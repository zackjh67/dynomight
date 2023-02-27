extends YSort

onready var state = $State
var _state_key = Constants.state_keys.GRANDMAS_PRISTINE_DEFAULT
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
		eat_the_noodles()
	else:
		$noodles/AreaInteractable/Actions/DialogueAction.connect('action_finished', self, 'action_finished')

func eat_the_noodles():
	var noodles = get_node("noodles")
	state.set('snack_ate', true)
	remove_child(noodles)
	$Doors/Outside.locked = false

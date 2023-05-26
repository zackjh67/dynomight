extends Node

class_name State

var key_name = "Path.To.Node"
var state = {}
var persist = []

func init(key, init_state):
	if key:
		key_name = key
		
	var persisting_values = {}
	if init_state:
		#	find if key contains persisted data or not	
		for k in init_state:
			if init_state[k] is Dictionary:
				if init_state[k].has('_persist') and init_state[k]['_persist']:
					persist.push_front(k)
					persisting_values[k] = init_state[k]['value']
		state = init_state
	
		# load in persistent state variables for overrides
		var overrides = G.persistent_state.get(key_name)
		if overrides:
			var overwritten = H.merge_dict(persisting_values, overrides)
			state = H.merge_dict(state, overwritten)
		else:
			# no overrides so convert config dictionaries to their values
			for k in state:
				if state[k] is Dictionary and state[k].has('_persist'):
					if state[k]['_persist']:
						persist.push_front(k)
					state[k] = state[k]['value']

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _get(key):
	if state.has(key):
		return state[key]
	return null

func _set(key, val): 
	state[key] = val
	if key in persist:
		var key_str = "{a}.{b}".format({"a":key_name, "b": key})
		G.persistent_state.set(key_str, val)
	return val

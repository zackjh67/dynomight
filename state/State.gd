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
		for key in init_state:
			if init_state[key] is Dictionary:
				if init_state[key].has('_persist') and init_state[key]['_persist']:
					persist.push_front(key)
					persisting_values[key] = init_state[key]['value']
		state = init_state
	
		# load in persistent state variables for overrides
		var overrides = G.persistent_state.get(key_name)
		print('overrides!! ', overrides)
		if overrides:
			var overridden = H.merge_dict(persisting_values, overrides)
			print('overridden: ', overridden)
			state = H.merge_dict(state, overridden)
		else:
			# no overrides so convert config dictionaries to their values
			for key in state:
				if state[key] is Dictionary and state[key].has('_persist'):
					if state[key]['_persist']:
						persist.push_front(key)
					state[key] = state[key]['value']

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get(key):
	if state.has(key):
		return state[key]
	return null

func set(key, val): 
	state[key] = val
	if key in persist:
		var key_str = "{a}.{b}".format({"a":key_name, "b": key})
		G.persistent_state.set(key_str, val)
	return val

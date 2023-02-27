extends State

# Called when the node enters the scene tree for the first time.
func _ready():
	print('persistent state ready')
	pass # Replace with function body.
	
func get(key):
	var tree:Array = key.split('.')
	return get_fruit(state, tree)

func set(key, val):
	var branches:Array = key.split('.')
	return climb_tree(state, branches, val)

# sets a nested property variable, returns what the val used to be. idk why that would be useful :)
func climb_tree(tree, branches, val):
	if branches.size() == 1:
		var old_val = null
		if tree.has(branches[0]):
			old_val = tree[branches[0]]
		tree[branches[0]] = val
		return old_val
	var key = branches.pop_front()
	if !tree.has(key):
		tree[key] = {}
	climb_tree(tree[key], branches, val)
	
# gets a nested property variable
func get_fruit(tree, branches):
	if branches.size() == 1:
		return tree[branches[0]]
	var key = branches.pop_front()
	if !tree.has(key):
		return null
	return get_fruit(tree[key], branches)

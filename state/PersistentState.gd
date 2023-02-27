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
	climb_tree(state, branches, val)

func climb_tree(tree, branches, val):
	if branches.size() == 1:
		tree[branches[0]] = val
		return
	var key = branches.pop_front()
	if !tree.has(key):
		tree[key] = {}
	climb_tree(tree[key], branches, val)
	
func get_fruit(tree, branches):
	if branches.size() == 1:
		return tree[branches[0]]
	var key = branches.pop_front()
	if !tree.has(key):
		return null
	return get_fruit(tree[key], branches)

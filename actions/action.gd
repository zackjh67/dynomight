extends Node

var scene
signal action_finished

class_name Action

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('action')
	scene = get_tree().get_nodes_in_group('action_scene')

func interact():
	print('override this method plz')
	emit_signal('action_finished')

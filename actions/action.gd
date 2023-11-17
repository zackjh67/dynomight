extends Node

class_name Action

var scene
signal action_started
signal action_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('action')
	scene = get_tree().get_nodes_in_group('action_scene')

func _interact():
	print('override this method plz')

func interact():
	emit_signal('action_started')
#	await _interact().completed
	emit_signal('action_finished')

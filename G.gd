extends Node

onready var Dialogue = get_node("/root/Main/Dialogue")

var FAST_FORWARD:float = 1

var current_interactable

export var player_direction:Vector2 = Vector2.DOWN

func set_current_interactable(node):
	current_interactable = node
	
func open_dialogue(config):
	Dialogue.open_dialogue(config)


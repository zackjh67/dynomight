extends Node

signal global_dialogue_started
signal global_dialogue_finished

onready var Dialogue = get_node("/root/Main/Dialogue")

var FAST_FORWARD:float = 7

var current_interactable
var scene_switcher

export var player_direction:Vector2 = Vector2.UP

func _ready():
	pass

func set_current_interactable(node):
	current_interactable = node
	
func open_dialogue(config):
	Dialogue.open_dialogue(config)

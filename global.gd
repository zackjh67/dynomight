extends Node

signal global_dialogue_started
signal global_dialogue_finished

var Dialogue;
var game_stat;
var player_state;
var level_state;
var persistent_state;

var FAST_FORWARD:float = 7

var current_interactable
var scene_manager

@export var player_direction:Vector2 = Vector2.UP

func _ready():
	pass

func set_current_interactable(node):
	current_interactable = node
	
func open_dialogue(config):
	Dialogue.open_dialogue(config)

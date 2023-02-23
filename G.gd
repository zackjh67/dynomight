extends Node

signal global_dialogue_started
signal global_dialogue_finished

onready var Dialogue = get_node("/root/Main/Dialogue")

var FAST_FORWARD:float = 1

var current_interactable
var current_map
var player

export var player_direction:Vector2 = Vector2.UP

var player_direction_map = {
	'u': Vector2.UP,
	'd': Vector2.DOWN,
	'l': Vector2.LEFT,
	'r': Vector2.RIGHT,
}

func set_current_interactable(node):
	current_interactable = node
	
func open_dialogue(config):
	Dialogue.open_dialogue(config)

func load_map(map, from=null):
	if current_map != null:
		current_map.queue_free()
	current_map = load(map).instance()
	var scene = add_child(current_map)
	
	if from:
		var default_position
		var position
		# spawn player in desired position
		for child in current_map.get_node('PlayerPositions').get_children():
			print('child!!', child.name)
			print('from!! ', from)
			if child is Position2D and child.name == 'DefaultPosition' and player:
				default_position = child
			if child is Position2D and child.name == from and player:
				position = child
		if position:
			player.position = position.position
			point_player(position.direction)
		else:
			player.position = default_position.position
			point_player(default_position.direction)
				
func point_player(direction):
	player.get_node('AnimationTree')["parameters/Idle/blend_position"] = player_direction_map[direction]

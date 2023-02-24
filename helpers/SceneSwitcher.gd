extends Node

var current_level
var player
onready var main = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	G.scene_switcher = self
	player = main.get_node('Player')
	pass # Replace with function body.


func change_level(to):
	var from
	var next_level = load(to).instance()
	add_child(next_level)
	if current_level:
		from = current_level.name
		current_level.queue_free()
	current_level = next_level
	
	yield(get_tree().create_timer(0.2), 'timeout')
	
	if from:
		var default_position
		var position
		# spawn player in desired position
		for child in current_level.get_node('PlayerPositions').get_children():
			if child is Position2D and child.name == 'DefaultPosition' and player:
				default_position = child
			if child is Position2D and child.name == from and player:
				position = child
		if position:
			player.position = position.position
			main.point_player(position.direction)
		else:
			player.position = default_position.position
			main.point_player(default_position.direction)
	emit_signal('level_changed')

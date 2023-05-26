extends Node

var current_level
var player
@onready var main = get_parent()
@export var time_override = {
	'hour': null,
	'minute': 0,
	'second': 0,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var timeDict = Time.get_time_dict_from_system();
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	var second = timeDict.second;
	var current_time_in_seconds = (hour * 3600) + (minute * 60) + second
	print('time in seconds!: ', current_time_in_seconds)
	
	if time_override.hour:
		print('time is overridden')
		print('hour: ', time_override.hour)
		print('minute: ', time_override.minute)
		print('second: ', time_override.second)
		current_time_in_seconds = (time_override.hour * 3600) + (time_override.minute * 60) + time_override.second
	
	$CanvasLayer/AnimationPlayer.play("daynight")
	$CanvasLayer/AnimationPlayer.advance(current_time_in_seconds)
	G.scene_manager = self
	player = main.get_node('Player')


func change_level(to):
	main.get_node('TransitionLayer/AnimationPlayer').play('fade_in')
	
	if to == "res://IntroLvl.tscn":
		player.disable()
		player.hide()
	elif current_level and current_level.name == 'IntroLvl' and to == "res://maps/interiors/grandmas_house_pristine/Default.tscn":
		player.enable()
		player.show()
		player.get_node('Camera2D').current = true
		
	var from
	var next_level = load(to).instantiate()
	add_child(next_level)
	if current_level:
		from = current_level.name
		current_level.queue_free()
	current_level = next_level
	
	# TODO this is a crappy temp fix. fix the bad fix.
	await get_tree().create_timer(0.001).timeout
	
	var default_position
	var position
	print('current level wtf!: ', current_level.get_children())

	# spawn player in desired position
	for child in current_level.get_node('PlayerPositions').get_children():
		if child is Marker2D and child.name == 'DefaultPosition' and player:
			default_position = child
		if child is Marker2D and child.name == from and player:
			position = child
	if position:
		player.position = position.position
		main.point_player(position.direction)
	else:
		player.position = default_position.position
		main.point_player(default_position.direction)
	
	main.get_node('TransitionLayer/AnimationPlayer').play('fade_out')
	emit_signal('level_changed')


func _on_TODTimer_timeout():
	pass
	
	


extends Node

export(PackedScene) var mob_scene
var score
var current_map
var maps_map = {
	'home': 'res://Home.tscn',
	'shelby_pristine': 'res://ShelbyPristine.tscn'
}
onready var player = get_node("Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	print('fuckkkkk')
	score = 0
	player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	#$HUD.show_message("Lets Get READY READY")
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	load_map('home')

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_Door_area_entered(area):
	print('fuck')


func _on_CollisionShape2D_child_entered_tree(node):
	print('shit???')


func _on_Door_body_entered(body):
	if body.name == 'Player':
		print(body.name)
		load_map('shelby_pristine')
		
func load_map(map_name):
	if current_map != null:
		current_map.queue_free()
	current_map = load(maps_map.get(map_name)).instance()
	var scene = add_child(current_map)
	for child in current_map.get_children():
		if child is Position2D and child.name == 'PlayerStartPosition':
			player.position = child.position
	
	#move_child(child, len(get_children()) - 1)

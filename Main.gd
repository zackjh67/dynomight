extends Node

export(PackedScene) var mob_scene

# for debugging
export(String, "Home",
 "Intro",
 "Grandmas House (Default)",
 "Grandmas House (Basement)",
 "Grandmas House (Player Room)", 
 "Explore Pristine Shelby") var level

var score
var current_map
var maps_map = {
	'Home': 'res://Home.tscn',
	'Intro': 'res://IntroLvl.tscn',
	'Grandmas House (Default)': "res://maps/interiors/grandmas_house_pristine/Default.tscn",
	'Grandmas House (Basement)': "res://maps/interiors/grandmas_house_pristine/Basement.tscn",
	'Grandmas House (Player Room)': "res://maps/interiors/grandmas_house_pristine/PlayerRoom.tscn",
	'Explore Pristine Shelby': 'res://IntroLvl.tscn',
}

onready var player = $Player
var bus


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
	score = 0
	$StartTimer.start()
	$HUD.update_score(score)
	#$HUD.show_message("Lets Get READY READY")
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	print_debug('level: ', level)
	if !level:
		level = "Intro"
	load_map(maps_map[level])

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
		
func load_map(map):
	if current_map != null:
		current_map.queue_free()
	current_map = load(map).instance()
	var scene = add_child(current_map)
	
	# spawn player in desired position
	for child in current_map.get_children():
		if child is Position2D and child.name == 'PlayerStartPosition' and player:
			player.position = child.position
			pass

# pause player movement and interacting when global dialogue is open
func _on_Dialogue_dialogue_started():
	player.allow_tile_interaction = false
	player.allow_interaction = false
	player.can_move = false


func _on_Dialogue_dialogue_finished():
	player.allow_tile_interaction = true
	player.allow_interaction = true
	player.can_move = true

extends Node

export(PackedScene) var mob_scene

# for debugging
export(String, "Home",
 "Intro",
 "Grandmas House Pristine (Default)",
 "Grandmas House Pristine (Basement)",
 "Grandmas House Pristine (Player Room)", 
 "Explore Pristine Shelby") var level

var maps_map = {
	'Home': 'res://Home.tscn',
	'Intro': 'res://IntroLvl.tscn',
	'Grandmas House Pristine (Default)': "res://maps/interiors/grandmas_house_pristine/Default.tscn",
	'Grandmas House Pristine (Basement)': "res://maps/interiors/grandmas_house_pristine/Basement.tscn",
	'Grandmas House Pristine (Player Room)': "res://maps/interiors/grandmas_house_pristine/PlayerRoom.tscn",
	'Explore Pristine Shelby': 'res://IntroLvl.tscn',
}

var player_direction_map = {
	'u': Vector2.UP,
	'd': Vector2.DOWN,
	'l': Vector2.LEFT,
	'r': Vector2.RIGHT,
}

onready var player = $Player
onready var scene_switcher = $SceneSwitcher
var bus

# Called when the node enters the scene tree for the first time.
func _ready():
	G.connect('global_dialogue_started', self, '_on_Dialogue_dialogue_started')
	G.connect('global_dialogue_finished', self, '_on_Dialogue_dialogue_finished')
	randomize()
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	#$HUD.show_message("Lets Get READY READY")
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	print_debug('level: ', level)
	if !level:
		level = "Intro"
	scene_switcher.change_level(maps_map[level])

# pause player movement and interacting when global dialogue is open
func _on_Dialogue_dialogue_started():
	player.disable()


func _on_Dialogue_dialogue_finished():
	player.enable()
	
func point_player(direction):
	player.get_node('AnimationTree')["parameters/Idle/blend_position"] = player_direction_map[direction]

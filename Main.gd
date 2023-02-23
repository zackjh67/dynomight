extends Node

export(PackedScene) var mob_scene

# for debugging
export(String, "Home",
 "Intro",
 "Grandmas House (Default)",
 "Grandmas House (Basement)",
 "Grandmas House (Player Room)", 
 "Explore Pristine Shelby") var level

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
#	var resource = preload('res://dialogue.tres')
#	DialogueManager.show_global_dialogue_balloon(\
#	"this_is_a_node_title", \
#	resource
#	)
	if player:
		G.player = player
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
	G.load_map(maps_map[level])

# pause player movement and interacting when global dialogue is open
func _on_Dialogue_dialogue_started():
	player.allow_tile_interaction = false
	player.allow_interaction = false
	player.can_move = false


func _on_Dialogue_dialogue_finished():
	player.allow_tile_interaction = true
	player.allow_interaction = true
	player.can_move = true

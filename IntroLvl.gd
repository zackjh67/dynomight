extends YSort

onready var npcs = [$NPCNews1, $NPCNews2]

var proximity_messages = { 
	'NPCNews1': ['Did you hear what they are saying on the news?'],
	'NPCNews2': ["About the tremors? They're just trying to scare us."]
}

var characters = ['jennay', 'chad', 'mickey', 'player']
var default_speed = 45

var char_name_node_name = {
	'jennay': 'Jennay',
	'chad': 'Chad',
	'player': 'Player',
	'mickey': 'Mickey',
}

onready var path_follows = {
	'jennay': $JennayPath/PathFollow2D,
	'chad': $ChadPath/PathFollow2D,
	'mickey': $MickeyPath/PathFollow2D,
	'player': $PlayerPath/PathFollow2D,
}

onready var anim_trees = {
	'jennay': $Jennay/AnimationTree,
	'chad': $Chad/AnimationTree,
	'mickey': $Mickey/AnimationTree,
	'player': $Player/AnimationTree,
}

onready var char_stops = {
	'jennay': $JennayPath/Stops.get_children(),
	'chad': $ChadPath/Stops.get_children(),
	'mickey': $MickeyPath/Stops.get_children(),
	'player': $PlayerPath/Stops.get_children(),
}

var path_speeds = {
	'jennay': default_speed,
	'chad': default_speed,
	'mickey': default_speed,
	'player': default_speed,
}

var old_positions = {
	'jennay': Vector2.ZERO,
	'chad': Vector2.ZERO,
	'mickey': Vector2.ZERO,
	'player': Vector2.ZERO,
}

var stopped = {
	'jennay': false,
	'chad': false,
	'mickey': false,
	'player': false,
}

onready var dialogues = {
	'jennay': $JennayPath/PathFollow2D/Dialogue,
	'chad': $ChadPath/PathFollow2D/Dialogue,
	'mickey': $MickeyPath/PathFollow2D/Dialogue,
	'player': $PlayerPath/PathFollow2D/Dialogue,
}

var current_stop = 0
var stop_count = 0
var stops = ['Stop1', 'Stop2', 'Stop3']

func stop(body, stop, character_name):
	print('character:   ', character_name)
	# check which character this stop belongs to
	if body.name == char_name_node_name[character_name]:
		# remove stop collision boxes. we don't want to use them twice
		stop.remove_child(stop.get_children()[0])
		
		stop_character(character_name)
		
		if stop_count == len(characters):
			var stp = stops[current_stop]
			if stp == 'Stop1':
				start_game_store_interaction()
				
func point_character(character, direction):
	var direction_map = { 'left':Vector2.LEFT, 'right':Vector2.RIGHT, 'up':Vector2.UP, 'down':Vector2.DOWN}
	anim_trees[character]["parameters/Idle/blend_position"] = direction_map[direction]

# Called when the node enters the scene tree for the first time.
func _ready():
	# set up collisions programatically
	for character in characters:
		for stop in char_stops[character]:
			stop.connect('body_entered', self, 'stop', [stop, character])
			
		# connect dialogue closed signals for characters. may not need
#		dialogues[character].connect('dialogue_closed', self, 'dialogue_closed', [character])
			
	# set up npcs
	for npc in npcs:
		npc.proximity_messages = proximity_messages[npc.name]
		
	# kick off initial interaction
	yield(get_tree().create_timer(2), "timeout")
	dialogues['jennay'].set_messages(["I can't believe its Summer already!", "What are you guys doing on your vacation?"])
	yield(dialogues['jennay'], "dialogue_closed")
	# TODO richtext this shit a little bit so we can see how much chad hates horse camp
	dialogues['chad'].set_messages(["My parents are sending me to Horse Camp"])
	yield(dialogues['chad'], "dialogue_closed")
	dialogues['player'].set_messages(["Boy am I glad I'm not you.", "I'll be playing pocketmang all Summer."])

func _physics_process(delta):
	# run paths
	for character in characters:
		var char_speed = path_speeds[character]
		var path_follow = path_follows[character]
		var anim_tree = anim_trees[character]
		
		if !stopped[character]:
			path_follow.set_offset(path_follow.get_offset() + char_speed * delta)
		
			var velocity = path_follow.position - old_positions[character]
			old_positions[character] = path_follow.position
			
			if velocity == Vector2.ZERO:
				anim_tree.get('parameters/playback').travel('Idle')
			else:
				anim_tree.set('parameters/Idle/blend_position', velocity)
				anim_tree.set('parameters/Walk/blend_position', velocity)
				
func _process(delta):
	pass
	
func start_character(name, speed):
	if speed:
		path_speeds[name] = speed
	stopped[name] = false
	stop_count -= 1
		
func stop_character(name):
	stopped[name] = true
	stop_count += 1
		
# first stop at the game store
func start_game_store_interaction():
	yield(get_tree().create_timer(0.5), "timeout")
	point_character('chad', 'left')
	dialogues['chad'].set_messages(["I'll be right back. Just got to grab a pack of Pokingman cards."])
	yield(get_tree().create_timer(3), "timeout")
	start_character('chad', 75)
	
	yield(get_tree().create_timer(2), "timeout")
	point_character('player', 'right')
	dialogues['player'].set_messages(['I hope he gets a Chumbawumba'])
	point_character('mickey', 'left')
	yield(dialogues['player'], "dialogue_closed")
	dialogues['mickey'].set_messages(['No way ballisore is the best!'])
	yield(dialogues['mickey'], "message_finished")
	$ChadPath/Stops/Stop3/CollisionShape2D.disabled = false
	start_character('chad', 75)
	yield(char_stops['chad'][2], 'body_entered')
	dialogues['chad'].set_messages(['Aw man!', "I got 3 Rattards and a Monkaymone"])
	yield(dialogues['chad'], 'message_finished')
	yield(dialogues['chad'], 'message_finished')
	dialogues['jennay'].set_messages(['lol!', "LMAO"])
	yield(dialogues['jennay'], 'dialogue_closed')
	dialogues['player'].set_messages(["Come on I gotta get home before my grandma gets pissed"])
	yield(dialogues['player'], 'dialogue_closed')
	
	start_character('chad', default_speed)
	start_character('player', default_speed)
	start_character('jennay', default_speed)
	start_character('mickey', default_speed)


func _on_GamestoreCheckpoint_body_entered(body):
	if body.name == 'Player':
		dialogues['chad'].set_messages(["Oh!", "Let's stop at the game store real quick."])

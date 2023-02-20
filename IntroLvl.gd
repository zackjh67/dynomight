extends YSort

onready var npcs = [$NPCNews1, $NPCNews2]

var proximity_messages = { 
	'NPCNews1': ['Did you hear what they are saying on the news?'],
	'NPCNews2': ["About the tremors? They're just trying to scare us."]
}

var characters = ['jennay', 'chad', 'mickey', 'player']
var default_speed = 45*G.FAST_FORWARD

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
var stops = ['Stop1', 'Stop2', 'Stop3', 'Stop4']

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
				current_stop = 1
			elif stp == 'Stop2':
				start_library_interaction()
				current_stop = 2
			elif stp == 'Stop3':
				start_dirt_pit_interaction()
				current_stop = 3
			elif stp == 'Stop4':
				start_farewell_interaction()
				current_stop = 4
				
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
	yield(get_tree().create_timer(2/G.FAST_FORWARD), "timeout")
	dialogues['jennay'].set_messages(["I can't believe its Summer already!", "What are you guys doing on your vacation?"])
	yield(dialogues['jennay'], "dialogue_closed")
	# TODO richtext this shit a little bit so we can see how much chad hates horse camp
	dialogues['chad'].set_messages(["My parents are sending me to Horse Camp"])
	yield(dialogues['chad'], "dialogue_closed")
	dialogues['player'].set_messages(["Boy am I glad I'm not you.", "I'll be playing pocketmang all Summer"])

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
		
func stop_character(name):
	stopped[name] = true
	stop_count += 1
		
# first stop at the game store
func start_game_store_interaction():
	point_character('player', 'up')
	point_character('jennay', 'up')
	point_character('chad', 'up')
	point_character('mickey', 'up')
	yield(get_tree().create_timer(0.5/G.FAST_FORWARD), "timeout")
	point_character('chad', 'left')
	dialogues['chad'].set_messages(["I'll be right back. Just got to grab a pack of pocketmang cards"])
	yield(dialogues['chad'], 'dialogue_closed')
	start_character('chad', 75*G.FAST_FORWARD)
	
	yield(get_tree().create_timer(2/G.FAST_FORWARD), "timeout")
	point_character('player', 'right')
	dialogues['player'].set_messages(['I hope he gets a Chumbawumba'])
	point_character('mickey', 'left')
	yield(dialogues['player'], "dialogue_closed")
	dialogues['mickey'].set_messages(['No way ballisore is the best!'])
	yield(dialogues['mickey'], "message_finished")
	$ChadPath/Stops/Stop3/CollisionShape2D.disabled = false
	start_character('chad', 75*G.FAST_FORWARD)
	yield(char_stops['chad'][2], 'body_entered')
	point_character('player', 'up')
	point_character('jennay', 'up')
	point_character('mickey', 'up')
	point_character('chad', 'down')
	dialogues['chad'].set_messages(['Aw man!', "I got 3 Rattards and a Monkaymone"])
	yield(dialogues['chad'], 'message_finished')
	yield(dialogues['chad'], 'message_finished')
	dialogues['jennay'].set_messages(["HA HA HA!", "You have the worst luck Chad"])
	yield(dialogues['jennay'], 'dialogue_closed')
	dialogues['player'].set_messages(["Come on I gotta get home before my grandma flips out"])
	yield(dialogues['player'], 'dialogue_closed')
	
	start_character('chad', default_speed)
	start_character('player', default_speed)
	start_character('jennay', default_speed)
	start_character('mickey', default_speed)
	stop_count = 1
	
func start_library_interaction():
	point_character('player', 'up')
	point_character('chad', 'up')
	point_character('jennay', 'up')
	yield(get_tree().create_timer(2/G.FAST_FORWARD), "timeout")
	dialogues['jennay'].set_messages(["Be out in a sec"])
	start_character('jennay', 75*G.FAST_FORWARD)
	yield(get_tree().create_timer(4/G.FAST_FORWARD), "timeout")
	point_character('player', 'left')
	point_character('chad', 'right')
	dialogues['player'].set_messages(["Do you guys think horses remember things from when they were little?"])
	yield(dialogues['player'], 'dialogue_closed')
	$JennayPath/Stops/Stop4/CollisionShape2D.disabled = false
	yield(get_tree().create_timer(2/G.FAST_FORWARD), "timeout")
	start_character('jennay', 75*G.FAST_FORWARD)
	yield(char_stops['jennay'][3], 'body_entered')
	point_character('jennay', 'down')
	point_character('player', 'up')
	point_character('chad', 'up')
	dialogues['jennay'].set_messages(["That one was so scary!", "Will you guys walk me home?"])
	yield(dialogues['jennay'], 'dialogue_closed')
	dialogues['chad'].set_messages(["Yeah we'll walk you home you big wuss"])
	yield(dialogues['chad'], 'dialogue_closed')
	start_character('chad', default_speed)
	start_character('player', default_speed)
	start_character('jennay', default_speed)
	stop_count = 1
	
func start_dirt_pit_interaction():
	point_character('player', 'left')
	point_character('chad', 'left')
	point_character('jennay', 'left')
	dialogues['jennay'].set_messages(["When are they gonna do something about this dirt pit?", "I'm tired of living next to it!", "It's so ugly!"])
	yield(dialogues['jennay'], 'dialogue_closed')
	dialogues['chad'].set_messages(["Yeah, right", "You're just scared because of the rumors of monsters living there at night"])
	yield(dialogues['chad'], 'message_finished')
	dialogues['jennay'].set_messages(["Am not!"])
	yield(dialogues['jennay'], 'message_finished')
	dialogues['player'].set_messages(["Come on, stop guys", "I gotta get home my food is getting cold"])
	start_character('chad', default_speed)
	start_character('player', default_speed)
	start_character('jennay', default_speed)
	stop_count = 2
	
func start_farewell_interaction():
	point_character('player', 'left')
	point_character('chad', 'right')
	dialogues['player'].set_messages(["Well, have fun at horse camp"])
	yield(dialogues['player'], 'dialogue_closed')
	dialogues['chad'].set_messages(["Yeah...", "Thanks"])
	yield(dialogues['chad'], 'dialogue_closed')
	dialogues['player'].set_messages(["We'll still hang out man don't worry!"])
	yield(dialogues['player'], 'message_finished')
	dialogues['chad'].set_messages(["We better. I'm going to be so tired of horses", "I'll see you when I'm back!"])
	yield(dialogues['chad'], 'message_finished')
	dialogues['player'].set_messages(["See ya bud!"])
	yield(dialogues['player'], 'dialogue_closed')
	yield(get_tree().create_timer(1/G.FAST_FORWARD), "timeout")
	
	start_character('chad', default_speed)
	start_character('player', default_speed)
		
func _on_GamestoreCheckpoint_body_entered(body):
	if body.name == 'Player':
		dialogues['chad'].set_messages(["Oh!", "Let's stop at the game store real quick."])


func _on_LibraryCheckpoint_body_entered(body):
	if body.name == 'Player':
		dialogues['jennay'].set_messages(["Be right back I gotta return my Scare Lumps book."])
		yield(dialogues['jennay'], "message_finished")
		dialogues['mickey'].set_messages(["I gotta get home. See you guys later!"])
		yield(dialogues['mickey'], "message_finished")
		dialogues['player'].set_messages(["See ya!"])
		dialogues['chad'].set_messages(["Later bro"])
		dialogues['jennay'].set_messages(["Bye Mickey!"])
		$LibraryCheckpoint.remove_child($LibraryCheckpoint/CollisionShape2D)

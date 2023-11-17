extends CharacterBody2D
signal hit


# Declare member variables here. Examples:
@export var speed = 200 #how fast the player will move (pixels/sec)
var screen_size # size of the game window
var approached_tile
@export var allow_tile_interaction = true
@export var allow_interaction = true
@export var can_move = true

var obj_messages = Constants.interactable_object_messages
@onready var dialogue = G.Dialogue
@onready var anim_state_machine = $AnimationTree["parameters/playback"]


# Called when the node enters the scene tree for the first time.
func _ready():
	print('wtf')
	screen_size = get_viewport_rect().size
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
var last_rotation = 0
func _physics_process(delta):
	# the player can't do anything if dialogue is open
	if can_move:
		velocity = Vector2.ZERO
		var direction = Vector2()
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			direction = Vector2.RIGHT
		elif Input.is_action_pressed("move_left"):
			velocity.x -= 1
			direction = Vector2.LEFT
		elif Input.is_action_pressed("move_down"):
			velocity.y += 1
			direction = Vector2.DOWN
		elif Input.is_action_pressed("move_up"):
			velocity.y -= 1
			direction = Vector2.UP
			
		if direction != Vector2.ZERO:
			G.player_direction = direction
			
		# normalize play the coordinates and velocity look this up later you dont fully understand this lol
		if velocity.length() > 0:
			# clear tile in front of us
			approached_tile = null
			
			# get velocity
			velocity = velocity.normalized()
			
			#animations
			if velocity == Vector2.ZERO:
				$AnimationTree.get('parameters/playback').travel('Idle')
			else:
				$AnimationTree.set('parameters/Idle/blend_position', velocity)
				$AnimationTree.set('parameters/Walk/blend_position', velocity)
			
			#move the player
			set_velocity(velocity * speed)
			move_and_slide()
			velocity = velocity
			
			# set interactable tile name if colliding into one
			# TODO tile collision fuck
#			for i in get_slide_collision_count():
#				var collision = get_slide_collision(i)
#				if collision.collider.name == "TopLayer":
#					var pos = collision.collider.local_to_map(collision.position)
#					var id = collision.collider.get_cellv(pos - collision.normal)
#					approached_tile = collision.collider.tile_set.tile_get_name(id)


		
func _process(delta):
	pass

func _input(ev):
	if ev.is_action_pressed("interact"):
		if allow_interaction and G.current_interactable and G.current_interactable.has_method('interact'):
			print_debug('interacting fuck')
			# TODO this finally fucking works but the developer is a fuckin chode
			# need to figure out new dialogue files and figure out example dialogue fuckin baloon
			var resource = DialogueManager.create_resource_from_text("~ title\nCharacter: INTERESTTTTTACTIC!")
			var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "title")
			await DialogueManager.show_example_dialogue_balloon(resource, 'title')
			G.current_interactable.interact()
		# interaction for TILES ONLY
		if allow_tile_interaction and approached_tile:
			if obj_messages.has(approached_tile):
				if !dialogue.visible:
					dialogue.show()
					for child in dialogue.get_children():
						if child is Label:
							child.set_text(obj_messages[approached_tile])
							can_move = false
				else:
					dialogue.hide()
					can_move = true
	
func start(pos):
	position = pos
	show()
	#$CollisionShape2D.disabled = false
	
func enable():
	allow_tile_interaction = true
	allow_interaction = true
	can_move = true
	
func disable():
	allow_tile_interaction = false
	allow_interaction = false
	can_move = false

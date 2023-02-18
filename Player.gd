extends KinematicBody2D
signal hit


# Declare member variables here. Examples:
export var speed = 200 #how fast the player will move (pixels/sec)
var screen_size # size of the game window
var approached_tile
var allow_tile_interaction = true
var can_move = true
var velocity

var obj_messages = Constants.interactable_object_messages
onready var dialogue = Constants.Dialogue
onready var anim_state_machine = $AnimationTree["parameters/playback"]


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
			velocity = move_and_slide(velocity * speed)
			
			# set interactable tile name if colliding into one
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.name == "TopLayer":
					var pos = collision.collider.world_to_map(collision.position)
					var id = collision.collider.get_cellv(pos - collision.normal)
					approached_tile = collision.collider.tile_set.tile_get_name(id)


		
func _process(delta):
	pass

func _input(ev):
	if ev.is_action_pressed("interact"):
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

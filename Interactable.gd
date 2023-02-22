extends Area2D

export(String, 'left', 'right', 'up', 'down', 'none') var direction = 'none'

var direction_map = {
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'up': Vector2.UP,
	'down': Vector2.DOWN,
}

var interacting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Interactable_body_entered(body):
	if direction != 'none':
		if G.player_direction == direction_map[direction]:
			G.set_current_interactable(self);
	else:
		G.set_current_interactable(self);


func _on_Interactable_body_exited(body):
	G.set_current_interactable(null)
	
# CREATE FUNCTION FOR INTERACTING WITH OBJECT
#func interact():
#	if !interacting:
#		print('im being interacted with ', self)
#		interacting = true

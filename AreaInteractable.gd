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
	if body.name == 'Player':
		G.set_current_interactable(self);


func _on_Interactable_body_exited(body):
	if body.name == 'Player':
		G.set_current_interactable(null)
	
# CREATE FUNCTION FOR INTERACTING WITH OBJECT
func interact():
	if !interacting:
		if !direction or direction == 'none' or G.player_direction == direction_map[direction]:
			$Actions.get_children()[0].interact()
			interacting = true
			yield($Actions.get_children()[0], 'action_finished')
			interacting = false

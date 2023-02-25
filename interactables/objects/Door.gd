extends Node2D

export var locked:bool = true
export var can_open:bool = false
export var locked_message:String = "It's locked"
export(String, FILE, "*.tscn") var to
export var to_text:String = 'inside'

func door_entered(body):
	if body.name == 'Player':
		G.scene_manager.change_level(to)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !locked:
		$AreaInteractable.connect('body_entered', self, 'door_entered')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

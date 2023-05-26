extends Node2D


@export onready var radius:float = $Area2D/CollisionShape2D.shape.radius
@export var proximity_messages = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		$DialogueNPC.set_messages(proximity_messages)

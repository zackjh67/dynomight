extends Node


# Declare member variables here. Examples:
var interactable_object_messages = {
	'my_bed': "I'm not tired right now."
}

export var DEFAULT_DIALOGUE_SPEED = 0.03

onready var Dialogue = get_node("/root/Main/Dialogue")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

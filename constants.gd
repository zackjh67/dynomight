extends Node

# Declare member variables here. Examples:
var interactable_object_messages = {
	'my_bed': "I'm not tired right now.",
	'nightstand': {
		'text': "It's a fucking nightstand",
	}
}

var portals = {
	'grandmas_house': {
		'outside': {
			'locked_message': "You just got here. Hang out for a little while",
			'from': 'Grandmas',
		}
	}
}

export var DEFAULT_DIALOGUE_SPEED = 0.03
export var GLOBAL_DIALOGUE_TIMEOUT = 2 #seconds


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

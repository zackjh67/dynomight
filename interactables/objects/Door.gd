extends Node2D

export var locked:bool = true
export var locked_message:String = "It's locked"
export(String, FILE, "*.tscn") var to
export var to_text:String = 'inside'

# Called when the node enters the scene tree for the first time.
func _ready():
	if locked:
		pass #$AreaInteractable/Actions/DialogueAction/DialogueConfig.text = locked_reason
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

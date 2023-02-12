extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Door_body_entered(body):
	print('body!: ', body.name)
	if body.name == 'Player':
		print('player entered')
		var node = get_tree().get_root().get_node("Main").load_map('shelby_pristine')
		print('node!: ', node)
	pass # Replace with function body.

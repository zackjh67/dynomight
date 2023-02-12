extends ParallaxLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var offset_y = 0
func _physics_process(delta):
	set_motion_offset(Vector2(0, offset_y))
	offset_y -= 2.2

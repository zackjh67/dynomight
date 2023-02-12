extends CanvasLayer

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	#wait until the messagetimer has counted down
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	#make a one-shot timer and wait for it to finish... this is basically await sleep(1)
	yield(get_tree().create_timer(1), "timeout") #first param is a newly created timer, second is the signal you are waiting for
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

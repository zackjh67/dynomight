extends Node2D

signal dialogue_closed
signal message_finished

export var messages = []

export var keep_message = false

export var typing_speed = Constants.DEFAULT_DIALOGUE_SPEED/G.FAST_FORWARD
export var read_time = 2/G.FAST_FORWARD

var current_message = 0
var display = ""
var current_char = 0
export var done_processing_messages = false

func _ready():
	
	# label has test text in it and is shown just for ease of editing
	# clear that before we actually use it
	$Label.hide()
	$Label.text = ''
	
func start_dialogue():
	$Label.show()
	current_message = 0
	display = ""
	current_char = 0
	$NextChar.set_wait_time(typing_speed)
	$NextChar.start()
	done_processing_messages = true

func stop_dialogue():
	# get_parent().remove_child(self)
	#queue_free()
	$Label.text = ''
	$Label.hide()
	emit_signal('dialogue_closed')

func _on_NextChar_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$Label.text = display
		current_char += 1
	else:
		$NextChar.stop()
		$NextMessage.one_shot = true
		$NextMessage.set_wait_time(read_time)
		if keep_message == false:
			$NextMessage.start()

func _on_NextMessage_timeout():
	emit_signal('message_finished')
	if (current_message == len(messages) - 1):
		stop_dialogue()
	else: 
		current_message += 1
		display = ""
		current_char = 0
		$NextChar.start()

func set_messages(msgs):
	messages = msgs
	done_processing_messages = false
	start_dialogue()

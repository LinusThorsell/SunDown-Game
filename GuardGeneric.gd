extends Area2D

export var default_direction = "standing_down"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal signal_other_guard

var player_node

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play(default_direction)
	player_node = get_parent().get_parent().get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GuardsAtIntro_area_entered(area):
	$AnimatedSprite.play("standing_up")
	$SpeechBubble.set_text("STOP! Who are you?!", 5)
	yield(get_tree().create_timer(5.5),"timeout")
	var selection = yield(player_node.ask_player("STOP! Who are you?!", ["Not a skelly!", "I'm not so sure actually...", "My names guard", "Uhm..."]), "completed")
	print(selection)
	emit_signal("signal_other_guard")
	yield(get_tree().create_timer(11),"timeout")
	$SpeechBubble.set_text("Exactly...", 5)


func _on_GuardGenericLeftGate_signal_other_guard():
	$AnimatedSprite.play("standing_up")
	$SpeechBubble.set_text("Why should we let you in here...", 5)
	yield(get_tree().create_timer(5.0),"timeout")
	$SpeechBubble.set_text("what if you are a skelly in disguise?", 5)
	#pass # Replace with function body.

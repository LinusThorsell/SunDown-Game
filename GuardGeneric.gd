extends Area2D

export var default_direction = "standing_down"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal signal_other_guard

var player_node
var return_after_move = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play(default_direction)
	player_node = get_parent().get_parent().get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GuardsAtIntro_area_entered(area):
	if (area.name == "PlayerCollision"):
		area.get_parent().locked_in_place = true;
		$AnimatedSprite.play("standing_up")
		$SpeechBubble.set_text("STOP! Who are you?!", 5)
		yield(get_tree().create_timer(5.5),"timeout")
		var selection = yield(player_node.ask_player("STOP! Who are you?!", ["Not a skelly!", "I'm not so sure actually...", "My names guard", "Uhm..."]), "completed")
		emit_signal("signal_other_guard")
		yield(get_tree().create_timer(11),"timeout")
		$SpeechBubble.set_text("Exactly...", 5)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Oh my! Come here Player", 1)
		
		return_after_move = 1;
		$NPCMoveEngine.move_node_along_path($".", $City_CollectPlayer1/Follow, 150)

func _on_GuardGenericLeftGate_signal_other_guard():
	$AnimatedSprite.play("standing_up")
	$SpeechBubble.set_text("Sounds like exactly what a skelly would say...", 5)
	yield(get_tree().create_timer(5.0),"timeout")
	$SpeechBubble.set_text("You are deffo a skelly arent you...", 5)
	yield(get_tree().create_timer(5.0),"timeout")
	
	yield(get_tree().create_timer(3),"timeout")
	$SpeechBubble.set_text("HEY WATCH OUT!!!", 2)
	
	$NPCMoveEngine.move_node_along_path($".", $City_ProtectPlayer/Follow, 150);
	#pass # Replace with function body.


func _on_NPCMoveEngine_finished_moving():
	if (return_after_move == 1):
		return_after_move = 2;
		$NPCMoveEngine.move_node_along_path($".", $City_CollectPlayer2/Follow, 100)
	elif (return_after_move == 2):
		return_after_move = 3;
		$NPCMoveEngine.move_node_along_path($".", $City_CollectPlayer3/Follow, 150)
		
	#pass # Replace with function body.

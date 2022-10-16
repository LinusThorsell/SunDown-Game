extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal cutscene_spacefly

var triggerstate = 0
var player

var next_position
var force_update_position = false

var answer = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("standing_right")
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (force_update_position):
		position = next_position
		force_update_position = false
#	position = Vector2(position.x, position.y)
#	pass


func _on_ScientistsDoor_trigger_scientist():
	if (triggerstate == 0):
		print("triggering first interaction with scientist")
		triggerstate = 1
		$NPCMoveEngine.move_node_along_path($".", $Paths/GreetPlayer/Follow, 150)
#	pass # Replace with function body.


func _on_NPCMoveEngine_finished_moving():
	if (triggerstate == 1):
#		$SpeechBubble.set_text("Who are you?!?! Lizard folk?!", 3)
#		yield(get_tree().create_timer(3),"timeout")
#		$SpeechBubble.set_text("or Alien or whatever?!= what are you?", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		answer = yield(player.ask_player("or Alien or whatever?!= what are you?", ["Not sure, maybe alien?", "Crashed in my spaceship I think", "I litterary have no idea."]), "completed")
#		print(answer)
#		if (answer == 0): # "Not sure, maybe alien?"
#			$SpeechBubble.set_text("What do you mean you are not sure?", 3)
#			yield(get_tree().create_timer(3),"timeout")
#			answer = yield(player.ask_player("What do you mean you are not sure?", ["My memory is dizzy, I think I came here in a spaceship..."]), "completed")
#			print(answer)
#		elif(answer == 1): # "Crashed in my spaceship I think"
#			print("skipping...")
#		elif(answer == 2): # "I litterary have no idea."
#	#		print("TODO")
#			$SpeechBubble.set_text("Do you remember anything? How did you get here?", 3)
#			yield(get_tree().create_timer(3),"timeout")
#			answer = yield(player.ask_player("Do you remember anything? How did you get here?", ["My memory is dizzy, I think I came here in a spaceship..."]), "completed")
#
#		$SpeechBubble.set_text("A spaceship you say... Do you know why you were on said spaceship?", 5)
#		yield(get_tree().create_timer(5),"timeout")
#		answer = yield(player.ask_player("A spaceship you say... Do you know why you were on said spaceship?", ["I feel like im fainting..."]), "completed")

		triggerstate = 2
		emit_signal("cutscene_spacefly")
		
		player.position = Vector2(2815, 2935)
		position = Vector2(2843, 2960)
		
	elif(triggerstate == 2):
		player.position = Vector2(2815, 2935)
		position = Vector2(2843, 2960)
		$AnimatedSprite.play("standing_left")
#
#		print("bed scene")
#		$SpeechBubble.set_text("You very much fainted right there..", 4)
#		yield(get_tree().create_timer(4),"timeout")
#		$SpeechBubble.set_text(".. are you alright?", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		answer = yield(player.ask_player(".. are you alright?", ["I feel like I slept for a week", "I remembered that I was flying a spaceship, not much more than that unfortunately"]), "completed")
#		if (answer == 0):
#			$SpeechBubble.set_text("Sounds about right ..", 3)
#			yield(get_tree().create_timer(3),"timeout")
#			$SpeechBubble.set_text(".. you were only out for about 5 days though.", 3)
#			yield(get_tree().create_timer(3),"timeout")
#		if (answer == 1):
#			$SpeechBubble.set_text("Great! Your memory is coming back slowly but surely.", 5)
#			yield(get_tree().create_timer(4),"timeout")
#
#		$SpeechBubble.set_text("Fortunatelly, I managed to find some stuff out while you were out..", 4)
#		yield(get_tree().create_timer(4),"timeout")
#		$SpeechBubble.set_text(".. so it turns out that you were on a mission to refuel our sun right?", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		answer = yield(player.ask_player("... you were on a mission to refuel our sun right?", ["Uhm... If you say so..."]), "completed")
#
#		$SpeechBubble.set_text(".. it isnt coming back to you huh? ..", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		$SpeechBubble.set_text(".. well I found this note in your pocket.", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").show()
#
#		yield(player.ask_player("Note", ["< -- Press"]), "completed")
#
#		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").hide()
#
#		$SpeechBubble.set_text("... So, want to save our planet together, Mr alien?", 3)
#		yield(get_tree().create_timer(3),"timeout")
#
#		yield(player.ask_player("So, want to save our planet together, Mr alien?", ["Lets do it!"]), "completed")

		$SpeechBubble.set_text("Alright! Thats the spirit, follow me to my lab!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		triggerstate = 3
		$NPCMoveEngine.move_node_along_path($".", $Paths/GoToLaboratory/Follow, 100)
	
	elif(triggerstate == 3):
		print("teleporting")
		position = Vector2(3200, 4079)
		next_position = Vector2(3200, 4079)
		force_update_position = true
		
		triggerstate = 4
		
	elif(triggerstate == 4):
		print("triggered scientist basement")
		triggerstate = 5
		$SpeechBubble.set_text("Come here. I need to show you something", 4)
		$NPCMoveEngine.move_node_along_path($".", $Paths/Basement/Follow, 100)
		
	elif(triggerstate == 5):
		print("static mode on")
		$SpeechBubble.set_text("This is my laboratiory!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("I'm guessing this will be our basecamp for a while..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. so you better get comfortable quickly!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		$SpeechBubble.set_text("Ready to get started saving this planet?", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		answer = yield(player.ask_player("Ready to get started saving this planet?", ["Yes! How do we get started?"]), "completed")
		
		$SpeechBubble.set_text("Alright! First on the list is to find my keys for the teleporter ...", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("You will know that I am very bad at keeping my stuff in order in some time..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. this time I am sure the key is somewhere in my house though. So good luck!", 4)
		yield(get_tree().create_timer(3),"timeout")






func _on_CutsceneSpaceship_finished():
	_on_NPCMoveEngine_finished_moving() # very illegal ikik
	
#	pass # Replace with function body.


func _on_ScientistBasement_trigger_scientist_basement():
	if (triggerstate == 4):
		_on_NPCMoveEngine_finished_moving()
#	pass # Replace with function body.

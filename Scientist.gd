extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal cutscene_spacefly
signal spaceship_end

var triggerstate = 0
var player

var RunwayArea

var next_position
var force_update_position = false

var CurrentObjective
var CurrentObjectiveBG
var CurrentObjectiveFinished = -1

var teleporter_coordinates = Vector2(3560, -2115)

var answer = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("standing_right")
	player = get_tree().get_root().get_node("./Main/Player")
	CurrentObjective = get_tree().get_root().get_node("./Main/HUD/Foreground/CurrentObjective")
	CurrentObjectiveBG = get_tree().get_root().get_node("./Main/HUD/Background/CurrentObjectiveBG")
	RunwayArea = get_tree().get_root().get_node("./Main/Level/TriggerAreas/SkeletonsOnRunway")
	
#	_on_NPCMoveEngine_finished_moving() # debug
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
	
	player.health = 100
	
	if (triggerstate == 1):
		$SpeechBubble.set_text("Who are you?!?! Lizard folk?!", 3)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("or Alien or whatever?!= what are you?", 3)
		yield(get_tree().create_timer(3),"timeout")

		answer = yield(player.ask_player("or Alien or whatever?!= what are you?", ["Not sure, maybe alien?", "Crashed in my spaceship I think", "I litterary have no idea."]), "completed")
		print(answer)
		if (answer == 0): # "Not sure, maybe alien?"
			$SpeechBubble.set_text("What do you mean you are not sure?", 3)
			yield(get_tree().create_timer(3),"timeout")
			answer = yield(player.ask_player("What do you mean you are not sure?", ["My memory is dizzy, I think I came here in a spaceship..."]), "completed")
			print(answer)
		elif(answer == 1): # "Crashed in my spaceship I think"
			print("skipping...")
		elif(answer == 2): # "I litterary have no idea."
	#		print("TODO")
			$SpeechBubble.set_text("Do you remember anything? How did you get here?", 3)
			yield(get_tree().create_timer(3),"timeout")
			answer = yield(player.ask_player("Do you remember anything? How did you get here?", ["My memory is dizzy, I think I came here in a spaceship..."]), "completed")

		$SpeechBubble.set_text("A spaceship you say... Do you know why you were on said spaceship?", 5)
		yield(get_tree().create_timer(5),"timeout")
		answer = yield(player.ask_player("A spaceship you say... Do you know why you were on said spaceship?", ["I feel like im fainting..."]), "completed")

		triggerstate = 2
		emit_signal("cutscene_spacefly")
		
		player.position = Vector2(2815, 2935)
		position = Vector2(2843, 2960)
		
	elif(triggerstate == 2):
		player.position = Vector2(2815, 2935)
		position = Vector2(2843, 2960)
		$AnimatedSprite.play("standing_left")
#
		print("bed scene")
		$SpeechBubble.set_text("You very much fainted right there..", 4)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text(".. are you alright?", 3)
		yield(get_tree().create_timer(3),"timeout")

		answer = yield(player.ask_player(".. are you alright?", ["I feel like I slept for a week", "I remembered that I was flying a spaceship, not much more than that unfortunately"]), "completed")
		if (answer == 0):
			$SpeechBubble.set_text("Sounds about right ..", 3)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text(".. you were only out for about 5 days though.", 3)
			yield(get_tree().create_timer(3),"timeout")
		if (answer == 1):
			$SpeechBubble.set_text("Great! Your memory is coming back slowly but surely.", 5)
			yield(get_tree().create_timer(4),"timeout")

		$SpeechBubble.set_text("Fortunatelly, I managed to find some stuff out while you were out..", 4)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text(".. so it turns out that you were on a mission to refuel our sun right?", 3)
		yield(get_tree().create_timer(3),"timeout")

		answer = yield(player.ask_player("... you were on a mission to refuel our sun right?", ["Uhm... If you say so..."]), "completed")

		$SpeechBubble.set_text(".. it isnt coming back to you huh? ..", 3)
		yield(get_tree().create_timer(3),"timeout")

		$SpeechBubble.set_text(".. well I found this note in your pocket.", 3)
		yield(get_tree().create_timer(3),"timeout")

		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").show()

		yield(player.ask_player("Note", ["< -- Press"]), "completed")

		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").hide()

		$SpeechBubble.set_text("... So, want to save our planet together, Mr alien?", 3)
		yield(get_tree().create_timer(3),"timeout")

		yield(player.ask_player("So, want to save our planet together, Mr alien?", ["Lets do it!"]), "completed")

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
		$SpeechBubble.set_text("Follow me!", 4)
		$NPCMoveEngine.move_node_along_path($".", $Paths/Basement/Follow, 100)
		
	elif(triggerstate == 5):
		print("static mode on")
		$SpeechBubble.set_text("This is my laboratory!", 4)
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

		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Find Scientist keys in the house.[/color]"
		CurrentObjectiveBG.show()
		triggerstate = 6
		
	elif(triggerstate == 6):
		print("found key")
		CurrentObjectiveFinished = 0
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Deliver key to scientist.[/color]"
		triggerstate = 7
	
	elif(triggerstate == 7):
		
		CurrentObjectiveFinished = 10
		
		CurrentObjective.hide()
		CurrentObjectiveBG.hide()
		$SpeechBubble.set_text("Great job! Now, lets get started for real.", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("I am almost out of red apples for cotton candy cooking ...", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Jump into the portal over there and get me some more will you?", 4)
		yield(get_tree().create_timer(3),"timeout")

		yield(player.ask_player("Jump into the portal over there and get me some more will you?", ["Sure."]), "completed")

		$SpeechBubble.set_text("Luckily it is very easy to use, I will enter the coordinates..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. so you just have to step on the center pad and you will teleport.", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Oh! and I almost forgot. Here, have some cotton candy..", 4)
		yield(get_tree().create_timer(3),"timeout")
		player.candy_left += 5
		$SpeechBubble.set_text(".. you never know when you will run into those skellies!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Best of luck!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		triggerstate = 8
		player.respawn_location = Vector2(3560, -2115)
		
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Go into the teleporter portal to the right in the scientists basement.[/color]"
		CurrentObjectiveBG.show()
		CurrentObjective.show()
		
	elif(triggerstate == 8):
		print("back to scientist")
		
		CurrentObjectiveBG.hide()
		CurrentObjective.hide()
		
		CurrentObjectiveFinished = 1
		triggerstate = 9
		
		$SpeechBubble.set_text("Great job! this will last for a long time!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Now when we have cotton candy to last for quite a while..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("..lets continue saving the planet!", 4)
		yield(get_tree().create_timer(3),"timeout")

		$SpeechBubble.set_text("Will you show me that note again?", 4)
		yield(get_tree().create_timer(3),"timeout")

		yield(player.ask_player("Will you show me that note again?", ["Hand over note"]), "completed")

		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").show()

		$SpeechBubble.set_text("hmmmmmm . . . . . . . .", 6)
		yield(get_tree().create_timer(8),"timeout")

		get_tree().get_root().get_node("./Main/HUD/Notes/NoteMission").hide()

		$SpeechBubble.set_text("Alright, so do you think your spaceship should be repairable?", 5)
		yield(get_tree().create_timer(4),"timeout")
		answer = yield(player.ask_player("Alright, so do you think your spaceship should be repairable?", ["I cannot remember", "Maybe, but it will take some work", "Sure"]), "completed")

		if (answer == 0): # I cannot remember
			$SpeechBubble.set_text("Oh yeah, I forgot that you must have been..", 4)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text(".. in quite a bit of shock after the landing...", 4)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text("Luckily, I am a pretty good space mechanic too ..", 4)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text(".. so we will likely be able to repair it!", 4)
			yield(get_tree().create_timer(3),"timeout")
		elif(answer == 1): # Maybe, but it will take some work
			$SpeechBubble.set_text("Luckily I used to work as a space mechanic ..", 4)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text(".. so we will likely be able to repair it!", 4)
			yield(get_tree().create_timer(3),"timeout")
		else:
			$SpeechBubble.set_text("Alright, then we will likely be able to repair it!", 4)
			yield(get_tree().create_timer(3),"timeout")

		$SpeechBubble.set_text("I will go and have a look at the spaceship then.", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("While I am away, will you look if you can find the hydrogen..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. cannisters that you ditched before you went for the emergency landing?", 4)
		yield(get_tree().create_timer(3),"timeout")

		answer = yield(player.ask_player(".. cannisters that you ditched before you went for the emergency landing?", ["Sure", "Sure, but where?"]), "completed")
		
		$SpeechBubble.set_text("I think they must have landed east of here...", 4)
		yield(get_tree().create_timer(3),"timeout")
		teleporter_coordinates = Vector2(7230, -1845)
		player.respawn_location = Vector2(7230, -1845)
		$SpeechBubble.set_text("I'm setting some coordinates to the east woods.", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Good luck!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Enter the scientists teleporter.[/color]"
		CurrentObjectiveBG.show()
		CurrentObjective.show()
		
	elif(triggerstate == 9):
		triggerstate = 10
		CurrentObjectiveFinished = 2
		print("got hydrogen cannister")
		$SpeechBubble.set_text("Great job Player! It looks kind of damaged but it will do!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("I managed to find your ship and fix it enough for it to fly", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("I got it transported to the airstrip in the soutern flats ..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. will you go and fill the hydrogen fuel storage with ..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. the canister you collected?", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		answer = yield(player.ask_player("will you go and fill the hydrogen fuel storage with the canister you collected?", ["Sure"]), "completed")
		
		teleporter_coordinates = Vector2(7000, -55)
		player.respawn_location = Vector2(7000, -55)
		$SpeechBubble.set_text("I'm setting the coordinates to the soutern flats now...", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Also, have some candy in case there are any skellies left.", 4)
		yield(get_tree().create_timer(3),"timeout")
		player.candy_left += 15
		player.has_candy = true
		
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Enter the scientists teleporter.[/color]"
		CurrentObjectiveBG.show()
		CurrentObjective.show()
	
	elif(triggerstate == 10):
		triggerstate = 11
		
		$SpeechBubble.set_text("Hey Player!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Seems like there are a lot of skellies blocking the runway", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Can you lure them out of the way?", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		answer = yield(player.ask_player("Can you lure them out of the way?", ["Sure"]), "completed")
		player.locked_in_place = false
			
		$SpeechBubble.set_text("Great! Come back to me if you need more candy!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Lure the skeletons off the runway. (" + str(RunwayArea.skelliesonrunway.size()) + " left)[/color]"
		CurrentObjectiveBG.show()
		CurrentObjective.show()
	
	elif(triggerstate == 11):
		print("Ready to flyyyyy")
		
		triggerstate = 12
		
		CurrentObjectiveBG.hide()
		CurrentObjective.hide()
		player.has_candy = false
		
		$SpeechBubble.set_text("Great job! Ready to fly again?", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		answer = yield(player.ask_player("Ready to fly again?", ["Of course!", "No thank you."]), "completed")
		if (answer == 1):
			$SpeechBubble.set_text("Well I cannot fly so you have no choice!", 4)
			yield(get_tree().create_timer(3),"timeout")
		
		$SpeechBubble.set_text("Hop into the spaceship when you are ready!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
	elif(triggerstate == 12):
		triggerstate = 13
		print("fly animation play")
		var animationplayer = get_tree().get_root().get_node("./Main/HUD/ColorRect/AnimationPlayer")
		var ship = get_tree().get_root().get_node("./Main/Level/Misc/FlyableSpaceship")
		animationplayer.play("Fade Out")
		yield(get_tree().create_timer(1),"timeout")
		
		player.locked_in_place = true
		player.hide()
		$".".hide()
		
		emit_signal("spaceship_end")
		print("emitting signal")
		animationplayer.play("Fade In")
		
		
func _on_CutsceneSpaceship_finished():
	_on_NPCMoveEngine_finished_moving() # very illegal
	
#	pass # Replace with function body.


func _on_ScientistBasement_trigger_scientist_basement():
	if (triggerstate == 4):
		_on_NPCMoveEngine_finished_moving()
#	pass # Replace with function body.

var key_triggered = false
func _on_KeyArea_area_entered(area):
	if (!key_triggered):
		get_tree().get_root().get_node("./Main/Level/Misc/KeyArea").hide()
		key_triggered = true
		_on_NPCMoveEngine_finished_moving()
#	pass # Replace with function body.


func _on_TriggerScientist_area_entered(area):
	print("triggeringscientist")
	if (CurrentObjectiveFinished == 0):
		_on_NPCMoveEngine_finished_moving()
		
	if (CurrentObjectiveFinished == 1 and triggerstate == 11 and player.candy_left <= 5):
		$SpeechBubble.set_text("Here, have some more candy!", 4)
		yield(get_tree().create_timer(3),"timeout")
		player.candy_left += 15
#	pass # Replace with function body.


func _on_AppleCollectionArea_area_entered(area):
	print("tp player back")
	player.position = Vector2(3080, 4210)
#	pass # Replace with function body.


func _on_Teleporter_area_entered(area):
	if (area.name == "PlayerCollision"):
		if (triggerstate == 8):
			print("tp player")
			CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Collect " + str(CurrentObjectiveFinished) + " more apples for cotton candy cooking.[/color]"
		elif (triggerstate == 9):
			CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Find the hydrogen canister in the woods.[/color]"
		elif (triggerstate == 10):
			CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Fill the hydrogen fuel storage with the hydrogen canister[/color]"
		
		player.position = teleporter_coordinates
#	pass # Replace with function body.


func collect_apple():
	if (triggerstate == 8 and CurrentObjectiveFinished > 0):
		CurrentObjectiveFinished -= 1
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Collect " + str(CurrentObjectiveFinished) + " more apples for cotton candy cooking.[/color]"
		if (CurrentObjectiveFinished == 0):
			CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Bring the apples back to the scientist.[/color]"
	elif (triggerstate == 8 and CurrentObjectiveFinished == 0):
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Bring the apples back to the scientist.[/color]"

func _on_EastWoodsArea_area_entered(area):
	player.position = Vector2(3080, 4210)
#	pass # Replace with function body.


func _on_HydrogenCanister_area_entered(area):
	if (area.name == "PlayerCollision" and CurrentObjectiveFinished == 1):
		CurrentObjectiveFinished = 0
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Bring the hydrogen canister back to the scientist.[/color]"
#	pass # Replace with function body.

var filled_up = false
func _on_Fillup_area_entered(area):
	if (area.name == "PlayerCollision" and !filled_up):
		filled_up = true
		CurrentObjectiveFinished = 1
		player.locked_in_place = true
		CurrentObjectiveBG.hide()
		CurrentObjective.hide()
		$NPCMoveEngine.move_node_along_path($".", $Paths/Airstrip/Follow, 100)
#		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Clear all the skellies off the runway (if you run out of candy go back to the scientist)[/color]"
#	pass # Replace with function body.


func _on_SkeletonsOnRunway_change_in_runwayskelly_count():
	if (triggerstate == 11):
		print(RunwayArea.skelliesonrunway.size())
		CurrentObjectiveFinished = RunwayArea.skelliesonrunway.size()
		CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Lure the skeletons off the runway. (" + str(CurrentObjectiveFinished) + " left)[/color]"
		
		# DEBUG TODO REMOVE
#		CurrentObjectiveFinished = 0
		
		if (CurrentObjectiveFinished == 0):
			CurrentObjective.bbcode_text = "[color=#000000]Current Objective: Head back to the scientist in the hangar.[/color]"
#	pass # Replace with function body.

var signalled = false
func _on_FlyableSpaceship_signal_scientist():
	if (triggerstate == 12 and !signalled):
		signalled = true
		_on_NPCMoveEngine_finished_moving()

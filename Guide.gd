extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var CurrentPath
var last_animation_frame = "standing_down"

var last_location = -1
var should_walk = false
var speed = 150;

export var disable_guide = false

var interaction = -1

var main_node

var player_node
var player_force_follow_guide = false
var player_offset_when_following = 40

func push_start():
	main_node.get_node("HUD/ColorRect/AnimationPlayer").play("Fade In")
	if (interaction == -1 and !disable_guide):
		interaction = 0
		should_walk = true

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentPath = $Paths/HelpPlayer/PathFollow2D
	player_node = get_parent().get_parent().get_parent().get_node("Player");
	main_node = get_parent().get_parent().get_parent()
#	print(position)
#	pass # Replace with function body.

func updatesprite(velocity): # TODO: bryt ut pls <3 
	if (velocity.length() > 0):
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0:
				$AnimatedSprite.play("walking_left")
				last_animation_frame = "standing_left"
			if velocity.x > 0:
				$AnimatedSprite.play("walking_right")
				last_animation_frame = "standing_right"
		else:	
			if velocity.y < 0:
				$AnimatedSprite.play("walking_up")
				last_animation_frame = "standing_up"
			if velocity.y > 0:
				$AnimatedSprite.play("walking_down")
				last_animation_frame = "standing_down"
	else:
		$AnimatedSprite.play(last_animation_frame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!CurrentPath):
		pass
	
	if (should_walk && CurrentPath.get_offset() == last_location):
		should_walk = false
		if (interaction == 0):
			$SpeechBubble.set_text("Hey what are you doing out here? ...", 3)
			yield(get_tree().create_timer(3.0),"timeout")
			$SpeechBubble.set_text("Hello?", 1)
			yield(get_tree().create_timer(1.0),"timeout")
			$SpeechBubble.set_text("HEY!?!", 1)
			yield(get_tree().create_timer(1.0),"timeout")
			$SpeechBubble.set_text("Are you dead? wake up!!!", 2)
			yield(get_tree().create_timer(2.0),"timeout")

			var selection = yield(player_node.ask_player("Are you dead? wake up!!!", ["Woah... Where am I?", "Is this heaven?"]), "completed")
			if (selection == 0):
				$SpeechBubble.set_text("That is not important right now, follow me, QUICK!", 2)
				yield(get_tree().create_timer(2.0),"timeout")
			else:
				$SpeechBubble.set_text("You wish huh!", 1.5)
				yield(get_tree().create_timer(0.5),"timeout")
				$SpeechBubble.set_text("Well you are still alive so follow me, QUICK!", 2)
				yield(get_tree().create_timer(1.0),"timeout")

			yield(get_tree().create_timer(1.0),"timeout")
			interaction = 1
			print("Done: Initial conversation, now playing HelpPlayerRun path")
			CurrentPath = $Paths/HelpPlayerRunaway/PathFollow2D
			should_walk = true
			player_force_follow_guide = true
			speed = 150;
			
		elif(interaction == 1):
			player_force_follow_guide = false
			player_node.update_sprite(Vector2(0,0), "standing_down")
			$AnimatedSprite.play("standing_down")
			
			$SpeechBubble.set_text("Look over there...", 4)
			yield(get_tree().create_timer(2.0),"timeout")
			player_node.update_sprite(Vector2(0,0), "standing_right")
			print("Sending camera to look at skellys")
			main_node.make_camera_follow_path(0.1699, main_node.get_node("CameraPaths/IntroShowSkelly/Follow/IntroShowSkellyCam"), main_node.get_node("CameraPaths/IntroShowSkelly/Follow"), 30)
			yield(get_tree().create_timer(20.0),"timeout")
			print("Back after looking at skellys")
			$SpeechBubble.set_text("The dead rise from their graves at SunDown...", 5)
			yield(get_tree().create_timer(6.0),"timeout")
			$SpeechBubble.set_text("And since the unspokent event happened...", 5) 
			yield(get_tree().create_timer(6.0),"timeout")
			$SpeechBubble.set_text("the sun has not come back...", 5)
			yield(get_tree().create_timer(6.0),"timeout")
			$SpeechBubble.set_text("So they currently roam freely, creating havoc here...", 5)
			yield(get_tree().create_timer(6.0),"timeout")
			
			$SpeechBubble.set_text("I am currently the guard on duty...", 5)
			yield(get_tree().create_timer(5.0),"timeout")
			$SpeechBubble.set_text("So i will not be able to follow you further...", 5)
			yield(get_tree().create_timer(5.0),"timeout")
			$SpeechBubble.set_text("Head south west from here and you should be safe.", 5)
			yield(get_tree().create_timer(5.0),"timeout")
			$SpeechBubble.set_text("But take this bow, arrow and some candy just to be safe.", 6)
			yield(get_tree().create_timer(2.0),"timeout")
			main_node.get_node("HUD/Consumables").show()
			player_node.get_node("ToolOverlay").show()
			yield(get_tree().create_timer(5.0),"timeout")
			$SpeechBubble.set_text("My name's Guide, now, good luck, you will need it", 5)
			yield(get_tree().create_timer(5.0),"timeout")
		
			interaction = 2
			print("Done: SkellyIntro, now playing StandToGuard path")
			CurrentPath = $Paths/StandToGuard/PathFollow2D
			should_walk = true
			player_force_follow_guide = false
			speed = 150;
			
		elif (interaction == 2):
			$AnimatedSprite.play("standing_left")
			player_node.locked_in_place = false
			print("Releasing player after Guide interaction")
			
		print("interaction complete")
		
	if (should_walk):
		last_location = CurrentPath.get_offset()
		
		CurrentPath.set_offset(CurrentPath.get_offset() + speed * delta)
#		print(CurrentPath.position)
		var direction = Vector2(CurrentPath.position.x - position.x, CurrentPath.position.y - position.y).normalized()
#		print(direction)
		
		updatesprite(direction) 
		
		position = CurrentPath.position
#		print("Guide: " + str(position))
		
		if (player_force_follow_guide):
			var player_original_position = player_node.position
			
			var position_to_be = CurrentPath.position;
			
			if (0 < CurrentPath.get_offset() - player_offset_when_following):
#				print ("works")
				CurrentPath.set_offset(CurrentPath.get_offset() - player_offset_when_following)
				position_to_be = CurrentPath.position
				CurrentPath.set_offset(CurrentPath.get_offset() + player_offset_when_following)
			
#			print("Player Before: " + str(player_node.position))
			var player_dir = Vector2(position_to_be.x - player_node.position.x, position_to_be.y - player_node.position.y).normalized()
			var patched_player_dir = Vector2(0, 0)

			if (abs(player_dir.x) > abs(player_dir.y)):
				if (player_dir.x > 0):
					patched_player_dir = Vector2(1, 0)
				else:
					patched_player_dir = Vector2(-1, 0)
			else:
				if (player_dir.y > 0):
					patched_player_dir = Vector2(0, 1)
				else:
					patched_player_dir = Vector2(0, -1)

			player_node.position = Vector2(position_to_be.x - 16, position_to_be.y - 16)
			player_node.update_sprite(patched_player_dir, player_node.lastwalk)
			
#			print("Player After: " + str(player_node.position))
#	pass

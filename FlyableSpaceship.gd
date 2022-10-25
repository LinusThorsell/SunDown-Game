extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal signal_scientist

var locked_in_place = true
var ship_speed = 200
var animationrect

var next_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	animationrect = get_tree().get_root().get_node("./Main/HUD/ColorRect/AnimationPlayer")
#	animationrect.play("Fade In")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (next_position != null):
		position = next_position
		next_position = null
	
	if (!locked_in_place):
#		var temp = lastwalk;
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			$AnimatedSprite.play("walking_right")
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			$AnimatedSprite.play("walking_left")
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
			$AnimatedSprite.play("walking_down")
		if Input.is_action_pressed("move_up"):
			$AnimatedSprite.play("walking_up")
			velocity.y -= 1
#		update_sprite(velocity, temp)
		
		velocity = velocity.normalized() * ship_speed
		
		move_and_slide(velocity)

var triggerstate = 0
func trigger():
	if triggerstate == 0:
		triggerstate = 1
		$Camera2D.current = true
		locked_in_place = false
		
#		print("heyoo")
		
		$SpeechBubble.set_text("Scientist: Hey, lets get this baby onto the runway!", 5)
		yield(get_tree().create_timer(1),"timeout")
		
	elif triggerstate == 1:
		triggerstate = 2
		print("starting runway run")
		$NPCMoveEngine.move_node_along_path($".", $"Takeoff/Follow", 150)
		yield(get_tree().create_timer(1),"timeout")
		$NPCMoveEngine.speed = 200
		
		$SpeechBubble.set_text("Scientist: Oh my, we goin'!", 5)
		yield(get_tree().create_timer(1),"timeout")
		
		$NPCMoveEngine.speed = 300
		yield(get_tree().create_timer(1),"timeout")
		$NPCMoveEngine.speed = 500
		yield(get_tree().create_timer(1),"timeout")
		$NPCMoveEngine.speed = 800
		#yield(get_tree().create_timer(0),"timeout")
		
		animationrect.play("Fade Out")
		
	elif triggerstate == 2:
		triggerstate = 3
		$Camera2D.current = true
		locked_in_place = false
		print("Space sequence")
		next_position = Vector2(7430, 1250)
		animationrect.play("Fade In")
		
		yield(get_tree().create_timer(1),"timeout")
		$SpeechBubble.set_text("Scientist: Holy waters! That was amazing!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Scientist: But back to business, we still need to ..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. find the helium, and I think I know some people on the spacestation.", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		$SpeechBubble.set_text("Head forwards through the asteroids and we should ..", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text(".. arrive at the spacestation in no time!", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		yield(get_tree().create_timer(10),"timeout")
		
		$SpeechBubble.set_text("There should be a docking port in the lower right side that we can use.", 4)
		yield(get_tree().create_timer(3),"timeout")
	
	elif triggerstate == 3:
		triggerstate = 4
		locked_in_place = true
		$SpeechBubble.set_text("Let me hop onto the station and get some helium for us!", 4)
		yield(get_tree().create_timer(3),"timeout")
		animationrect.play("Fade Out")
		yield(get_tree().create_timer(2),"timeout")
		animationrect.play("Fade In")
		yield(get_tree().create_timer(2),"timeout")
		$SpeechBubble.set_text("Alright, I got the helium, lets continue towards the sun!", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Shouldn't be too far, follow the trail!", 4)
		yield(get_tree().create_timer(3),"timeout")
		locked_in_place = false

	elif triggerstate == 4:
		print("end cutscene")
		
		locked_in_place = true
		
		$SpeechBubble.set_text("Oh my...", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("There it is...", 4)
		yield(get_tree().create_timer(3),"timeout")
		
		$SpeechBubble.set_text("I'm sending the Hydrogen and Helium now...", 4)
		yield(get_tree().create_timer(5),"timeout")
		
		var main_node = get_tree().get_root().get_node("./Main")
		main_node.make_camera_follow_path(0.1699, main_node.get_node("CameraPaths/EndShowSun/Follow/EndShowSunCam"), main_node.get_node("CameraPaths/EndShowSun/Follow"), 30)
		
		get_tree().get_root().get_node("./Main/Level/Misc/Sun/Sunonfire/AnimationPlayer").play("FireUpSun")
		yield(get_tree().create_timer(1.5),"timeout")
		
		$SpeechBubble.set_text("Wow it's so beautiful...", 4)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Thank you for saving our system Player.", 4)
		yield(get_tree().create_timer(3),"timeout")

		animationrect.play("Fade Out")
		
		yield(get_tree().create_timer(4),"timeout")
		get_tree().get_root().get_node("./Main/HUD/Foreground/EndThankYou").show()
		yield(get_tree().create_timer(254),"timeout")
		
		while(true):
			print("finished")

func _on_Scientist_spaceship_end():
	trigger()


var triggered = false
func _on_RunwaySequenceStart_area_entered(area):
	if (triggerstate == 1 and !triggered):
		triggered = true
		trigger()
#	pass # Replace with function body.


func _on_NPCMoveEngine_finished_moving():
	trigger()
#	pass # Replace with function body.


func _on_DockingPort_area_entered(area):
	if triggerstate == 3:
		trigger()

func _on_TriggerEndCutscene_area_entered(area):
	if triggerstate == 4:
		trigger()

func _on_Area2D_area_entered(area):
	emit_signal("signal_scientist")
#	pass # Replace with function body.

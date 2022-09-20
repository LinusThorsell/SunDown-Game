extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var CurrentPath
var last_animation_frame = "standing_down"

var last_location = -1
var should_walk = true

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentPath = $Paths/HelpPlayer/PathFollow2D
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
		print("Hey wake up...")
		$SpeechBubble.set_text("Hey what are you doing out here? ...", 3)
		yield(get_tree().create_timer(3.0),"timeout")
		$SpeechBubble.set_text("Hello?", 1)
		yield(get_tree().create_timer(1.0),"timeout")
		$SpeechBubble.set_text("HEY!?!", 1)
		yield(get_tree().create_timer(1.0),"timeout")
		$SpeechBubble.set_text("Are you dead? wake up!!!", 2)
		yield(get_tree().create_timer(2.0),"timeout")
		
		
		
	if (should_walk):
		last_location = CurrentPath.get_offset()
		
		CurrentPath.set_offset(CurrentPath.get_offset() + 20 * delta)
#		print(CurrentPath.position)
		var direction = Vector2(CurrentPath.position.x - position.x, CurrentPath.position.y - position.y).normalized()
		print(direction)
		
		updatesprite(direction) 
		
		position = CurrentPath.position
#	pass

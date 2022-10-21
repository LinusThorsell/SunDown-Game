extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var triggered = false
var player
var answer

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EWHouseEntrance_area_entered(area):
	if (!triggered):
		triggered = true
		$SpeechBubble.set_text("Greetings Player, what do you come here for?", 4)
		yield(get_tree().create_timer(3),"timeout")
		answer = yield(player.ask_player("Greetings Player, what do you come here for?", ["I am looking for a crashed spaceship part", "Looking for a big circular metal thingy with an H on it"]), "completed")
		
		if (answer == 0):
			$SpeechBubble.set_text("Spaceship? like the stuff witches do in their free time?", 5)
			yield(get_tree().create_timer(4),"timeout")
			$SpeechBubble.set_text("or am i thinking of scientists actually...", 5)
			yield(get_tree().create_timer(4),"timeout")
			$SpeechBubble.set_text("You should probably ask the scientist on the hill actually", 5)
			yield(get_tree().create_timer(4),"timeout")
			answer = yield(player.ask_player("You should probably ask the scientist on the hill actually", ["Let me rephrase, have you seen a big metal container fall from the sky?"]), "completed")
			$SpeechBubble.set_text("Ohhh that makes my brain happy, yes I have actually..", 5)
			yield(get_tree().create_timer(4),"timeout")
			
		elif (answer == 1):
			$SpeechBubble.set_text("Oh yes I have actually...", 5)
			yield(get_tree().create_timer(4),"timeout")

		$SpeechBubble.set_text("..almost hit me in the face a few days ago actually...", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("It is somewhere in the woods to the east of here actually.", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("But the path is blocked because of all the skellies, actually...", 5)
		yield(get_tree().create_timer(4),"timeout")

		$SpeechBubble.set_text("Oh now I remember, if you exit through the back of my house..", 5)
		yield(get_tree().create_timer(4),"timeout")
		
		$SpeechBubble.set_text("..there should be a secret path leading past the blockage...", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("but it is very dangerous...", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("So let me give you 7 candy for your trip.", 5)
		player.candy_left += 7
		yield(get_tree().create_timer(10),"timeout")
		
		$SpeechBubble.set_text("What are you looking at?", 2)
		yield(get_tree().create_timer(2),"timeout")
		$SpeechBubble.set_text("Go get that chonky metal container for your witchcraft now.", 4)
		yield(get_tree().create_timer(3),"timeout")

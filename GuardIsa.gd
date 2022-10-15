extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const CandyScene = preload("res://Candy.tscn")

var player
var return_after_move = 1
#var return_after_move = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	_on_NPCMoveEngine_finished_moving()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func introduce_player():
		$SpeechBubble.set_text("Hey! don't mind those guys..", 3)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("..they have been on their toes since..", 3)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("..the unspoken of event happened.", 3)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("How did you get out there?", 3)
		yield(get_tree().create_timer(3),"timeout")
		yield(player.ask_player("How did you get out there?", ["I dont know, I woke up by some crashed spaceship, my memory is faded."]), "completed")
		$SpeechBubble.set_text("... What? What is a 'spaceship' ?", 4)
		yield(get_tree().create_timer(2),"timeout")

		var answer = yield(player.ask_player("What is a spaceship?", ["A vehicle that lets you travel to other planets", "uhm... really? do you not know?"]), "completed")
		if (answer == 0):
			$SpeechBubble.set_text("I do still not understand, you might want..", 5)
			yield(get_tree().create_timer(5),"timeout")
			$SpeechBubble.set_text("..to speak to the crazy guy they call the scientist..", 5)
			yield(get_tree().create_timer(5),"timeout")
		else:
			$SpeechBubble.set_text("... no? are you trying to make fun of me?", 5)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text("This is the outer most post of the city..", 5)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text("..it is even named after me, Isa Outpost..", 5)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text("..so dont you dare make fun of me.", 5)
			yield(get_tree().create_timer(3),"timeout")
			$SpeechBubble.set_text("Anyways, since you are crazy, you might make good friends..", 5)
			yield(get_tree().create_timer(5),"timeout")
			$SpeechBubble.set_text("..with the crazy guy they call the scientist..", 5)
			yield(get_tree().create_timer(5),"timeout")

		$SpeechBubble.set_text("..but first, do you have any cotton candy for the trip?", 6)
		yield(get_tree().create_timer(5),"timeout")

		answer = yield(player.ask_player("Do you have any cotton candy for the trip?", ["Not but I love candy, could I have some?", "No I do not eat candy."]), "completed")

		$SpeechBubble.set_text("Oh boy.. you do not know the usecases of cotton candy?", 6)
		yield(get_tree().create_timer(5),"timeout")
		$SpeechBubble.set_text("... are you some kind of alien?", 4)
		yield(get_tree().create_timer(4),"timeout")

		$SpeechBubble.set_text("Anyways, follow me, I will show you how cottoncandy works.", 5)
		yield(get_tree().create_timer(4),"timeout")
		
		$NPCMoveEngine.move_node_along_path($".", $BringPlayerToSkellies/Follow, 80, true)

func teach_player_candy():
		$SpeechBubble.set_text("Alright, so these are skellies that we have captured..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..the rule is for obvious reasons to not hurt the skellies..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..hoping one day they will return ...", 5)
		yield(get_tree().create_timer(4),"timeout")
		
		$SpeechBubble.set_text("Anyways, to not have to hurt them we have found that..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..cotton candy works wonders to distract them for a short..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..period of time, watch this.", 5)
		yield(get_tree().create_timer(4),"timeout")
		
		var EntetieScene = get_parent()
		var CandyInstance = CandyScene.instance()
		EntetieScene.add_child(CandyInstance)
		CandyInstance.fire(Vector2(position.x-20, position.y), position)
		
		$SpeechBubble.set_text("As you can see the skellies immediatelly go to..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..the cotton candy, they will even ignore you..", 5)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..as long as there is cotton candy nearby.", 5)
		yield(get_tree().create_timer(4),"timeout")
		
		$SpeechBubble.set_text("Now it is your turn.", 3)
		yield(get_tree().create_timer(3),"timeout")
		$SpeechBubble.set_text("Here, take some candy.", 3)
		yield(get_tree().create_timer(3),"timeout")
		
		player.has_candy = true
		player.candy_left = 3
		player.locked_in_place = false
		
		yield(get_tree().create_timer(10),"timeout")
		$SpeechBubble.set_text("Great job crazy! The scientist lives south..", 4)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..of here, he would probably love to speak to..", 4)
		yield(get_tree().create_timer(4),"timeout")
		$SpeechBubble.set_text("..about spaceships and such, haha.", 4)
		yield(get_tree().create_timer(4),"timeout")
		
		$NPCMoveEngine.move_node_along_path($".", $GoBackToStand/Follow, 80)

func _on_GuardGenericLeftGate_signal_isa():
	$NPCMoveEngine.move_node_along_path($".", $GetPlayer/Follow, 80)


func _on_NPCMoveEngine_finished_moving():
	if (return_after_move == 1):
		return_after_move = 2
		introduce_player()
	elif (return_after_move == 2):
		return_after_move = 3
		teach_player_candy()

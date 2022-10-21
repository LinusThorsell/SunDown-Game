extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit_player():
	print("hitting player")
	player.health -= 5
	
	$Timer.start(2)

func _on_Hitrange_area_entered(area):
	if (area.name == "PlayerCollision"):
		player_in_range = true
		if ($Timer.time_left == 0):
			hit_player()
#	pass # Replace with function body.


func _on_Hitrange_area_exited(area):
	if (area.name == "PlayerCollision"):
		player_in_range = false
#	pass # Replace with function body.


func _on_Timer_timeout():
	if (player_in_range):
		hit_player()
#	pass # Replace with function body.

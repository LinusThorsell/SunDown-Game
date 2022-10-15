extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var playerlastposition

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScientistsDoor_area_entered(area):
	if (area.name == "PlayerCollision"):
		playerlastposition = Vector2(player.position.x, player.position.y+40)
		player.position = Vector2(3008, 3230)

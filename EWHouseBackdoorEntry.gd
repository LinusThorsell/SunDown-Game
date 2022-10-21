extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.

func _on_EWHouseBackdoorEntry_area_entered(area):
	player.position = Vector2(7872, -2960)

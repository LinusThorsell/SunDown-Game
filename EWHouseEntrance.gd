extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EWHouseEntrance_area_entered(area):
	player.position = Vector2(7887, -2865)
#	pass # Replace with function body.

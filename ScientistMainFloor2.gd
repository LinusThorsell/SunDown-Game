extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScientistMainFloor2_area_entered(area):
	player.position = Vector2(3200, 2910)
#	pass # Replace with function body.

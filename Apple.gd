extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scientist

# Called when the node enters the scene tree for the first time.
func _ready():
	scientist = get_tree().get_root().get_node("./Main/Level/Enteties/Scientist")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Apple_area_entered(area):
	if (area.name == "PlayerCollision"):
		scientist.collect_apple()
		$CollisionShape2D.disabled = true
		$".".hide()
#	pass # Replace with function body.

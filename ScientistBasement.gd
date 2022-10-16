extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var playerlastposition

signal trigger_scientist_basement

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScientistBasement_area_entered(area):
	player.position = Vector2(3200, 4060)
	emit_signal("trigger_scientist_basement")
#	pass # Replace with function body.

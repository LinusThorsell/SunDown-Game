extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal change_in_runwayskelly_count

var skelliesonrunway = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SkeletonsOnRunway_area_entered(area):
	if (area.name != "PlayerCollision" and area.name != "DetectionRadius" and area.name != "Hitrange"):
		skelliesonrunway.push_back(area)
		
		emit_signal("change_in_runwayskelly_count")
		print(skelliesonrunway)
#	pass # Replace with function body.


func _on_SkeletonsOnRunway_area_exited(area):
	if (area.name != "PlayerCollision" and area.name != "DetectionRadius" and area.name != "Hitrange"):
		skelliesonrunway.remove(skelliesonrunway.find(area))
	
		emit_signal("change_in_runwayskelly_count")
		print(skelliesonrunway)
#	pass # Replace with function body.

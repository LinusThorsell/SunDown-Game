extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal finished

var camera
var moving = false
var playercamera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $Camera
	playercamera = get_tree().get_root().get_node("./Main/Player/Camera2D")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x-(150*delta)
#	pass


func _on_Scientist_cutscene_spacefly():
	
	var animationplayer = get_tree().get_root().get_node("./Main/HUD/ColorRect/AnimationPlayer")
	
	animationplayer.play("Fade In")
	
	camera.current = true
	moving = true
	yield(get_tree().create_timer(3),"timeout")
	moving = false
	camera.current = false
	
	animationplayer.play("Fade Out")
	yield(get_tree().create_timer(2),"timeout")
	playercamera.current = true
	
	animationplayer.play("Fade In")
	
	emit_signal("finished")
	
#	pass # Replace with function body.

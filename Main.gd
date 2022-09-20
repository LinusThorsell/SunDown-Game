extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var IntroCam
var PathToFollow

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting: Intro cutscene")
	IntroCam = $CameraPaths/Intro/IntroFollow/IntroCam
	IntroCam.current = true
	PathToFollow = $CameraPaths/Intro/IntroFollow
	
	$HUD/ColorRect/AnimationPlayer.play("Fade In")
	#pass # Replace with function body.


func make_camera_follow_path(delta):
	PathToFollow.set_offset(PathToFollow.get_offset() + 100 * delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	make_camera_follow_path(delta)
#	pass

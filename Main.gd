extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var IntroCam
var PathToFollow


var last_camera_location = -1
var should_camera_move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting: Intro cutscene")
	IntroCam = $CameraPaths/Intro/IntroFollow/IntroCam
	IntroCam.current = false
	PathToFollow = $CameraPaths/Intro/IntroFollow
	$HUD/ColorRect/AnimationPlayer.play("Fade In")
	#pass # Replace with function body.


func make_camera_follow_path(delta):
	if (should_camera_move && PathToFollow.get_offset() == last_camera_location):
		should_camera_move = false
		IntroCam.current = false
		$Player/Camera2D.current = true
#		$Player.setPos(Vector2(-100, -100))
		
	if (should_camera_move):
		last_camera_location = PathToFollow.get_offset()
		PathToFollow.set_offset(PathToFollow.get_offset() + 300 * delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	make_camera_follow_path(delta)
#	pass

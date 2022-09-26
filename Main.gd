extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting: Intro cutscene")
	$HUD/Consumables.hide()
	$Player/ToolOverlay.hide()
	
	make_camera_follow_path(0.1699, $CameraPaths/Intro/Follow/IntroCam, $CameraPaths/Intro/Follow, 200)
	
	$HUD/ColorRect/AnimationPlayer.play("Fade In")
	yield($HUD/ColorRect/AnimationPlayer, "animation_finished")
	$HUD/ColorRect/AnimationPlayer.play("Fade Out")
	yield($HUD/ColorRect/AnimationPlayer, "animation_finished")
	#pass # Replace with function body.

var should_camera_move = true
var FollowCamera
var PathToFollow
var CameraSpeed
var last_camera_location = -1

func make_camera_follow_path(delta, camera, path, speed):
	if (delta == 0.1699): # hacky as duck but it works
		print("init")
		PathToFollow = path
		FollowCamera = camera
		FollowCamera.current = true # disabled
		should_camera_move = true
		CameraSpeed = speed
	
	if (should_camera_move && PathToFollow.get_offset() == last_camera_location):
		print("stopping")
		should_camera_move = false
		FollowCamera.current = false
		$Player/Camera2D.current = true
		
		$Level/Enteties/Guide.push_start()
#		$Player.setPos(Vector2(-100, -100))
		
	if (should_camera_move):
		last_camera_location = PathToFollow.get_offset()
		PathToFollow.set_offset(PathToFollow.get_offset() + CameraSpeed * delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	make_camera_follow_path(delta, FollowCamera, PathToFollow, CameraSpeed)
#	pass

extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var player_speed = 400
var screen_size
var lastwalk = "standing_down";

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 100
	position.y = 100
	#pass

func handle_movement():
	# moving code
	var temp = lastwalk;
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		lastwalk = "walking_right"
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		lastwalk = "walking_left"
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		lastwalk = "walking_down"
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		lastwalk = "walking_up"
		velocity.y -= 1
		
	$AnimatedSprite.play(lastwalk)

	if velocity.length() > 0:
		velocity = velocity.normalized() * player_speed
	else:
		if (temp == "walking_right"):
			$AnimatedSprite.play("standing_right")
		if (temp == "walking_left"):
			$AnimatedSprite.play("standing_left")
		if (temp == "walking_down"):
			$AnimatedSprite.play("standing_down")
		if (temp == "walking_up"):
			$AnimatedSprite.play("standing_up")
	#position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	move_and_slide(velocity)
func handle_tools():
	# rotate overlayed tool
	$ToolOverlay.look_at(get_global_mouse_position())
	$ToolOverlay.rotation_degrees -= 225

func _process(delta):
	handle_movement()
	handle_tools()

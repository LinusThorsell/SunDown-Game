extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ArrowScene = preload("res://Arrow.tscn")
const HealthDisplayScene = preload("res://HealthDisplay.tscn")  # todo fix all this shit

export var player_speed = 400
var screen_size
var lastwalk = "standing_down";

var healthbar
var max_health = 100
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 100
	position.y = 100
	
	healtbar = $

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
	
	if (Input.is_action_just_pressed("mouse_left")):
#		print(get_viewport().get_mouse_position())
		var EntetieScene = get_parent().find_node("Enteties")
		var ArrowInstance = ArrowScene.instance()
		EntetieScene.add_child(ArrowInstance)
		ArrowInstance.fire(get_global_mouse_position(), position)

func update_health():
	$Healthbar.text = "health: " + str(health)
	
func _process(delta):
	handle_movement()
	handle_tools()
	update_health()

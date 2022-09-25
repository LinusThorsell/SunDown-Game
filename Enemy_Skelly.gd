extends KinematicBody2D

export var run_speed = 0
var velocity = Vector2.ZERO
var player = null
var last_animation_frame = "standing_down"

var healthbar
var health = 100
var max_health = 100

const HealthDisplayScene = preload("res://HealthDisplay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar = HealthDisplayScene.instance()
	add_child(healthbar)
	
	healthbar.position = Vector2(healthbar.position.x-16, healthbar.position.y-16)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func walk_to_player():
	velocity = Vector2.ZERO
	if (player != null):
		velocity = position.direction_to(Vector2(player.position.x + 16, player.position.y + 16)) * run_speed
	velocity = move_and_slide(velocity)

func set_accurate_sprite():
	if (velocity.length() > 0):
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0:
				$AnimatedSprite.play("walking_left")
				last_animation_frame = "standing_left"
			if velocity.x > 0:
				$AnimatedSprite.play("walking_right")
				last_animation_frame = "standing_right"
		else:	
			if velocity.y < 0:
				$AnimatedSprite.play("walking_up")
				last_animation_frame = "standing_up"
			if velocity.y > 0:
				$AnimatedSprite.play("walking_down")
				last_animation_frame = "standing_down"
	else:
		$AnimatedSprite.play(last_animation_frame)

func _process(delta):
	# walk towards player
	walk_to_player()
	set_accurate_sprite()

func hit(type): # called by things that hit the unit
	if (type == "Arrow"):
#		print("Skeleton hit by arrow")
		health -= 5
	
	if (health <= 0):
		get_node(".").queue_free()
		
	healthbar.update_healthbar(health)
	
		# TODO: drop loot maybe?
		
func follow_path(path):
	print(path)

func _on_DetectRadius_body_entered(body):
	if(body.name == "Player"):
		player = body

func _on_DetectRadius_body_exited(body):
	player = null

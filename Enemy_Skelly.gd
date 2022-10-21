extends KinematicBody2D

export var aggressive_against_player = true
export var run_speed = 0
var velocity = Vector2.ZERO
var object_to_follow = null
var last_animation_frame = "standing_down"

var healthbar
var health = 100
var max_health = 100

var bodies_inside_radius = []

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
	object_to_follow = null
	velocity = Vector2.ZERO
	
	if (bodies_inside_radius.size() > 0 and aggressive_against_player):
#		print("Array is non-zero, find suitable target to follow: " + str(bodies_inside_radius))
		for i in range(0, bodies_inside_radius.size()):
			if (bodies_inside_radius[i].is_in_group("distractions")):
				object_to_follow = bodies_inside_radius[i]
		if (object_to_follow == null): # ifthere are no distractions follow player
			object_to_follow = bodies_inside_radius[0]
	
		velocity = position.direction_to(Vector2(object_to_follow.position.x + 16, object_to_follow.position.y + 16)).normalized() * run_speed
#		print("Skelly walking: " +  str(velocity))
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
	print("Got hit by: " + str(type))
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
	if (body.is_in_group("followables")):
		print("Adding: " + str(body))
		bodies_inside_radius.append(body)
#	if(body.name == "Candy"): #distract the skelly
#		player = body
#	elif(body.name == "Player"):
#		player = body

func _on_DetectRadius_body_exited(body):
	if (body.is_in_group("followables")):
		print("Removing: " + str(body))
		bodies_inside_radius.remove(bodies_inside_radius.find(body))
	
#	player = null


func _on_GuardGenericLeftGate_start_player_saving_from_skelly():
	print("chasing player")
	pass # Replace with function body.

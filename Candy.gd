extends KinematicBody2D


# Declare member variables here.
export var speed = 4.3
export var slowdown = 0.0000000001

var direction = Vector2(0,0)
var landed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("followables")
	add_to_group("distractions")

func fire(mouse, playerpos):
#	print("Fire candy")
	position = Vector2(playerpos.x + 16, playerpos.y + 16)
	look_at(mouse)
	rotation_degrees += 90
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	direction = position.direction_to(Vector2(mouse.x + rng.randf_range(-5, 5), mouse.y + rng.randf_range(-5, 5)))
	position += direction.normalized()*35
	
	speed -= rng.randf_range(0, 2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (0 <= (speed-(slowdown))):
		position += direction.normalized()*speed
		speed -= slowdown
		slowdown += slowdown
	elif (landed == false):
		$DespawnTimer.start()
#		print("starting timer")
		landed = true

func _on_Timer_timeout():
#	print("removing")
	queue_free()

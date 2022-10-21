extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var should_move = false;
var target = null;
var forceplayer = null;
var path = null;
var speed = null;
var last_location = -1;
var player


signal finished_moving

var velocity = 0
var last_animation_frame = null
func play_animation(last, new): # TODO: bryt ut pls <3 
	velocity = Vector2(new.x - last.x, new.y - last.y)
	if (velocity.length() > 0):
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0:
				get_parent().get_node("AnimatedSprite").play("walking_left")
				last_animation_frame = "standing_left"
			if velocity.x > 0:
				get_parent().get_node("AnimatedSprite").play("walking_right")
				last_animation_frame = "standing_right"
		else:	
			if velocity.y < 0:
				get_parent().get_node("AnimatedSprite").play("walking_up")
				last_animation_frame = "standing_up"
			if velocity.y > 0:
				get_parent().get_node("AnimatedSprite").play("walking_down")
				last_animation_frame = "standing_down"
	elif (last_animation_frame != null):
		get_parent().get_node("AnimatedSprite").play(last_animation_frame)

var last_coords
func move_node_if_active(delta):
	if (should_move):
#		print("moving")
#		print(target)
#		print(target.position)
#		print(path.get_offset())
#		print(path.position)
#		print("======")
#		print("moving")
		if (path.get_offset() == last_location):
			# stop condition
			print("stopping")
			should_move = false
			emit_signal("finished_moving")
		
		last_location = path.get_offset()
		last_coords = path.position
		path.set_offset(path.get_offset() + speed * delta)
		target.position = path.position;
		
		play_animation(last_coords, target.position)
		
		var tmp_offset = path.get_offset()
		if (forceplayer):
			path.set_offset(path.get_offset() - 4000 * delta)
			player.position = Vector2(path.position.x - 16, path.position.y - 16)
			path.set_offset(tmp_offset)
	
func move_node_along_path(target_node, follow_path, follow_speed, force_playerfollow=false):
	print("walking: node, path, speed")
	print(target_node)
	print(follow_path)
	print(follow_speed)
	print(force_playerfollow)
	print("=========")
	target = target_node;
	path = follow_path;
	speed = follow_speed;
	forceplayer = force_playerfollow
	
	should_move = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("./Main/Player")
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_node_if_active(delta)
#	pass

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
		path.set_offset(path.get_offset() + speed * delta)
		
		target.global_position = path.global_position;
		
		var tmp_offset = path.get_offset()
		if (forceplayer):
			path.set_offset(path.get_offset() - 100 * delta)
			player.position = path.position
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

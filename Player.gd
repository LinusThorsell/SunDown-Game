extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ArrowScene = preload("res://Arrow.tscn")
const CandyScene = preload("res://Candy.tscn")
const HealthDisplayScene = preload("res://HealthDisplay.tscn")

export var player_speed = 400
var screen_size
var lastwalk = "standing_up";

var healthbar
var max_health = 100
var health = 100

export var locked_in_place = true

var respawn_location = Vector2(-555, 780) # first place you can actually die, under city

var selection = -1

var arrows_left = 0
var candy_left = 0
var selected_tool = "Candy"

var has_bow = false
var has_candy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	healthbar = HealthDisplayScene.instance()
	add_child(healthbar)
	get_parent().get_node("HUD/Consumables/Remaining").text = "Arrows Left: " + str(arrows_left) + "\n" + "Candy Left: " + str(candy_left)

func setPos(vector):
	position = vector

var following_npc = false
func handle_movement():
	# moving code
	if (!locked_in_place):
		var temp = lastwalk;
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			
		if Input.is_action_just_released("scroll_down"):
			print("scroll down")
			if (selected_tool == "Bow"):
				selected_tool = "Candy"
			else:
				selected_tool = "Bow"
				
		if Input.is_action_just_released("scroll_up"):
			print("scroll up")
			if (selected_tool == "Bow"):
				selected_tool = "Candy"
			else:
				selected_tool = "Bow"
			
			
		update_sprite(velocity, temp)
		#position += velocity * delta
		#position.x = clamp(position.x, 0, screen_size.x)
		#position.y = clamp(position.y, 0, screen_size.y)
		
		velocity = velocity.normalized() * player_speed
		
		move_and_slide(velocity)
	elif (!following_npc):
		$AnimatedSprite.play("standing_down")
		
func update_sprite(velocity, temp):
	lastwalk = temp

	if velocity.length() > 0:
#		print(velocity)
		if (velocity.y == 1):
			$AnimatedSprite.play("walking_down")
			lastwalk = "walking_down"
		elif (velocity.y == -1):
			$AnimatedSprite.play("walking_up")
			lastwalk = "walking_up"
		elif (velocity.x == 1):
			$AnimatedSprite.play("walking_right")
			lastwalk = "walking_right"
		elif (velocity.x == -1):
			$AnimatedSprite.play("walking_left")
			lastwalk = "walking_left"
		
	else:
#		print("setting to standing")
		if (temp == "walking_right"):
			$AnimatedSprite.play("standing_right")
		if (temp == "walking_left"):
			$AnimatedSprite.play("standing_left")
		if (temp == "walking_down"):
			$AnimatedSprite.play("standing_down")
		if (temp == "walking_up"):
			$AnimatedSprite.play("standing_up")
			
func handle_tools():
	
	if (!has_bow and !has_candy):
		$ToolOverlay.hide()
		get_tree().get_root().get_node("./Main/HUD/Consumables").hide()
	else:
		$ToolOverlay.hide() # removing
		get_tree().get_root().get_node("./Main/HUD/Consumables").show()
	# rotate overlayed tool
#	$ToolOverlay.look_at(get_global_mouse_position())
#	if (selected_tool == "Bow" and has_bow):
#		get_parent().get_node("HUD/Consumables/SelectedTool").play("bow")
#		get_parent().get_node("HUD/Consumables/CurrentlyUsingName").text = "Bow <scroll>"
#		$ToolOverlay.play("bow")
	if (selected_tool == "Candy" and has_candy):
#		get_parent().get_node("HUD/Consumables/SelectedTool").play("candy")
#		get_parent().get_node("HUD/Consumables/CurrentlyUsingName").text = "Candy <scroll>"
		$ToolOverlay.play("candy")
#	$ToolOverlay.rotation_degrees -= 180
	
#	if (Input.is_action_just_pressed("mouse_left") and !locked_in_place and selected_tool == "Bow" and arrows_left > 0):
##		print(get_viewport().get_mouse_position())
#		var EntetieScene = get_parent().find_node("Enteties")
#		var ArrowInstance = ArrowScene.instance()
#		EntetieScene.add_child(ArrowInstance)
#		ArrowInstance.fire(get_global_mouse_position(), position)
#		arrows_left -= 1
	if (Input.is_action_just_pressed("mouse_left") and !locked_in_place and selected_tool == "Candy" and candy_left > 0):
#		print(get_viewport().get_mouse_position())
		var EntetieScene = get_parent().find_node("Enteties")
		var CandyInstance = CandyScene.instance()
		EntetieScene.add_child(CandyInstance)
		CandyInstance.fire(get_global_mouse_position(), position)
		candy_left -= 1
		
		
	get_parent().get_node("HUD/Consumables/Remaining").text = "Candy Left: " + str(candy_left);

func update_health():
	healthbar.update_healthbar(health)
	if health <= 0:
		print("ded, respawning at latest location")
		position = respawn_location
		health = 100
		if candy_left < 5:
			candy_left = 5
	
func ask_player(question, options):
	get_parent().get_node("HUD/SelectionBox").show()
	if (options.size() == 1):
		get_parent().get_node("HUD/SelectionBox/MainLabel").text = "Responding to: '" + question + "'\n[1] " + options[0]
	elif (options.size() == 2):
		get_parent().get_node("HUD/SelectionBox/MainLabel").text = "Responding to: '" + question + "'\n[1] " + options[0] + "\n[2] " + options[1]
	elif (options.size() == 3):
		get_parent().get_node("HUD/SelectionBox/MainLabel").text = "Responding to: '" + question + "'\n[1] " + options[0] + "\n[2] " + options[1] + "\n[3] " + options[2]
	elif (options.size() == 4):
		get_parent().get_node("HUD/SelectionBox/MainLabel").text = "Responding to: '" + question + "'\n[1] " + options[0] + "\n[2] " + options[1] + "\n[3] " + options[2] + "\n[4] " + options[3]
	else:
		print("Error in ask_player: question(" + question + ") options(" + options + ")")
	lastwalk = "standing_down"
	
	var selected_option = -1;
	var available_options = options.size()
	var looping = true
	while(looping):
		if (Input.is_action_pressed("select_1")):
			looping = false
			get_parent().get_node("HUD/SelectionBox").hide()
			selected_option = 0;
		if (Input.is_action_pressed("select_2") and available_options >= 2):
			looping = false
			get_parent().get_node("HUD/SelectionBox").hide()
			selected_option = 1;
		if (Input.is_action_pressed("select_3") and available_options >= 3):
			looping = false
			get_parent().get_node("HUD/SelectionBox").hide()
			selected_option = 2;
		if (Input.is_action_pressed("select_4") and available_options >= 4):
			looping = false
			get_parent().get_node("HUD/SelectionBox").hide()
			selected_option = 3;
		
		# avoid locking up execution
		yield(get_tree(), "idle_frame")

	return selected_option
	
func _process(delta):
	handle_movement()
	handle_tools()
	update_health()
	
#	print(position)
	
var cutscenes_played = [ # true = not available yet / already played. false = ready to play
	true, # Skelly_Intro
]
func _on_TrigCut_Skelly1_body_entered(body):
	handle_cutscene_interception("Intro_Skelly") # Replace with function body.

func _on_TrigCut_Skelly2_body_entered(body):
	handle_cutscene_interception("Intro_Skelly") # Replace with function body.

func handle_cutscene_interception(cutscene):
	print("TODO: Play " + cutscene + " cutscene")
	if (cutscene == "Intro_Skelly" and !cutscenes_played[0]):
		cutscenes_played[0] = true
		print("Intro_Skelly initialized")
		
		get_parent().get_node("HUD/ColorRect/AnimationPlayer").play("Fade Out Fast")


func _on_GuardsAtIntro_area_entered(area):
	if (area.name == "CollisionArea"):
		print("player")
		locked_in_place = true
		lastwalk = "standing_down"
	#pass # Replace with function body.

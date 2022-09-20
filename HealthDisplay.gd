extends Node2D


# Declare member variables here.
var bar_red = preload("res://assets/img/ui/healthbar/red.png")
var bar_green = preload("res://assets/img/ui/healthbar/green.png")
var bar_yellow = preload("res://assets/img/ui/healthbar/yellow.png")

var healthbar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	healthbar = $Healthbar
	
#	hide()
	if (get_parent() and get_parent().get("max_health")):
		print(get_parent().max_health)
		healthbar.max_value = get_parent().max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0

func update_healthbar(value):
	if healthbar:	
		healthbar.texture_progress = bar_green
		if value < healthbar.max_value * 0.7:
			healthbar.texture_progress = bar_yellow
		if value < healthbar.max_value * 0.35:
			healthbar.texture_progress = bar_red
#		if value < healthbar.max_value:
#			show()
		healthbar.value = value

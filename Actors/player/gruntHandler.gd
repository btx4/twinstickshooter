extends Node2D

# Radius of the circle around the player
const SPAWN_RADIUS = 1000.0
 
# Reference to the player (adjust the path as needed)
@onready var player = get_node("../Player") 
@onready var timer = $timer 
@onready var grunt_scene = preload("res://Actors/grunt_enemy/grunt_enemy.tscn") 
var running = true;
var TIME = 1
var SPEED = 100
var x = 0

func _ready() -> void:
	timer.start(TIME)
		
func _reset() -> void:
	TIME = 1;
	SPEED = 100
	running = true;

# Called when the node enters the scene tree for the first time.

# Function to spawn a Grunt at a random position around the player
func spawn_grunt() -> void:
	if running:
		if player:
			# Generate a random angle between 0 and 2π (360 degrees in radians)
			var angle = randf() * TAU

			# Calculate the spawn position on the circle with the given radius
			var spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * SPAWN_RADIUS
			
			# Instantiate a new Grunt
			var grunt = grunt_scene.instantiate()

			# Set the Grunt's position to the calculated spawn position
			grunt.global_position = spawn_position
			grunt.SPEED= SPEED + x
			
			# Add the Grunt to the scene tree
			get_parent().add_child(grunt)
			x = x + 1
func _on_timer_timeout() -> void:
	#print("GSPAWN")
	TIME = TIME * 0.99
	
	spawn_grunt()
	# Restart the timer with a delay of 1 second multiplied by 0.99
	timer.start(TIME)

extends CharacterBody2D

@export var projectile_scene: Resource
@export var player: Node2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 5
var score_label
var score
# Timer for moving towards the player
func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player
	$Gunshot_timer.start()
	score_label = get_parent().get_parent().get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel
	$movetimer.start()

func kill():
	queue_free()
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	if(health == 0):
		update_score(50)
		queue_free()

func hit():
	health = health - 1
	print("hit")
	
# This function will be called every 3 seconds

func move_towards_player() -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		print("Player not assigned")

func _on_gunshot_timer_timeout() -> void:
	fire()

var x = 360 / 15
func fire():
	var new_projectile = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
	
	# Calculate direction to the player
	var direction_to_player = (player.global_position - global_position).normalized()
	
	# Fire the projectile in the direction of the player with a specified speed
	var speed = 300
	new_projectile.fire(direction_to_player, speed)
	
	# Set the position of the new projectile to the current global position
	new_projectile.position = global_position

func update_score(amount: int) -> void:
	if score_label:
		score = amount + get_score_from_label()
		score_label.text = "Score: %d" % score  # Update the score text

func get_score_from_label() -> int:
	if score_label:
		# Get the text from the RichTextLabel
		var text = score_label.text
		
		# Extract the score from the text
		# Assuming the text format is "Score: X", where X is the number
		var score_value = text.replace("Score: ", "").to_int()
		
		return score_value
	else:
		print("Score label not found")
		return 0
func _on_movetimer_timeout() -> void:
	print("moving_")
	move_towards_player()

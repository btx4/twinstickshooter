extends CharacterBody2D

var SPEED = 100.0
var player: CharacterBody2D
var game_over_scene: PackedScene = preload("res://Actors/sine_bullet.tscn")
var score_label
var score 
func _ready() -> void:
	# Retrieve the player node from the group
	var players = get_tree().get_nodes_in_group("player")
	score_label = get_parent().get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel
	if(score_label):
		print("FOUNDIT")
	else:
		print("FAILED")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player

func hit():
	queue_free()
	update_score(5)
	print("hit")

func _process(delta):
	# Make sure the sprite stays upright while the CharacterBody2D rotates
	$shadow.rotation_degrees = -rotation_degrees
	$shadow.global_position.x = global_position.x 
	$shadow.global_position.y = global_position.y + 15
func _physics_process(delta: float) -> void:
	if player:
		# Calculate direction towards the player
		var direction = (player.global_position - global_position).normalized()
		move_and_collide(direction)
		


func _on_body_entered(body: Node2D) -> void:
	print("Grunt Enemy collided with", body)
	if body.is_in_group("player"):
		# Load and display the game over screen
		var game_over_instance = game_over_scene.instantiate()
		get_tree().current_scene.add_child(game_over_instance)
		#print("BOOM")
		print(get_parent()._reset())

func _on_area_entered(body: Node2D) -> void:
	print("AreaEntered")
	

func update_score(amount: int) -> void:
	if score_label:
		score = amount + get_score_from_label()
		
		score_label.text = "Score: %d" % score  # Update the score text
	else:
		print("FAILURE")

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

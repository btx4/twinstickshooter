extends Node2D

var SPEED = 100.0
var player: CharacterBody2D
var velocity: Vector2
var game_over_scene: PackedScene = preload("res://Actors/sine_bullet.tscn")  # Path to your GameOver scene

func _ready() -> void:
	# Retrieve the player node from the group
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player

func _physics_process(delta: float) -> void:
	if player:
		# Calculate direction towards the player
		var direction = (player.global_position - global_position).normalized()
		# Update velocity and position
		velocity = direction * SPEED
		position += velocity * delta
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Load and display the game over screen
		var game_over_instance = game_over_scene.instantiate()
		get_tree().current_scene.add_child(game_over_instance)
		print("BOOM")
		print(get_parent()._reset())

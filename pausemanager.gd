# PauseManager.gd
extends Node

# Function to toggle pause
func toggle_pause():
	if get_tree().paused:
		# Unpause the game
		get_tree().paused = false
		print("Game unpaused")
	else:
		# Pause the game
		get_tree().paused = true
		print("Game paused")
		
		
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):  # "Escape" key mapped to "ui_cancel"
		toggle_pause()

extends Sprite2D

# Constants for bounce parameters
var bounce_amplitude: float = 5.0  # pixels
var bounce_speed: float = 1.0  # speed of the bounce

# Variable to track time for the sine wave
var time_passed: float = 0.0

func _physics_process(delta: float) -> void:
	# Update time passed
	time_passed += delta

	# Calculate the bounce using a sine wave
	var bounce_offset: float = sin(time_passed * bounce_speed) * bounce_amplitude

	# Update the sprite's vertical position
	position.y = bounce_offset

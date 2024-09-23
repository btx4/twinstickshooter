extends Sprite2D

# Constants for rotation speed in degrees per second
const ROTATION_SPEED = 720  # degrees per second
var spinning = true;
func _physics_process(delta: float) -> void:
	if(spinning == true):
		var rotation_amount = ROTATION_SPEED * delta * deg_to_rad(1)  # Convert degrees to radians

		# Update the sprite's rotation
		rotation += rotation_amount

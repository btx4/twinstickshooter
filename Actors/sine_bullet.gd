extends Area2D

var velocity: Vector2 = Vector2(0, 0)
var score_label: RichTextLabel = null
var score: int
@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))
# Define amplitude and frequency for the sine wave
# Define amplitude and frequency for the sine wave
var sine_amplitude: float = 20.0  # The height of the sine wave
var sine_frequency: float = 2.0  # The number of oscillations per second
var elapsed_time: float = 0.0  # Track the elapsed time
var perpendicular_direction: Vector2
var num = 25
func fire(direction: Vector2, speed: float) -> void:
	velocity = direction * speed
	perpendicular_direction = Vector2(-direction.y, direction.x)
	rotation = velocity.angle()
	update_score(-1)
	
	# Calculate the perpendicular direction to velocity for sine wave motion
	perpendicular_direction = velocity.rotated(deg_to_rad(90)).normalized()

func _ready() -> void:
	# Ensure the signal is connected correctly
	if body_entered_signal:
		print("Signal connected successfully")
	else:
		print("Failed To Connect")
	
	# Get the RichTextLabel reference from the main scene
	score_label = get_parent().get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel

func _physics_process(delta: float) -> void:
	# Increment the elapsed time
	elapsed_time += delta
	
	# Move the projectile in the direction
	position += velocity * delta
	
	# Add sine wave movement in the perpendicular direction
	if(num % 100 <50):
		position += perpendicular_direction * 5
	else:
		position -= perpendicular_direction * 5
	
	num = num + 1



# Called when the Area2D hits another body
func _on_body_entered(body: Node) -> void:
	print(body)
	if body.is_in_group("player"):
		print("dud")
	if body.is_in_group("Grunt"):
		print("Hit!")
		if score_label:
			update_score(5)  # Increment the score by 1
		body.queue_free()  # Remove the Grunt
		queue_free()  # Remove the projectile

func _on_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("player"):
		print("dud")
	if area.is_in_group("Grunt"):
		print("Hit!")
		if score_label:
			update_score(5)  # Increment the score by 1
		else: 
			print("noscorelabelfound")
		area.queue_free()  # Remove the Grunt
		queue_free()  # Remove the projectile


# Optional: Handle projectile lifetime
func _on_timer_timeout() -> void:
	queue_free()

# Updates the score and reflects it in the RichTextLabel
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

extends Area2D

var velocity: Vector2 = Vector2(0, 0)
var score_label: RichTextLabel = null
var score: int
#@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))
@export var projectile_scene: Resource

var swinging = false
var can_swing = true
var tween;
const CHANCE_OF_POWERUP = 12
const ROTATION_CLOCKWISE = 30
const ROTATION_COUNTERCLOCKWISE = -180
const RESET_ROTATION = 0
func swing(direction: Vector2) -> void:
	if(can_swing == true):
		$Whoosh.play()
		var tween = create_tween()
		# Create the tween for rotation
		tween.tween_property(self, "rotation_degrees",  ROTATION_CLOCKWISE, 0.1).as_relative()
		tween.tween_property(self, "rotation_degrees", ROTATION_COUNTERCLOCKWISE, 0.1).as_relative().set_delay(0.1)
		tween.tween_property(self, "rotation_degrees", 0, 0.5).as_relative().set_delay(0.18)
		
		# Start the timer to reset swinging
		can_swing = false;
		var timer = $Timer
		var warmupTimer = $Warmup_timer
		if timer and warmupTimer:
			#print("Timer 1 start")
			timer.start()
			warmupTimer.start()
		var reswing_timer = $Reswing_Timer
		#print("Timer???")
		if reswing_timer:
			#print("timer start")
			reswing_timer.start()

func _ready() -> void:
	# Ensure the signal is connected correctly
	
	# Get the RichTextLabel reference from the main scene
	score_label = get_parent().get_parent().get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel
	
	# Connect the timeout signal of the Timer to a function
	var timer = $Timer
	var reswing_timer = $Reswing_Timer
	if timer:
		timer.timeout.connect(_on_swing_timeout)
	if reswing_timer:
		reswing_timer.timeout.connect(on_reswing_timeout)

# Called when the Area2D hits another body
func _on_area_entered(area: Area2D) -> void:
	#print(area)
	if area.is_in_group("Enemies"):
		#print("Hit!")
		if swinging == true:
			$Batcrack.play()
			if score_label:
				update_score(5)  # Increment the score by 1
			if(area.is_in_group("shooter")):
				area.kill()
			else:
				area.hit()
			enemy_hit(area)
			
func _on_body_entered(body: Node) -> void:
	#print(area)
	if body.is_in_group("Enemies"):
		#print("Hit!")
		if swinging == true:
			$Batcrack.play()
			if score_label:
				update_score(5)  # Increment the score by 1
			
			if(body.is_in_group("shooter")):
				body.kill()
			else:
				body.hit()
				
			enemy_hit(body)
			

func _physics_process(delta: float) -> void:
	"""if(swinging == true):
		print("HITTABLE")
	pass"""
	pass

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

# This function is called when the Timer times out
func _on_swing_timeout() -> void:
	swinging = false
	
func on_reswing_timeout() -> void:
	#print("Timer Done")
	can_swing = true
	
func enemy_hit(collider) -> void:
	var new_projectile = projectile_scene.instantiate()
	get_parent().get_parent().add_child(new_projectile)
	var parent_position = get_parent().global_position

	var direction = (collider.global_position - parent_position).normalized()

	new_projectile.fire(direction, 700)
	new_projectile.position = collider.global_position


func _on_warmup_timer_timeout() -> void:
	swinging = true;
	pass # Replace with function body.

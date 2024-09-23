extends Area2D
var collision_spawning = false
var velocity: Vector2 = Vector2(0, 0)
var score_label: RichTextLabel = null
var score: int
var CHANCE_OF_POWERUP = 12
@export var powerup_scene: Resource
@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))

# Called when the node enters the scene tree for the first time.
func fire(direction: Vector2, speed: float) -> void:
	velocity = direction * speed
	rotation = velocity.angle()

func _ready() -> void:
	# Ensure the signal is connected correctly
	if body_entered_signal:
		print("Signal connected successfully")
	else:
		print("Failed To Connect")
	
	# Get the RichTextLabel reference from the main scene
	score_label = get_parent().get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel

# Called when the Area2D hits another body
func _on_body_entered(body: Node) -> void:
	print(body)
	if body.is_in_group("player"):
		print("dud")
	if body.is_in_group("Grunt"):
		print("Hit!")
		print("Duplication")
		enemy_hit(body)
		
		var random_value = randi() % CHANCE_OF_POWERUP  # Generates a number between 0 and 4
		print("random_value = ",random_value)
		if random_value == 0:
			
			var powerup = powerup_scene.instantiate()
			powerup.position = body.position
			get_parent().get_parent().add_child(powerup)
		
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
		print("Duplication")
		
		enemy_hit(area)
		var random_value = randi() % CHANCE_OF_POWERUP  # Generates a number between 0 and 4
		print("random_value = ",random_value)
		if random_value == 0:
			
			var powerup = powerup_scene.instantiate()
			powerup.position = area.position
			get_parent().get_parent().add_child(powerup)
		
		if score_label:
			update_score(5)  # Increment the score by 1
		else: 
			print("noscorelabelfound")
		area.queue_free()  # Remove the Grunt
		queue_free()  # Remove the projectile

func _physics_process(delta: float) -> void:
	position += velocity * delta

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


func _on_reswing_timer_timeout() -> void:
	pass # Replace with function body.
	

func enemy_hit(collider) -> void:
	if collision_spawning == true:
		print("oogla Boogla")
		var new_projectile = duplicate()
		print("adding a kiddo to ",get_parent())
		get_parent().add_child(new_projectile)
		var parent_position = global_position
		var direction = (collider.global_position - parent_position).normalized()
		new_projectile.fire(direction, 700)
		new_projectile.position = collider.global_position

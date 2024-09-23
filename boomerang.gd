extends Area2D

var velocity: Vector2 = Vector2(0, 0)
var score_label: RichTextLabel = null
var score: int
@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))
var DECELERATION: float = 650.0 # Rate at which the velocity decreases
var canPickup = false;
var velocity_reversed 
var speed 
var init_speed
var i = 0;
# Called when the node enters the scene tree for the first time.
func fire(direction: Vector2, speed2: float) -> void:
	velocity = direction * speed2
	velocity_reversed = -velocity
	rotation = velocity.angle()
	speed = speed2
	init_speed = speed
	update_score(-1)
	$pickup_timer.start()

func _process(delta):
	# Make sure the sprite stays upright while the CharacterBody2D rotates
	$Sprite2D.rotation_degrees = -rotation_degrees
	$Sprite2D.global_position.x = global_position.x 
	if $CollisionShape2D/Sprite2D.spinning == true:
		$Sprite2D.global_position.y = global_position.y + 30
	else:
		$Sprite2D.global_position.y = global_position.y + 20
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
	if body is StaticBody2D:
		print("Collided with StaticBody2D")
	if body.is_in_group("player"):
		if canPickup:
			get_parent().get_node("Player").boomerang_count = 1
			queue_free()
	if body.is_in_group("wall"):
		print("STOP!")
		reverse = true
		i = 151
	if body.is_in_group("Grunt"):
		if $CollisionShape2D/Sprite2D.spinning == true:
			print("Hit!")
			if score_label:
				update_score(5)  # Increment the score by 1
			else: 
				print("noscorelabelfound")
			body.queue_free()  # Remove the Grunt

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("dud")
		get_parent().boomerang_count =1
		queue_free()
	if area.is_in_group("wall"):
		print("STOP!")
		reverse = true
		i = 151
	if area.is_in_group("Grunt"):
		if $CollisionShape2D/Sprite2D.spinning == true:
			print("Hit!")
			if score_label:
				update_score(5)  # Increment the score by 1
			else: 
				print("noscorelabelfound")
			area.queue_free()  # Remove the Grunt
		
var reverse = false;
func _physics_process(delta: float) -> void:
	
	if(speed > 0.5 and reverse == false):
		#print("REVERSED VELOCITY", velocity_reversed)
		speed -= DECELERATION * delta
		velocity = velocity.normalized() * speed
		#print(velocity)
		position += velocity * delta
	else:
		if(reverse == false):
			velocity = velocity_reversed
		#print("Bing bing bong")
		if(i < 80):
			i+=1
			speed += DECELERATION * delta
			#print(speed)
			reverse = true
			velocity = velocity.normalized() * speed
			#print(velocity_reversed)
			position += velocity * delta
		else: 
			speed -= DECELERATION * delta
			velocity = velocity.normalized() * speed
			#print(velocity_reversed)
			if(speed > 0.1 or speed < -0.1):
				position += velocity * delta
				speed = 0;
				velocity = Vector2(0, 0)
				$CollisionShape2D/Sprite2D.spinning = false;
				#print(position.x)
# Optional: Handle projectile lifetime

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


func _on_pickup_timer_timeout() -> void:
	canPickup = true;
	pass # Replace with function body.
	
	
func _on_timer_timeout() -> void:
	#queue_free()
	pass

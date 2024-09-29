extends Area2D

var velocity: Vector2 = Vector2(0, 0)
var score_label: RichTextLabel = null

var score: int
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
# Called when the Area2D hits another body
func _on_body_entered(body: Node) -> void:
	print(body)
	if body.is_in_group("player"):
		print("Playerhit")
		get_parent()._reset()

func _on_area_entered(area: Area2D) -> void:
	print(area)
	if area.is_in_group("player"):
		print("Playerhit")

func _physics_process(delta: float) -> void:
	position += velocity * delta

# Optional: Handle projectile lifetime
func _on_timer_timeout() -> void:
	queue_free()

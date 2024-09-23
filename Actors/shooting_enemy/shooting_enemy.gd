extends CharacterBody2D

@export var projectile_scene: Resource
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
func _ready():
	$Gunshot_timer.start()

func _physics_process(delta: float) -> void:
	

	move_and_slide()


func _on_gunshot_timer_timeout() -> void:
	fire()
	pass # Replace with function body.
	
var x = 360/15
func fire():
	for i in range(0,14):
		var new_projectile = projectile_scene.instantiate()
		get_parent().add_child(new_projectile)
		print(i)
		new_projectile.fire(Vector2.from_angle(x * i), 100)
		new_projectile.position = global_position

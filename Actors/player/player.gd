extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var projectile_scene: Resource
@export var boomerang_scene: Resource
@export var sine_bullet_scene: Resource
@onready var bat = $Baseball_Bat
var boomerang_count
var boomerang_scale = 1

func _ready() -> void:
	boomerang_count = 1;

var score_label: RichTextLabel = null

func reset_score() -> void:
	print("scorereset")
	if score_label:
		print("SCORERESET")
		score_label.text = "Score: %d" % 0  # Update the score text

func reset():
	boomerang_scale = 1
	position = Vector2(0,0)
	boomerang_count =1 
	for rang in get_tree().get_nodes_in_group("boomerang"):
		print("found_rang")
		rang.queue_free()
	$Baseball_Bat.scale = Vector2(1, 1)
	reset_score()# Inside your CharacterBody2D script

func _process(delta):
	# Make sure the sprite stays upright while the CharacterBody2D rotates
	$Sprite2D.rotation_degrees = -rotation_degrees
	$Sprite2D.global_position.x = global_position.x 
	$Sprite2D.global_position.y = global_position.y + 30

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if(boomerang_count == 0):
		$PlayerSprite.visible = false
	else:
		$PlayerSprite.visible = true

	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction2 := Input.get_axis("move_up", "move_down")
	if direction2:
		velocity.y = direction2
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED  # Normalize and multiply by speed

	# Use move_and_slide() and capture collision information
	var collision_count = move_and_slide()
	
	# Check for collisions manually
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if(collision.get_collider().is_in_group("Grunt")):
			get_parent()._reset()
		if(collision.get_collider().is_in_group("shooter")):
			get_parent()._reset()
			
	if Input.is_action_just_pressed("click"):
		bat.swing(Vector2.from_angle(rotation))
	
	
	if Input.is_action_just_pressed("q_press"):
		get_parent()._reset()
	
	if Input.is_action_just_pressed("right_click"):
		if(boomerang_count > 0):
			boomerang_count -= 1
			on_click2_action()
		else:
			print("no boomerangs")
		
	if Input.is_action_just_pressed("middle_click"):
		on_click3_action()
		
	if Input.is_action_just_pressed("spacebar"):
		on_click_action()



func on_click_action() -> void:
	# Do something when the mouse is clicked
	var new_projectile = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
	new_projectile.fire(Vector2.from_angle(rotation), 400)
	new_projectile.position = $ProjectileRefPoint.global_position
	# Add your custom logic here
	
func on_click2_action() -> void:
	# Do something when the mouse is clicked
	var new_projectile = boomerang_scene.instantiate()
	get_parent().add_child(new_projectile)
	new_projectile.scale *= boomerang_scale
	new_projectile.fire(Vector2.from_angle(rotation), 600)
	new_projectile.position = $ProjectileRefPoint.global_position
	# Add your custom logic here

	
func on_click3_action() -> void:
	# Do something when the mouse is clicked
	var new_projectile = sine_bullet_scene.instantiate()
	get_parent().add_child(new_projectile)
	new_projectile.fire(Vector2.from_angle(rotation), 400)
	new_projectile.position = $ProjectileRefPoint.global_position
	# Add your custom logic here

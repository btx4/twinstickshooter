extends Node2D


@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))
@export var projectile_scene: Resource
@export var powerup_scene: Resource
# Called when the node enters the scene tree for the first time.
func _reset():
	$Player.reset()
	$gruntHandler._reset()
	clear_all_entities()

func clear_all_entities():
	for enemy in get_tree().get_nodes_in_group("Grunt"):
		print("enemiescleared")
		enemy.queue_free()
	for enemy in get_tree().get_nodes_in_group("powerup"):
		print("enemiescleared")
		enemy.queue_free()
	
	for enemy in get_tree().get_nodes_in_group("Grunt"):
		print("enemiescleared")
		enemy.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

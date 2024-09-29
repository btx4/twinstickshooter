extends Node2D


@onready var body_entered_signal = self.connect("body_entered", Callable(self, "_on_body_entered"))
@export var projectile_scene: Resource
@export var powerup_scene: Resource
var score_label
# Called when the node enters the scene tree for the first time.
func _reset():
	$Player.reset()
	$gruntHandler._reset()
	clear_all_entities()
	score_label = get_node("CanvasLayer/Score")  # Adjust the path to your RichTextLabel
	if score_label:
		score_label.text = "Score: %d" % 0  # Update the score text


func clear_all_entities():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		#print("enemiescleared")
		enemy.queue_free()
	for enemy in get_tree().get_nodes_in_group("powerup"):
		#print("enemiescleared")
		enemy.queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("IdleFront")
	pass # Replace with function body.

func _trigger(player: Node2D):
	var bat = player.get_node("Baseball_Bat")
	if (randi() % 2 == 1):
		bat.scale *= 1.1
	else:
		print("INCREASING BOOM SIZE")
		player.boomerang_scale = player.boomerang_scale * 1.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if(body.is_in_group("player")):
		_trigger(body)
		queue_free()
	pass # Replace with function body.

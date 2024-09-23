dddd
# This method will be called when the Area2D detects a body entering its area
func _on_Area2D_body_entered(body: Node) -> void:
	print("Collided with: ", body.name)

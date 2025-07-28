extends Area3D


func _on_body_entered(body: Node3D) -> void:
	var ant = body as Ant
	if ant:
		ant.jump_velocity = ant.BASE_JUMP_VELOCITY * 3
func _on_body_exited(body: Node3D) -> void:
	var ant = body as Ant
	if ant:
		ant.jump_velocity = ant.BASE_JUMP_VELOCITY

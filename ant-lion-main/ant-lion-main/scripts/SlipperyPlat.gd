extends Area3D

func _on_body_entered(body: Node3D) -> void:
	var ant = body as Ant
	if ant:
		ant.sliding = true

func _on_body_exited(body: Node3D) -> void:
	var ant = body as Ant
	if ant:
		ant.sliding = false

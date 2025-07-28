class_name Candy extends Area3D

@onready var model: Node3D = $Model


func _process(delta: float) -> void:
	model.rotate_y(deg_to_rad(2))

class_name Food extends RigidBody3D

signal lost

const TIME_TO_LOSE: int = 5

@onready var model: Node3D = $Model
@onready var spring_arm_pivot: Node3D = $SpringArmPivot
@onready var spring_arm: SpringArm3D = $SpringArmPivot/SpringArm3D
@onready var trajectory: GPUParticles3D = $SpringArmPivot/Trajectory

var current_ant: CharacterBody3D
var previous_ant: CharacterBody3D
var time_in_air: float = 0.0

func _ready() -> void:
	current_ant = get_parent_node_3d()
	previous_ant = current_ant
	trajectory.visible = false


func _unhandled_input(event: InputEvent) -> void:
	# Camera rotations
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		trajectory.rotate_x(-event.relative.y * .005)
		trajectory.rotation.x = clamp(trajectory.rotation.x, -PI/4, PI/4)
		if current_ant:
			current_ant.get_node("Model").rotation.y = spring_arm_pivot.rotation.y + PI


func _physics_process(delta: float) -> void:
	model.rotate_y(deg_to_rad(2))
	if Main.has_lost: return
	
	# If the food has been flying for too long, it means player has lost by then
	if not current_ant:
		time_in_air += delta
		if time_in_air > TIME_TO_LOSE:
			Main.has_lost = true
			lost.emit()

class_name Ant extends CharacterBody3D

const BASE_SPEED = 5.0
const MAX_SPEED = 10.0
const BASE_JUMP_VELOCITY = 4.5
const LERP_VAL = 0.5

@onready var model: Node3D = $Model
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var throw_sound: AudioStreamPlayer3D = $ThrowSound
var is_current_ant: bool = false
var sliding: bool = false
var speed: float = BASE_SPEED
var jump_velocity = BASE_JUMP_VELOCITY
var last_direction: Vector3 = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if not is_current_ant: return
	
	if Input.is_action_just_pressed("throw"):
		var food: Food = get_node("Food")
		food.trajectory.visible = true
		var tween = create_tween()
		tween.tween_property(food.spring_arm, "position:x", 2, 0.1)
		Engine.set_time_scale(0.5)
	
	if Input.is_action_just_released("throw"):
		animation_player.play("throw")
		throw_sound.play()
		finish_ant()
		var food: Food = get_node("Food")
		food.current_ant = null
		food.previous_ant = self
		food.trajectory.visible = false
		food.time_in_air = 0.0
		food.reparent(get_parent())
		food.apply_impulse(-food.spring_arm.global_transform.basis.z.normalized() * 20)
		var tween = create_tween()
		tween.tween_property(food.spring_arm, "position:x", 0, 0.1)
		Engine.set_time_scale(1)


func _ready() -> void:
	if get_node_or_null("Food") != null:
		is_current_ant = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	if not is_current_ant: return # Prevent any movement, but still allow ant to fall (Lines above)

	# Ant movement
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if sliding == true:
			var speed_factor = velocity.length() / speed  # Get movement intensity
			velocity.y = jump_velocity + (speed_factor * 3.5) # change the 3.5 if you want longer jump distance
			velocity.x = lerp(velocity.x, velocity.x + (velocity.x * speed_factor), 0.5)  # Preserve or increase x momentum
			velocity.z = lerp(velocity.z, velocity.z + (velocity.z * speed_factor), 0.5)  # Preserve or increase z momentum
		else:
			velocity.y = jump_velocity


	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animation_player.play("crawl")
		if sliding:
			speed = clamp(speed + delta * 3, 0, MAX_SPEED)
		else:
			speed = clamp(speed - delta * 3, BASE_SPEED, MAX_SPEED)
		direction = direction.rotated(Vector3.UP, model.rotation.y + PI)
		last_direction = direction
		velocity.x = lerp(velocity.x, direction.x * speed, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * speed, LERP_VAL)
	else:
		animation_player.play("idle")
		if not is_on_floor(): return
		if sliding:
			speed = clamp(speed - delta * 2, 0, MAX_SPEED)
			velocity.x = lerp(velocity.x, last_direction.x * speed, LERP_VAL)
			velocity.z = lerp(velocity.z, last_direction.z * speed, LERP_VAL)
		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)


func _on_grab_hitbox_body_entered(food: Food) -> void:
	if food.previous_ant == self or Main.has_lost: return
	
	# Catch the food
	food.linear_velocity = Vector3.ZERO
	food.angular_velocity = Vector3.ZERO
	food.reparent(self)
	food.position = Vector3(0, 1, 0)
	food.current_ant = self
	is_current_ant = true


func finish_ant() -> void:
	is_current_ant = false
	velocity = Vector3.ZERO

class_name Level extends Node3D

@onready var level_ui: LevelUI = $LevelUI
@onready var candies: Node3D = $Candies
@onready var ant_lion_path: Path3D = $AntLionPath
@onready var goal: Area3D = $Goal
@onready var death_pit: MeshInstance3D = $DeathPit
@export var food: Food

var candies_collected = [false, false, false]
var candyCount: float = 0

func _ready() -> void:
	Main.current_level = int(name.erase(0, 5))
	Main.has_lost = false
	level_ui.time_left = level_ui.TIME_PER_LEVEL
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Music.play()
	
	for candy: Candy in candies.get_children():
		candy.body_entered.connect(func(body: Node3D):
			var candy_index = int(candy.name.erase(0, 5)) - 1
			candies_collected[candy_index] = true
			candyCount += 1
			CandySound.play()
			candy.queue_free())
		
	
	level_ui.lost.connect(func():
		Main.has_lost = true
		var current_ant = food.current_ant
		if current_ant:
			current_ant.finish_ant()
		else:
			food.linear_velocity = Vector3.ZERO)
			
	food.lost.connect(func():
		level_ui.display_lose_screen())
		
	goal.body_entered.connect(func(body: CharacterBody3D):
		for i in candies_collected.size():
			if candies_collected[i]:
				Main.candies_collected[Main.current_level - 1][i] = true
		if Main.current_level < Main.NUMBER_OF_LEVELS:
			level_ui.display_win_screen(false)
		else:
			level_ui.display_win_screen(true)
		food.current_ant.finish_ant())
		
		
	death_pit.get_node("Area3D").body_entered.connect(func(ant: Ant):
		if not ant.is_current_ant: return
		Main.has_lost = true
		ant.finish_ant()
		level_ui.display_lose_screen())
	
	ant_lion_behavior()
	
	var controls_tutorial = get_node_or_null("ControlsTutorial")
	if controls_tutorial:
		var show_mouse_click = get_node("ShowMouseClick")
		show_mouse_click.body_entered.connect(func(food: Food):
			controls_tutorial.get_node("Throw").visible = true)
		show_mouse_click.body_exited.connect(func(food: Food):
			controls_tutorial.get_node("Throw").visible = false)
		await get_tree().create_timer(5).timeout
		controls_tutorial.get_node("Movement").visible = false


func get_candy_count()->int:
	return candyCount

func ant_lion_behavior() -> void:
	var path_follow = ant_lion_path.get_node("PathFollow3D")
	var ant_lion = path_follow.get_node("AntLion")
	var tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1, 90)
	
	ant_lion.get_node("AnimationPlayer").play("crawl")
	ant_lion.get_node("Area3D").body_entered.connect(func(ant: Ant):
		if not ant.is_current_ant: return
		Main.has_lost = true
		tween.stop()
		ant.finish_ant()
		level_ui.display_lose_screen())
		

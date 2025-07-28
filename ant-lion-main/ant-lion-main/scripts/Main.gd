extends Node

const NUMBER_OF_LEVELS = 8

var current_level: int = 0
var has_lost: bool = false
var candies_collected = []
var music = AudioStreamPlayer3D.new()
var candy_pick_up_sound = AudioStreamPlayer3D.new()

func _ready() -> void:
	for i in 9:
		candies_collected.append([false, false, false])

func play_level(level_to_play: int) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/level_" + str(level_to_play) + ".tscn")


func start_game() -> void:
	if current_level == 0:
		get_tree().change_scene_to_file("res://scenes/opening.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	

func play_next_level() -> void:
	current_level += 1
	play_level(current_level)


func reset_level() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()

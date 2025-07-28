extends Control

@onready var levels: HBoxContainer = $CanvasLayer/Levels


func _ready() -> void:
	Music.stop()
	for level in levels.get_children():
		level.pressed.connect(func():
			Main.play_level(int(level.text)))


func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

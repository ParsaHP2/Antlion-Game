extends Control


func _ready() -> void:
	Music.stop()
	var cutscene = get_node_or_null("Cutscene")
	if not cutscene: return
	
	await get_tree().create_timer(3).timeout	
	var tween = create_tween()
	tween.tween_property(cutscene, "position:x", 0, 7)
	await tween.finished
	await get_tree().create_timer(1).timeout
	Main.play_level(1)

func _on_play_pressed() -> void:
	Main.start_game()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

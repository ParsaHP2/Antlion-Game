class_name LevelUI extends CanvasLayer

signal lost

const TIME_PER_LEVEL = 90

@onready var pause: Label = $Pause
@onready var lose: TextureRect = $Lose
@onready var win: TextureRect = $Win
@onready var win_final: TextureRect = $WinFinal
@onready var time_left_label: Label = $TimeLeft
@onready var candy_label: Label = $CandyLabel 
@onready var level: Level = get_parent()

var time_left: float = TIME_PER_LEVEL
var has_won: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("pause") and not Main.has_lost:
		var tree = get_tree()
		tree.paused = not get_tree().paused
		pause.visible = not pause.visible
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if tree.paused else Input.MOUSE_MODE_CAPTURED)
		
		
func _physics_process(delta: float) -> void:
	candy_label.text = "Candies Collected: " + str(level.get_candy_count())
	
	if not get_tree().paused and not Main.has_lost and not has_won:
		time_left -= delta
		time_left_label.text = "Time Remaining: " + str(clamp(int(time_left), 0, TIME_PER_LEVEL))
		if time_left < 0:
			lost.emit()
			display_lose_screen()

		
func _on_return_to_menu_pressed() -> void:
	var tree = get_tree()
	tree.paused = false
	tree.change_scene_to_file("res://scenes/main_menu.tscn")


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	

func _on_retry_pressed() -> void:
	Main.reset_level()
	

func _on_continue_pressed() -> void:
	Main.play_next_level()


func display_lose_screen():
	lose.visible = true
	candy_label.text = "Candies Collected: " + str(level.get_candy_count()) 
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	
	
func display_win_screen(last_level: bool):
	has_won = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	candy_label.text = "Candies Collected: " + str(level.get_candy_count())
	
	if not last_level:
		win.visible = true
	else:
		win_final.visible = true

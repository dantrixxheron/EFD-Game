extends Control

@onready var btn_go_to_level_1 = $btnGoToLevel1
@onready var btn_go_to_level_2 = $btnGoToLevel2
@onready var soundtrack:AudioStreamPlayer=$WaitingSong

func _ready():
	check_level_unlock();
	soundtrack.play()
	var time_data = load_time_data()  # Cargar el tiempo guardado
	check_time(time_data)

func check_time(time_data):
	if time_data:
		soundtrack.seek(time_data)  # Reanudar desde el tiempo guardado si existe
	else:
		soundtrack.play(0.0)

func check_level_unlock():
	var unlocked_levels = load_unlocked_levels()
	if "level_1" in unlocked_levels:
		btn_go_to_level_1.disabled = false
		btn_go_to_level_1.remove_theme_stylebox_override("disabled")
		btn_go_to_level_1.flat=true;
	else:
		btn_go_to_level_1.disabled = true

func _on_btn_go_to_tutorial_pressed():
	var time = soundtrack.get_playback_position()  # Obtiene el tiempo actual
	save_time_data(time)  # Guarda el tiempo cuando se hace click
	var next_scene = load("res://scenes/levels/tutorial.tscn")
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")

func _on_btn_go_to_level_1_pressed():
	var time = soundtrack.get_playback_position()  # Obtiene el tiempo actual
	save_time_data(time)  # Guarda el tiempo cuando se hace click
	var next_scene = load("res://scenes/levels/Escena1.tscn")
	get_tree().change_scene_to_file("res://scenes/levels/Escena1.tscn")

func save_unlocked_levels(levels):
	var file = FileAccess.open("user://unlocked_levels.dat", FileAccess.WRITE)
	if file:
		for level in levels:
			file.store_line(level)
		file.close()

func load_unlocked_levels():
	var unlocked_levels = []
	var file = FileAccess.open("user://unlocked_levels.dat", FileAccess.READ)
	if file:
		while file.get_position() < file.get_length():
			unlocked_levels.append(file.get_line().strip_edges())
		file.close()
	return unlocked_levels

# Funciones para guardar y cargar el tiempo
func save_time_data(time):
	var file = FileAccess.open("user://game_data.dat", FileAccess.WRITE)  # Cambiado a FileAccess
	if file:
		file.store_line(str(time))  # Almacena el tiempo como un string
		file.close()

func load_time_data():
	var file = FileAccess.open("user://game_data.dat", FileAccess.READ)  # Cambiado a FileAccess
	if file:
		var time_str = file.get_line()
		file.close()
		return float(time_str)  # Devuelve el tiempo como float
	return null  # Si no hay tiempo guardado



func _on_btn_go_to_main_menu_pressed():
	var time = soundtrack.get_playback_position()  # Obtiene el tiempo actual
	save_time_data(time)  # Guarda el tiempo cuando se hace click
	var next_scene = load("res://scenes/control/Menu.tscn")
	get_tree().change_scene_to_file("res://scenes/control/Menu.tscn")

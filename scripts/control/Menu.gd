extends Control
@onready var soundtrack: AudioStreamPlayer = $WaitingSong
@onready var settingsPopUp:Control=$MenuSettings

# Cargar el tiempo guardado desde un archivo
func _ready():
	soundtrack.play()
	settingsPopUp.visible=false
	var time_data = load_time_data()  # Cargar el tiempo guardado
	if time_data:
		soundtrack.seek(time_data)  # Reanudar desde el tiempo guardado si existe
	else:
		soundtrack.play(0.0)

# Guardar el tiempo actual de la canción en el archivo
func _on_click():
	var time = soundtrack.get_playback_position()  # Obtiene el tiempo actual
	save_time_data(time)  # Guarda el tiempo cuando se hace click
	var next_scene = load("res://scenes/control/levels_map.tscn")
	get_tree().change_scene_to_file("res://scenes/control/levels_map.tscn")

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


func _on_btn_go_to_settings_button_down():
	settingsPopUp.visible=true


func _on_btn_exit_game_pressed():
	get_tree().quit()

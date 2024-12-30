extends Node2D

@onready var menuGameOver: Node2D = $infoGame/GameOverMenu
@onready var win_menu = $infoGame/WinMenu
@onready var palanca = $palanca
@onready var tunel = $TileMap/tunnel
@onready var clock_label = $infoGame/Control/Clock  # Etiqueta del reloj en la escena
@onready var win_time_label = $infoGame/WinMenu/txtTime  # Etiqueta del tiempo en el menú de ganar
@onready var win_record_label = $infoGame/WinMenu/txtRecord  # Etiqueta del tiempo en el menú de ganar
var time_elapsed = 0.0
@onready var backtrack:AudioStreamPlayer=$sountrackGame
var best_score = float("inf")  # Inicializamos el mejor puntaje con infinito
var level_name = "level_1"  # Nombre dinámico del nivel
func _ready():
	win_menu.visible = false  # Asegúrate de que el menú de ganar esté oculto inicialmente
	# Conecta la señal de palanca a la función set_state de tunel
	palanca.connect("toggle_state", Callable(tunel, "set_state"))
	set_process(true)  # Activa el procesamiento continuo
	backtrack.play()
	load_best_score(level_name)

func _process(delta):
	# Actualiza el tiempo transcurrido
	time_elapsed += delta  # Delta es el tiempo desde el último frame
	# Convertir tiempo a minutos y segundos
	var minutes = int(time_elapsed) / 60  # Minutos
	var seconds = int(time_elapsed) % 60  # Segundos
	# Formatear el tiempo para que sea en formato min:seg
	var formatted_time = str(minutes) + ":" + str(seconds).pad_zeros(2)  # Asegura que los segundos tengan dos dígitos
	# Actualiza la etiqueta del reloj
	clock_label.text = formatted_time
	if get_tree().get_nodes_in_group("player").size() == 0:
		show_win_menu()

func show_win_menu():
	self.remove_child(backtrack)
	get_tree().paused = true  # Pausa el juego
	win_menu.visible = true   # Muestra el menú de ganar
	# Muestra el tiempo transcurrido en el menú de ganar
	var formatted_time = formatoMin(time_elapsed)
	win_time_label.text = formatted_time  # Establece el tiempo en la etiqueta
	# Guarda el mejor puntaje si es necesario
	if best_score>0:
		if time_elapsed < best_score:
			best_score = time_elapsed
			save_best_score(best_score,level_name)
			win_record_label.text = formatoMin(time_elapsed)
		else:
			win_record_label.text = formatoMin(best_score)
	else:
			save_best_score(time_elapsed,level_name)
			win_record_label.text = formatoMin(time_elapsed)

func formatoMin(tiempo):
	var minutes = int(tiempo) / 60  # Minutos
	var seconds = int(tiempo) % 60  # Segundos
	var formatted_time = str(minutes) + ":" + str(seconds).pad_zeros(2)  # Asegura que los segundos tengan dos dígitos
	return formatted_time

func _on_fall_down_body_entered(body):
	if body.is_in_group("player"):
		game_over()

func game_over():
	get_tree().paused=true
	menuGameOver.visible = true  # Muestra el menú de Game Over

# Funciones para guardar y cargar el mejor puntaje

func save_best_score(score,lvlname):
	var file_path = "user://best_score_" + lvlname + ".dat"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_line(str(score))
		file.close()

func load_best_score(lvlname):
	var file_path = "user://best_score_" + lvlname + ".dat"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var score_str = file.get_line()
		file.close()
		best_score = float(score_str)
	else:
		best_score = float("inf")  # Si no hay archivo, inicializa con infinito

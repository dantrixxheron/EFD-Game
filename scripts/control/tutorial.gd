extends "res://scripts/levels/Escena1.gd"
signal level_completed(level_name)
@onready var actionsP1: Label = $actionP1
@onready var actionsP2: Label = $actionP2
@onready var player1: CharacterBody2D = $TileMap/Player1
@onready var player2: CharacterBody2D = $TileMap/Player2
var instructions1=true
var instructions2=true
func _ready():
	level_name = "tutorial"  # Cambia el nombre del nivel
	super._ready()  # Llama al método _ready() de la clase base
	actionsP1.text="Press A/D to move"
	actionsP2.text="Press Arrows to move"
	set_process(true)  # Activa el procesamiento continuo

func _process(delta):
	super._process(delta)  # Llama al método _process() de la clase base
	validActions()

func validActions():
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):
		actionsP1.text = "Now, jump with W key"
		if Input.is_key_pressed(KEY_W):
			instructions1=false
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT):
		actionsP2.text = "Get Down using ⬇️ and the arrows"
		if Input.is_key_pressed(KEY_DOWN):
			actionsP2.text="Now jump with ⬆️ key"
			if Input.is_key_pressed(KEY_UP):
				instructions2=false
	if instructions1==false:
		actionsP1.text=""
	if  instructions2==false:
		actionsP2.text=""
func show_win_menu():
	super.show_win_menu()
	unlock_level("level_1")  # Desbloquea el nivel 1

func unlock_level(level_name):
	var unlocked_levels = load_unlocked_levels()
	if level_name not in unlocked_levels:
		unlocked_levels.append(level_name)
		save_unlocked_levels(unlocked_levels)

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

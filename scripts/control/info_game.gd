extends CanvasLayer
@onready var menuPopUp:Node2D=$MenuPopUp
@onready var menuGameOver:Node2D=$GameOverMenu
@onready var menuWin:Node2D=$WinMenu
@onready var settingsPopUp:Control=$MenuSettings

func _ready():
	menuPopUp.visible=false
	menuGameOver.visible=false
	menuWin.visible=false
	settingsPopUp.visible=false

func _on_btn_open_menu_pressed():
	get_tree().paused=true
	menuPopUp.visible=get_tree().paused


func _on_btn_resume_pressed():
	get_tree().paused=false
	menuPopUp.visible=get_tree().paused


func _on_btn_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	menuPopUp.visible = false


func _on_button_pressed():
	_on_btn_restart_pressed()


func _on_btn_go_to_levels_map_pressed():
	get_tree().paused = false
	var next_scene = load("res://scenes/control/levels_map.tscn")
	get_tree().change_scene_to_file("res://scenes/control/levels_map.tscn")


func _on_btn_settings_pressed():
	settingsPopUp.visible=true

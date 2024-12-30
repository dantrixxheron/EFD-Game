extends Control


func _on_button_button_down():
	# Cambiar a la escena de juego
	var next_scene = load("res://Escena0.tscn")
	get_tree().change_scene_to(next_scene)

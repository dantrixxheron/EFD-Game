extends Control

func _on_btn_go_back_pressed():
	self.visible = false  # Cierra la ventana emergente

func _on_btn_clear_storage_pressed():
	var file_paths=["user://unlocked_levels.dat","user://best_score_tutorial.dat", "user://best_score_level_1.dat"]
	#var file_path = "user://unlocked_levels.dat"  # Ruta del archivo a eliminar
	var dir = DirAccess.open("user://")  # Abre el directorio de usuario
	for file_path in file_paths:
		if dir.file_exists(file_path):  # Verifica si el archivo existe
			var error = dir.remove(file_path)  # Elimina el archivo

extends Node2D

signal toggle_state(is_open)

var is_open = false  # Estado inicial de la palanca
@onready var palancaSprite: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if is_open:
			palancaSprite.play_backwards("default")
		else:
			palancaSprite.play("default")
		is_open = !is_open
		emit_signal("toggle_state", is_open)  # Emite la señal con el estado actual

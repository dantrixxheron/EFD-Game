extends Node2D

@onready var tunnelSprite: AnimationPlayer = $AnimationPlayer
@onready var coalision_tunnel: StaticBody2D = $Area2D
@onready var coalision_shape: CollisionShape2D = $Area2D/CollisionShape2D

func set_state(is_open):
	if is_open:
		tunnelSprite.play("default")
		coalision_tunnel.remove_child(coalision_shape)
	else:
		tunnelSprite.play_backwards("default")
		coalision_tunnel.add_child(coalision_shape)

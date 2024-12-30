extends CharacterBody2D

var speed = 120  # Velocidad de movimiento del personaje
var jump_velocity = -350  # Velocidad de salto
var gravity = 800  # Gravedad para caída
var acceleration = 200  # Aceleración para suavizar el movimiento

# Referencia al AnimatedSprite2D
@onready var animated_sprite = $animSprite2/AnimatedSprite2D
@onready var coalision: CollisionShape2D = $BodyShape
@onready var capsule_shape: CapsuleShape2D = coalision.shape  # Forma de colisión

# Variables para almacenar los tamaños originales
var default_radius: float
var default_height: float
var crouch_height: float

func _ready():
	# Guardar las dimensiones originales de la cápsula
	default_radius = capsule_shape.radius
	default_height = capsule_shape.height
	
	# Calcular el tamaño reducido para agacharse
	crouch_height = default_height / 1.5
	
	# Iniciar la animación por defecto
	animated_sprite.play("idle")
	add_to_group("player2")
	add_to_group("player")

func _physics_process(delta):
	var input_dir = Vector2.ZERO

	if Input.is_key_pressed(KEY_DOWN):
		# Reducir la altura de la cápsula para agacharse
		capsule_shape.height = crouch_height
		if Input.is_key_pressed(KEY_LEFT):
			input_dir.x = -1
			animated_sprite.play("getDown")
			animated_sprite.flip_h = true
		elif Input.is_key_pressed(KEY_RIGHT):
			input_dir.x = 1
			animated_sprite.play("getDown")
			animated_sprite.flip_h = false
	else:
		# Restaurar el tamaño original de la cápsula
		capsule_shape.height = default_height
		if Input.is_key_pressed(KEY_LEFT):
			input_dir.x = -1
			animated_sprite.play("walk")
			animated_sprite.flip_h = true
		elif Input.is_key_pressed(KEY_RIGHT):
			input_dir.x = 1
			animated_sprite.play("walk")
			animated_sprite.flip_h = false

	# Detectar la tecla CTRL derecho para hacer la animación de "pick"
	if Input.is_key_pressed(KEY_CTRL):
		animated_sprite.play("pick")

	# Aplicar gravedad cuando no esté en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

	# Saltar cuando esté en el suelo y se presione la tecla de salto
	if is_on_floor() and Input.is_key_pressed(KEY_UP):
		velocity.y = jump_velocity
		animated_sprite.play("jump")

	# Aplicar la dirección de entrada horizontal a la velocidad del personaje
	velocity.x = input_dir.x * speed

	# Mover al personaje usando move_and_slide() y gestionar colisiones
	move_and_slide()

	# Animación en estado "idle" cuando no haya movimiento
	if input_dir == Vector2.ZERO and not Input.is_key_pressed(KEY_CTRL):
		animated_sprite.play("idle")
func _on_Area2D_body_entered(body):
	if body.is_in_group("damage"):
		die()  # Función para gestionar la animación de muerte

func die():
	animated_sprite.play("die")

extends CharacterBody2D

var speed = 100  # Velocidad de movimiento del personaje
var jump_velocity = -350  # Velocidad de salto
var gravity = 800  # Ajuste de gravedad para caída más rápida

# Referencia al AnimatedSprite2D
@onready var animated_sprite = $AnimSprite/AnimatedSprite2D

func _ready():
	# Iniciar la animación por defecto
	animated_sprite.play("idle")
	add_to_group("player1")
	add_to_group("player")
	connect("die", Callable(get_parent(), "_on_player_die"))  # Conecta la señal al nodo padre (escena)

func _physics_process(delta):
	var input_dir = Vector2.ZERO

	# Capturar directamente las teclas A (izquierda) y D (derecha) para moverse
	if Input.is_key_pressed(KEY_A):
		input_dir.x = -1  # Mover a la izquierda
		animated_sprite.flip_h = true  # Girar el sprite a la izquierda
		animated_sprite.play("walk")
		if Input.is_key_pressed(KEY_S):
			animated_sprite.play("push")
	elif Input.is_key_pressed(KEY_D):
		input_dir.x = 1  # Mover a la derecha
		animated_sprite.flip_h = false  # Girar el sprite a la derecha
		animated_sprite.play("walk")
		if Input.is_key_pressed(KEY_S):
			animated_sprite.play("push")
	# Detectar la tecla E para hacer la animación de "pick"
	if Input.is_key_pressed(KEY_E):
		animated_sprite.play("pick")
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if is_on_floor() and Input.is_key_pressed(KEY_W):
		velocity.y = jump_velocity
		animated_sprite.play("jump")
	
	# Aplicar el input horizontal a la velocidad del personaje
	velocity.x = input_dir.x * speed

	# Mover al personaje utilizando `move_and_slide()`
	move_and_slide()

	# Controlar las animaciones cuando el personaje no se está moviendo
	if input_dir == Vector2.ZERO and not Input.is_key_pressed(KEY_E):
		animated_sprite.play("idle")


func die():
	# Lógica para manejar la muerte del personaje
	animated_sprite.play("die")
	emit_signal("die")  # Emitir señal para la escena principal

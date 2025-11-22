extends Area3D

# --- Variables para animaciones ---
@export var rotation_speed: float = 2.0
@export var bob_speed: float = 3.0
@export var bob_height: float = 0.15

var time_passed: float = 0.0
var initial_y: float

func _ready():
	initial_y = position.y

func _on_body_entered(body):
	# Comprueba si es el player
	if body.is_in_group("player") or body.name == "Player":
		
		# Llamamos a la función del Autoload
		GameManager.agregar_gema()
		
		# Reproducir sonido si tienes uno (opcional)
		# $AudioStreamPlayer3D.play()
		
		# Destruir la gema
		queue_free()

func _process(delta):
	rotation.y += rotation_speed * delta
	time_passed += delta
	position.y = initial_y + (sin(time_passed * bob_speed) * bob_height)

extends CharacterBody3D

# --- CONFIGURACIÓN DE VELOCIDADES ---
var current_speed = 5.0
const WALK_SPEED = 5.0
const RUN_SPEED = 9.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- CONFIGURACIÓN DE VIDA ---
var vida_maxima = 4
var vida_actual = 4
var es_inmune = false 

# --- REFERENCIAS A NODOS ---
@onready var head = $Head 
@onready var collision_shape = $CollisionShape3D
# Asegúrate que esta ruta sea correcta en tu escena
@onready var anim_player = $AuxScene/AnimationPlayer 

# --- HUD (Interfaz) ---
@export var contenedor_corazones : HBoxContainer 
# Nota: He quitado la variable "pantalla_game_over" porque ya no la usaremos aquí.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	actualizar_hud_vida() 

func recibir_dano(cantidad):
	if es_inmune: return
	
	vida_actual -= cantidad
	actualizar_hud_vida()
	
	# Aquí podrías poner un sonido de dolor: $SonidoDolor.play()
	
	if vida_actual <= 0:
		morir()
	else:
		inmunidad_temporal()

func actualizar_hud_vida():
	if contenedor_corazones:
		var corazones = contenedor_corazones.get_children()
		for i in range(corazones.size()):
			corazones[i].visible = i < vida_actual

func morir():
	print("El jugador ha muerto")
	
	# 1. Detenemos la física para que no se siga moviendo
	set_physics_process(false)
	
	# 2. Opcional: Efecto dramático (caída de cámara) antes de cambiar de escena
	# Hacemos que la cámara rote como si cayera al suelo
	var tween = create_tween()
	tween.tween_property(head, "rotation:z", deg_to_rad(90), 0.5)
	tween.parallel().tween_property(head, "position:y", 0.5, 0.5)
	
	# Esperamos a que termine la caida (0.5 seg) + un momento de suspenso (1.0 seg)
	await get_tree().create_timer(1.5).timeout
	
	# 3. CAMBIO DE ESCENA -> Aquí llamamos a tu pantalla de Game Over
	# IMPORTANTE: Ajusta la ruta si tu archivo está en otra carpeta
	get_tree().change_scene_to_file("res://game_over_screen.tscn")

func inmunidad_temporal():
	es_inmune = true
	# Opcional: Parpadear o feedback visual aquí
	await get_tree().create_timer(1.0).timeout 
	es_inmune = false

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# GRAVEDAD
	if not is_on_floor():
		velocity.y -= gravity * delta

	# MOVIMIENTO
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# OJO: Asegúrate de tener la tecla configurada como "Kneel" en el Mapa de Entradas
	# O cámbialo aquí a "crouch" si usaste mi guía anterior.
	var is_crouching = Input.is_action_pressed("Kneel") 
	var is_running = Input.is_action_pressed("run")
	
	if is_crouching:
		current_speed = CROUCH_SPEED
		head.position.y = lerp(head.position.y, 0.8, delta * 10)
	elif is_running: 
		current_speed = RUN_SPEED
		head.position.y = lerp(head.position.y, 1.7, delta * 10)
	else:
		current_speed = WALK_SPEED
		head.position.y = lerp(head.position.y, 1.7, delta * 10)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	_update_animations(direction, is_crouching, is_running)

func _update_animations(direction, is_crouching, is_running):
	if is_crouching:
		play_anim("Kneel") 
	elif direction != Vector3.ZERO:
		if is_running:
			play_anim("Run")
		else:
			play_anim("Walk")
	else:
		play_anim("Idle")

func play_anim(anim_name):
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name, 0.2)

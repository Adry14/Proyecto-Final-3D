extends CharacterBody3D

# --- ESTADOS ---
enum {PATRULLAR, PERSEGUIR, ATACAR}
var estado_actual = PATRULLAR

# --- CONFIGURACIÓN ---
@export var velocidad_patrulla = 2.0
@export var velocidad_persecucion = 4.5
@export var dano_ataque = 1
# Tiempo entre golpes (para que no te quite 100 vidas en un segundo)
var cooldown_ataque = 1.5 
var puede_atacar = true

# --- REFERENCIAS ---
@export var player_objetivo : CharacterBody3D
@export var ruta_patrulla_follow : PathFollow3D
@onready var anim_player = $AuxScene/AnimationPlayer
@onready var nav_agent = $NavigationAgent3D

func _physics_process(delta):
	match estado_actual:
		PATRULLAR:
			comportamiento_patrulla(delta)
		PERSEGUIR:
			comportamiento_persecucion(delta)
		ATACAR:
			comportamiento_ataque()
			
	move_and_slide()

# --- LÓGICA DE ESTADOS ---

func comportamiento_patrulla(delta):
	if ruta_patrulla_follow:
		ruta_patrulla_follow.progress += velocidad_patrulla * delta
		var destino = ruta_patrulla_follow.global_position
		dirigirse_a(destino, velocidad_patrulla)
		if anim_player: play_anim_safe("Walk")

func comportamiento_persecucion(delta):
	if player_objetivo:
		dirigirse_a(player_objetivo.global_position, velocidad_persecucion)
		if anim_player: play_anim_safe("Run")

func comportamiento_ataque():
	velocity = Vector3.ZERO
	if anim_player: play_anim_safe("Attack")
	
	# Opcional: Girar hacia el jugador mientras ataca
	if player_objetivo:
		var mirada = player_objetivo.global_position
		mirada.y = global_position.y
		look_at(mirada)

func dirigirse_a(destino_global, velocidad):
	var mirada = destino_global
	mirada.y = global_position.y
	look_at(mirada)
	var direccion = global_position.direction_to(destino_global)
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad

# Función segura para animaciones
func play_anim_safe(anim_name):
	# 1. Seguridad básica: Si no hay AnimationPlayer, no hacemos nada
	if not anim_player: return

	# 2. Verificamos si la animación REALMENTE existe
	if anim_player.has_animation(anim_name):
		if anim_player.current_animation != anim_name:
			anim_player.play(anim_name, 0.2)
			
	# 3. TRUCO: Si pedimos "Run" pero no existe, usamos "Walk" como respaldo
	elif anim_name == "Run" and anim_player.has_animation("Walk"):
		if anim_player.current_animation != "Walk":
			anim_player.play("Walk", 0.2)
			
	# 4. Si no existe ni el plan A ni el plan B, avisamos en consola (sin romper el juego)
	else:
		print("AVISO: Falta la animación '" + anim_name + "' en este enemigo.")

# --- SEÑALES DE DETECCIÓN ---

func _on_area_deteccion_body_entered(body):
	if body.is_in_group("player") or body.name == "Player":
		estado_actual = PERSEGUIR
		player_objetivo = body 

func _on_area_deteccion_body_exited(body):
	if body == player_objetivo:
		estado_actual = PATRULLAR

# --- DAÑO AL CHOCAR (LA PARTE IMPORTANTE) ---

# 1. Cuando entras en el area de ataque (esfera pequeña)
func _on_area_ataque_body_entered(body):
	if body == player_objetivo:
		estado_actual = ATACAR
		# ¡DAÑO INMEDIATO!
		intentar_hacer_dano()

# 2. Mientras te mantengas dentro, sigue intentando atacar
func _on_area_ataque_body_exited(body):
	if body == player_objetivo:
		estado_actual = PERSEGUIR

func intentar_hacer_dano():
	if puede_atacar and player_objetivo and estado_actual == ATACAR:
		if player_objetivo.has_method("recibir_dano"):
			player_objetivo.recibir_dano(dano_ataque)
			print("¡Golpe al jugador!")
			
			# Iniciar tiempo de espera para el siguiente golpe
			puede_atacar = false
			await get_tree().create_timer(cooldown_ataque).timeout
			puede_atacar = true
			
			# Si seguimos atacando, golpeamos otra vez
			if estado_actual == ATACAR:
				intentar_hacer_dano()


func _on_timer_timeout() -> void:
	$risa.play()

extends Control
# Referencia al nodo de animación. Asegúrate de que el nombre sea exacto.
@onready var anim_sprite = $AnimatedSprite2D 
@onready var audio_player = $AudioStreamPlayer

func _ready():
	# 1. MUY IMPORTANTE: Liberar el mouse. 
	# Si vienes del FPS, el mouse está oculto. Aquí lo hacemos visible de nuevo.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# 2. Iniciar la animación (Uso "Idle" porque es el nombre que vi en tu captura)
	if anim_sprite:
		anim_sprite.play("Idle")
	
	# 3. Iniciar sonido (si no tiene Autoplay activado)
	if audio_player:
		audio_player.play()
	
func _on_repetir_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")

func _on_volver_al_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://inicio.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()

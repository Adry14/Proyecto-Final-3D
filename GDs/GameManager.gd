extends Node

# Variables globales
var es_modo_dificil : bool = false 
var gemas_recolectadas : int = 0
const META_GEMAS : int = 10 # La cantidad necesaria para ganar

func agregar_gema():
	gemas_recolectadas += 1
	print("Gemas: " + str(gemas_recolectadas))
	
	# Verificar si ganamos
	if gemas_recolectadas >= META_GEMAS:
		ganar_juego()

func ganar_juego():
	print("¡Juego Terminado! ¡Ganaste!")
	# Espera un micro segundo para evitar errores de física y cambia a la pantalla de victoria
	call_deferred("cambiar_a_victoria")

func cambiar_a_victoria():
	# CAMBIA ESTA RUTA por la de tu escena de "You Win"
	get_tree().change_scene_to_file("res://win_screen.tscn")

func resetear_juego():
	gemas_recolectadas = 0
	# Reinicia la escena actual o manda al nivel 1
	get_tree().reload_current_scene()

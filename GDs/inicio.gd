extends Control

# Arrastra el nodo "Panel" (el de dificultad) aquí en el inspector
# O usa el nombre exacto si es hijo directo
@onready var panel_dificultad = $Panel 

func _ready():
	# Aseguramos que el panel de dificultad empiece oculto
	if panel_dificultad:
		panel_dificultad.visible = false

func _on_iniciar_pressed() -> void:
	# Inicia en modo normal por defecto si le dan directo a iniciar
	GameManager.es_modo_dificil = false
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")

func _on_dificultad_pressed() -> void:
	# Muestra el panel para elegir
	if panel_dificultad:
		panel_dificultad.visible = true

func _on_intrucciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu2/instrucciones.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()

# --- BOTONES DENTRO DEL PANEL DE DIFICULTAD ---
# Conecta la señal "pressed" del botón Normal a esta función
func _on_normal_pressed():
	GameManager.es_modo_dificil = false
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")

# Conecta la señal "pressed" del botón Difícil a esta función
func _on_dificil_pressed():
	GameManager.es_modo_dificil = true
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu2/Reglas.tscn")

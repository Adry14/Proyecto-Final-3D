extends Control

# --- REFERENCIAS ---
# Asegúrate de que el nombre coincida con tu nodo ColorRect en la escena del HUD
@onready var filtro_oscuro = $FiltroOscuro
# Si tu filtro está dentro de otro control, ajusta la ruta (ej: $Fondo/FiltroOscuro)

# También puedes tener aquí referencias a tu barra de vida, etc.
# @onready var barra_vida = $BarraVida 

func _ready():
	# --- LÓGICA VISUAL DEL MODO DIFÍCIL ---
	# El HUD pregunta al GameManager al iniciar: "¿Es modo difícil?"
	if GameManager.es_modo_dificil:
		if filtro_oscuro:
			filtro_oscuro.visible = true
	else:
		if filtro_oscuro:
			filtro_oscuro.visible = false
			
# (Aquí puedes dejar el resto de tu código del HUD, como actualizar etiquetas de monedas, etc.)
func _process(_delta):
	# Si tienes etiquetas de monedas, mantenlas aquí
	pass

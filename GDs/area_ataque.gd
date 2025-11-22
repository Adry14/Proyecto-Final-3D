extends Area3D

@export var cantidad_dano : int = 1

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	# Verifica si el cuerpo tiene la función "recibir_dano" (Tu Player la tiene)
	if body.has_method("recibir_dano"):
		body.recibir_dano(cantidad_dano)
		print("Jugador dañado por enemigo")

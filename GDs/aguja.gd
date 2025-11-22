extends TextureRect

# Variable para guardar al jugador
var player : Node3D = null

# AJUSTE: Cambia este 0 por 90, -90 o 180 si la aguja apunta mal.
var offset_visual = deg_to_rad(0)

func _process(delta):
	# --- 1. CORRECCIÓN DEL PIVOTE (HELICÓPTERO) ---
	# Esta línea es la que arregla el giro loco.
	# Si te sigue marcando error en "size", asegúrate de que
	# este script esté puesto en un nodo de tipo "TextureRect" (icono verde).
	pivot_offset = Vector2(124.5, 345)
	# ----------------------------------------------

	# 2. Buscar al jugador si la variable está vacía
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		return

	# 3. Calcular rotación
	# La aguja gira al contrario del jugador (-) más el ajuste visual
	var rotacion_objetivo = -player.global_rotation.y + offset_visual
	
	# 4. Aplicar giro suave
	rotation = lerp_angle(rotation, rotacion_objetivo, delta * 8.0)

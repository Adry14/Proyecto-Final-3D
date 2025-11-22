var player : Node3D = null

func _process(delta):
	# --- 1. CORRECCIÓN ANTI-HELICÓPTERO ---
	# Esto mueve el punto de giro al centro exacto de la imagen.
	# Es OBLIGATORIO para que no gire desde la esquina.
	pivot_offset = size / 2
	# ---------------------------------------

	# 2. Buscar al jugador si no lo tenemos
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		return

	# 3. Calcular la rotación objetivo (invertida para espejo)
	var rotacion_objetivo = -player.global_rotation.y
	
	# 4. Aplicar la rotación con suavizado (Lerp)
	# Esto hace que se vea profesional en lugar de instantáneo
	rotation = lerp_angle(rotation, rotacion_objetivo, delta * 8.0)

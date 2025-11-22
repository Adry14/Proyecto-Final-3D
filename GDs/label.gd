extends Label

func _process(_delta):
	# Actualiza el texto en cada frame
	text = "Gemas: " + str(GameManager.gemas_recolectadas) + " / " + str(GameManager.META_GEMAS)

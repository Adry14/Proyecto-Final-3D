extends Node3D



func _on_timer_timeout() -> void:
	$Buho.play()

func _on_timer_2_timeout() -> void:
	$Lobo.play()
func _on_timer_3_timeout() -> void:
	$Witch.play()
func _on_timer_4_timeout() -> void:
	$cell.play()
func _on_timer_5_timeout() -> void:
	$Spino.play()

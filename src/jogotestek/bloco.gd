class_name Bloco extends Area2D

signal destruido

func destruir() -> void:
	emit_signal("destruido")
	queue_free()

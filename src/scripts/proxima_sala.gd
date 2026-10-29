extends Area2D

var ativada := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if (
		body.name == "Jogador"
		and not ativada
		and not GameManager.trocando_cena
		and not GameManager.comida_coletada
	):
		ativada = true
		GameManager.mudar_cena.call_deferred(
			"res://cenas/area2.tscn",
			"Spawn"
		)

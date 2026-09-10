extends Area2D

var ativada := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("SAIDA detectou: ", body.name)
	print("trocando_cena: ", GameManager.trocando_cena)

	if body.name == "Jogador" and not ativada and not GameManager.trocando_cena:
		ativada = true
		print("ENTRANDO NA AREA 1")

		GameManager.mudar_cena.call_deferred(
			"res://cenas/area1.tscn",
			"Spawn"
		)

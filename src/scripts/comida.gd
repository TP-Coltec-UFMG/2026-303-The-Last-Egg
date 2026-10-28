extends Area2D

var coletada := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jogador" and not coletada:
		coletada = true
		GameManager.comida_coletada = true
		queue_free()

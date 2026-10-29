extends Area2D

var ativada := false
@onready var aviso: Label = $"../Label2"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Jogador" or ativada or GameManager.trocando_cena:
		return

	if not GameManager.comida_coletada:
		aviso.text = "Pegue a comida para voltar ao ninho"
		return

	ativada = true
	if GameManager.comida_coletada == true:
		GameManager.mudar_cena.call_deferred(
			"res://cenas/area3.tscn",
			"Spawn"
		)

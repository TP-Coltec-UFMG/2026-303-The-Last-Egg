extends Node2D

func _ready() -> void:
	# Se o jogador ainda não existe, cria a primeira instância
	if GameManager.jogador == null:
		var novo_jogador = preload("res://cenas/jogador.tscn").instantiate()
		var sprite = novo_jogador.get_node("AnimatedSprite2D")
		sprite.scale = Vector2(3, 3)
		
		# Registra no Singleton e adiciona à cena
		GameManager.registrar_jogador(novo_jogador)
		add_child(novo_jogador)
		novo_jogador.global_position = $Spawn.global_position
	else:
		# Se já existe (veio de outra cena), o GerenciadorCena já o inseriu aqui
		pass

extends Node2D

@onready var lista_controles: VBoxContainer = $CanvasLayer/Painel/Conteudo/Lista

func _ready() -> void:
	# Se o jogador ainda não existe, cria a primeira instância
	if GameManager.jogador == null:
		GameManager.comida_coletada = false
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

	atualizar_lista_controles()

func atualizar_lista_controles() -> void:
	var controles: Dictionary = ConfigFileHandler.controles_padrao
	var nomes_controles := ["Esquerda", "Direita", "Cima", "Baixo", "Pular", "Interagir", "Atacar"]

	for linha in lista_controles.get_children():
		linha.queue_free()

	for nome_controle in nomes_controles:
		var codigo_tecla: int = controles.get(nome_controle, KEY_UNKNOWN)
		var linha := HBoxContainer.new()
		linha.custom_minimum_size.y = 22
		lista_controles.add_child(linha)

		var nome := Label.new()
		nome.text = nome_controle
		nome.custom_minimum_size.x = 102
		linha.add_child(nome)

		var icone := TextureRect.new()
		icone.custom_minimum_size = Vector2(36, 22)
		icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icone.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icone.texture = ConfigFileHandler.obter_icone_tecla(codigo_tecla)
		linha.add_child(icone)

		if icone.texture == null:
			var texto_tecla := Label.new()
			texto_tecla.text = OS.get_keycode_string(codigo_tecla)
			linha.add_child(texto_tecla)

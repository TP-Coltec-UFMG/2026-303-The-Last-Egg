extends Node2D

func _ready() -> void:
	if GameManager.jogador == null:
		GameManager.comida_coletada = false
		var novo_jogador = preload("res://cenas/jogador.tscn").instantiate()
		var sprite = novo_jogador.get_node("AnimatedSprite2D")
		sprite.scale = Vector2(3, 3)

		GameManager.registrar_jogador(novo_jogador)
		add_child(novo_jogador)
		novo_jogador.global_position = $Spawn.global_position

	if has_node("TutorialLayer/TutorialControl/TutorialPanel/TutorialLista"):
		if not ConfigFileHandler.controles_alterados.is_connected(atualizar_lista_controles):
			ConfigFileHandler.controles_alterados.connect(atualizar_lista_controles)
		atualizar_lista_controles()

		$TutorialLayer/AvisoControlesTimer.timeout.connect(_ocultar_aviso_controles)
		$TutorialLayer/AvisoControlesTimer.start()

func atualizar_lista_controles() -> void:
	var lista: VBoxContainer = $TutorialLayer/TutorialControl/TutorialPanel/TutorialLista/ControlesLista
	for filho in lista.get_children():
		lista.remove_child(filho)
		filho.queue_free()

	var nomes_acoes := {
		"Esquerda": "Mover para esquerda",
		"Direita": "Mover para direita",
		"Cima": "Mover para cima",
		"Baixo": "Mover para baixo",
		"Pular": "Pular",
		"Atacar": "Atacar",
		"Interagir": "Interagir",
	}
	for nome_controle in nomes_acoes:
		var codigo_tecla: int = ConfigFileHandler.controles_padrao.get(nome_controle, KEY_UNKNOWN)
		var icone: Texture2D = ConfigFileHandler.obter_icone_tecla(codigo_tecla)
		var linha := HBoxContainer.new()
		linha.add_theme_constant_override("separation", 6)

		var nome_acao := Label.new()
		nome_acao.text = nomes_acoes[nome_controle]
		nome_acao.custom_minimum_size.x = 180
		nome_acao.add_theme_font_size_override("font_size", 16)
		linha.add_child(nome_acao)

		var imagem_tecla := TextureRect.new()
		imagem_tecla.custom_minimum_size = Vector2(30, 28)
		imagem_tecla.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		imagem_tecla.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		imagem_tecla.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		imagem_tecla.texture = icone if icone != null else preload("res://sprites/teclas_configuracoes/keyboard.png")
		linha.add_child(imagem_tecla)
		lista.add_child(linha)

func _ocultar_aviso_controles() -> void:
	$TutorialLayer/TutorialControl/TutorialPanel/TutorialLista/AvisoControles.hide()

func abrir_controles() -> void:
	if has_node("PauseLayer"):
		$PauseLayer.call("abrir_controles")

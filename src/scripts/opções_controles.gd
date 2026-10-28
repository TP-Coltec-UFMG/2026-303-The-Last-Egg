extends Control

var modo_pausa := false
var controle_selecionado = ""
var aguardando_tecla = false
var botoes_controle: Dictionary = {}

func _ready():
	botoes_controle = {
		"Esquerda": $MarginContainer/Controles/HBoxContainer/Esquerda,
		"Direita": $MarginContainer/Controles/HBoxContainer2/Direita,
		"Baixo": $MarginContainer/Controles/HBoxContainer3/Baixo,
		"Cima": $MarginContainer/Controles/HBoxContainer7/Cima,
		"Pular": $MarginContainer/Controles/HBoxContainer4/Pular,
		"Interagir": $MarginContainer/Controles/HBoxContainer6/Interagir,
		"Atacar": $MarginContainer/Controles/HBoxContainer8/Atacar,
	}
	atualizar_botoes()
	$MarginContainer/Controles/HBoxContainer/Esquerda.pressed.connect(
		selecionar_controle.bind("Esquerda")
	)

	$MarginContainer/Controles/HBoxContainer2/Direita.pressed.connect(
		selecionar_controle.bind("Direita")
	)

	$MarginContainer/Controles/HBoxContainer3/Baixo.pressed.connect(
		selecionar_controle.bind("Baixo")
	)

	$MarginContainer/Controles/HBoxContainer7/Cima.pressed.connect(
		selecionar_controle.bind("Cima")
	)

	$MarginContainer/Controles/HBoxContainer4/Pular.pressed.connect(
		selecionar_controle.bind("Pular")
	)

	$MarginContainer/Controles/HBoxContainer6/Interagir.pressed.connect(
		selecionar_controle.bind("Interagir")
	)

	$MarginContainer/Controles/HBoxContainer8/Atacar.pressed.connect(
		selecionar_controle.bind("Atacar")
	)
func atualizar_botoes():
	for controle in botoes_controle:
		var botao: Button = botoes_controle[controle]
		var codigo_tecla: int = ConfigFileHandler.controles_padrao[controle]
		var icone = obter_icone_tecla(codigo_tecla)

		botao.custom_minimum_size = Vector2(48, 42)
		botao.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		botao.icon = icone
		botao.expand_icon = true
		botao.tooltip_text = OS.get_keycode_string(codigo_tecla)
		botao.text = "" if icone else OS.get_keycode_string(codigo_tecla)

func obter_icone_tecla(codigo_tecla: int) -> Texture2D:
	return ConfigFileHandler.obter_icone_tecla(codigo_tecla)
	
func selecionar_controle(controle):
	controle_selecionado = controle
	aguardando_tecla = true
	
func _input(event):
	if not aguardando_tecla:
		return

	if event is InputEventKey and event.pressed:
		var nova_tecla = event.keycode

		ConfigFileHandler.alterar_controle(
			controle_selecionado,
			nova_tecla
		)

		aguardando_tecla = false
		controle_selecionado = ""

		atualizar_botoes()

		get_viewport().set_input_as_handled()
	
func _on_restaurar_pressed():
	ConfigFileHandler.restaurar_controles_padrao()
	atualizar_botoes()
	
func _on_voltar_tela_inicial_pressed():
	if modo_pausa:
		GameManager.voltar_opcoes_pausa()
		return

	get_tree().change_scene_to_file("res://cenas/opções.tscn")
	

extends Control

var controle_selecionado = ""
var aguardando_tecla = false

func _ready():
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
	$MarginContainer/Controles/HBoxContainer/Esquerda.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Esquerda"]
	)
	
	$MarginContainer/Controles/HBoxContainer2/Direita.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Direita"]
	)
	
	$MarginContainer/Controles/HBoxContainer3/Baixo.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Baixo"]
	)
	
	$MarginContainer/Controles/HBoxContainer7/Cima.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Cima"]
	)
	
	$MarginContainer/Controles/HBoxContainer4/Pular.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Pular"]
	)
	$MarginContainer/Controles/HBoxContainer6/Interagir.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Interagir"]
	)
	$MarginContainer/Controles/HBoxContainer8/Atacar.text = OS.get_keycode_string(
		ConfigFileHandler.controles_padrao["Atacar"]
	)
	
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
	get_tree().change_scene_to_file("res://cenas/opções.tscn")
	

extends Control

const CAMINHO_TECLAS := "res://sprites/teclas_configuracoes/"

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
	var nome_arquivo: String = mapa_teclas().get(codigo_tecla, "")
	if nome_arquivo.is_empty():
		return null

	return load(CAMINHO_TECLAS + nome_arquivo + ".png")

func mapa_teclas() -> Dictionary:
	var mapa := {
		KEY_0: "keyboard_0", KEY_1: "keyboard_1", KEY_2: "keyboard_2",
		KEY_3: "keyboard_3", KEY_4: "keyboard_4", KEY_5: "keyboard_5",
		KEY_6: "keyboard_6", KEY_7: "keyboard_7", KEY_8: "keyboard_8",
		KEY_9: "keyboard_9",
		KEY_A: "keyboard_a", KEY_B: "keyboard_b", KEY_C: "keyboard_c",
		KEY_D: "keyboard_d", KEY_E: "keyboard_e", KEY_F: "keyboard_f",
		KEY_G: "keyboard_g", KEY_H: "keyboard_h", KEY_I: "keyboard_i",
		KEY_J: "keyboard_j", KEY_K: "keyboard_k", KEY_L: "keyboard_l",
		KEY_M: "keyboard_m", KEY_N: "keyboard_n", KEY_O: "keyboard_o",
		KEY_P: "keyboard_p", KEY_Q: "keyboard_q", KEY_R: "keyboard_r",
		KEY_S: "keyboard_s", KEY_T: "keyboard_t", KEY_U: "keyboard_u",
		KEY_V: "keyboard_v", KEY_W: "keyboard_w", KEY_X: "keyboard_x",
		KEY_Y: "keyboard_y", KEY_Z: "keyboard_z",
		KEY_LEFT: "keyboard_arrow_left", KEY_RIGHT: "keyboard_arrow_right",
		KEY_UP: "keyboard_arrow_up", KEY_DOWN: "keyboard_arrow_down",
		KEY_SPACE: "keyboard_space", KEY_ESCAPE: "keyboard_escape",
		KEY_ENTER: "keyboard_enter", KEY_TAB: "keyboard_tab",
		KEY_BACKSPACE: "keyboard_backspace", KEY_DELETE: "keyboard_delete",
		KEY_INSERT: "keyboard_insert", KEY_HOME: "keyboard_home",
		KEY_END: "keyboard_end", KEY_PAGEUP: "keyboard_page_up",
		KEY_PAGEDOWN: "keyboard_page_down", KEY_SHIFT: "keyboard_shift",
		KEY_CTRL: "keyboard_ctrl", KEY_ALT: "keyboard_alt",
		KEY_F1: "keyboard_f1", KEY_F2: "keyboard_f2", KEY_F3: "keyboard_f3",
		KEY_F4: "keyboard_f4", KEY_F5: "keyboard_f5", KEY_F6: "keyboard_f6",
		KEY_F7: "keyboard_f7", KEY_F8: "keyboard_f8", KEY_F9: "keyboard_f9",
		KEY_F10: "keyboard_f10", KEY_F11: "keyboard_f11", KEY_F12: "keyboard_f12",
	}
	return mapa
	
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
	

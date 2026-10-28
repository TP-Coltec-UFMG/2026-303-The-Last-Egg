extends Control

var modo_pausa := false

#esse método é responsavel em receber  os valores das barras colocadas no script configfilehandler.
#(caso não tenha o conhecimento do configfilehandler, veja o script dele por favor. Eu explico tudo direitinho)
func _ready(): 
	$MarginContainer/VBoxContainer/Volume_Geral_Barra.value = ConfigFileHandler.volume_geral
	$MarginContainer/VBoxContainer/Volume_Musica_Barra.value = ConfigFileHandler.volume_musica
	$MarginContainer/VBoxContainer/Volume_Efeitos_Barra.value = ConfigFileHandler.volume_efeitos
	$MarginContainer/VBoxContainer/Daltonismo_Config.select(ConfigFileHandler.modo_daltonismo)
	$MarginContainer/VBoxContainer/AltoContraste_Linha/AltoContraste_CheckBox.button_pressed = ConfigFileHandler.modo_altocontraste

	if modo_pausa:
		$Voltar_TelaInicial.text = "Continuar"
		$Voltar_Abertura.hide()
		$Voltar_TelaInicial.position = Vector2(190, 467)
		$Voltar_TelaInicial.size = Vector2(180, 54)
		$Acessibilidade_Botao.position = Vector2(450, 467)
		$Acessibilidade_Botao.size = Vector2(250, 54)
		$Acessibilidade_Botao.text = "Controles"

		var botao_menu_principal := Button.new()
		botao_menu_principal.name = "Menu_Principal"
		botao_menu_principal.text = "Menu principal"
		botao_menu_principal.position = Vector2(745, 467)
		botao_menu_principal.size = Vector2(220, 54)
		botao_menu_principal.pressed.connect(_on_menu_principal_pressed)
		add_child(botao_menu_principal)

#os três métodos pegam os valores das barras em buses diferentes.
func _on_volume_geral_barra_value_changed(value: float):
	ConfigFileHandler.volume_geral = value #pega o volume salvado anteriomente
	ConfigFileHandler.aplicar_volumes() #aplica o volume no script
	ConfigFileHandler.salvar_config() # e dps salva

#mesma logica do método encima,porém em um bus da música.
func _on_volume_musica_barra_value_changed(value: float):
	ConfigFileHandler.volume_musica = value
	ConfigFileHandler.aplicar_volumes()
	ConfigFileHandler.salvar_config()
	
func _on_volume_efeitos_barra_value_changed(value: float):
	ConfigFileHandler.volume_efeitos = value
	ConfigFileHandler.aplicar_volumes()
	ConfigFileHandler.salvar_config()

func _on_botão_música_teste_pressed(): #teste da música
	$"MarginContainer/VBoxContainer/Botão_Música_Teste/Musica".play()
		
func _on_botão_efeitos_teste_pressed(): #teste do botão
	$"MarginContainer/VBoxContainer/Botão_Efeitos_Teste/SomDoBotão".play()
	
func _on_voltar_tela_inicial_pressed():
	if modo_pausa:
		GameManager.fechar_menu_pausa()
		return

	get_tree().change_scene_to_file("res://cenas/menu_principal.tscn")
	
func _on_voltar_abertura_pressed():
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")
	
func _on_acessibilidade_botao_pressed():
	if modo_pausa:
		GameManager.abrir_controles_pausa()
		return

	get_tree().change_scene_to_file("res://cenas/configuracao_controles.tscn")

func _on_menu_principal_pressed():
	if modo_pausa:
		GameManager.voltar_menu_principal()

func _on_daltonismo_config_item_selected(indice: int):
	ConfigFileHandler.modo_daltonismo = indice
	ConfigFileHandler.salvar_config()
	filtroglobal.aplicar_acessibilidade()


func _on_alto_contraste_check_box_toggled(toggled_on: bool):
	ConfigFileHandler.modo_altocontraste = toggled_on
	ConfigFileHandler.salvar_config()
	filtroglobal.aplicar_acessibilidade()

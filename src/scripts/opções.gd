extends Control

#esse método é responsavel em receber  os valores das barras colocadas no script configfilehandler.
#(caso não tenha o conhecimento do configfilehandler, veja o script dele por favor. Eu explico tudo direitinho)
func _ready(): 
	$MarginContainer/VBoxContainer/Volume_Geral_Barra.value = ConfigFileHandler.volume_geral
	$MarginContainer/VBoxContainer/Volume_Musica_Barra.value = ConfigFileHandler.volume_musica
	$MarginContainer/VBoxContainer/Volume_Efeitos_Barra.value = ConfigFileHandler.volume_efeitos
	$MarginContainer/VBoxContainer/Daltonismo_Config.select(ConfigFileHandler.modo_daltonismo)
	$MarginContainer/VBoxContainer/AltoContraste_CheckBox.button_pressed = ConfigFileHandler.modo_altocontraste
	

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
	get_tree().change_scene_to_file("res://cenas/menu_principal.tscn")
	
func _on_voltar_abertura_pressed():
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")
	
func _on_acessibilidade_botao_pressed():
	get_tree().change_scene_to_file("res://cenas/opções_controles.tscn")

func _on_daltonismo_config_item_selected(indice: int):
	ConfigFileHandler.modo_daltonismo = indice
	ConfigFileHandler.salvar_config()
	print("O Indice da opcao é: " + str(indice));
	filtroglobal.aplicar_acessibilidade()


func _on_alto_contraste_check_box_toggled(toggled_on: bool):
	ConfigFileHandler.modo_altocontraste = toggled_on
	ConfigFileHandler.salvar_config()
	filtroglobal.aplicar_acessibilidade()

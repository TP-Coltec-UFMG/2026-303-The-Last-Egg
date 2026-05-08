extends Control

#esse método é responsavel em receber  os valores das barras colocadas no script configfilehandler.
#(caso não tenha o conhecimento do configfilehandler, veja o script dele por favor. Eu explico tudo direitinho)

func _ready(): 
	$MarginContainer/VBoxContainer/Volume_Geral_Barra.value = ConfigFileHandler.volume_geral
	$MarginContainer/VBoxContainer/Volume_Musica_Barra.value = ConfigFileHandler.volume_musica
	$MarginContainer/VBoxContainer/Volume_Efeitos_Barra.value = ConfigFileHandler.volume_efeitos

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
	
func _on_voltar_teste_pressed(): #muda a cena atual para o menu.
	get_tree().change_scene_to_file("res://menu_principal.tscn")
	
func _on_voltar_teste_2_pressed():
	get_tree().change_scene_to_file("res://tela_inicial.tscn")
	

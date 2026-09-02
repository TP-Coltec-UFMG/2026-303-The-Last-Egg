extends Node2D
func _on_começar_pressed():
	AudioManager.tocar_som_botao()
	get_tree().change_scene_to_file("res://cenas/ninho.tscn") #muda a cena atual para outra cena carregada por arquivo

func _on_opções_pressed():
	AudioManager.tocar_som_botao()
	get_tree().change_scene_to_file("res://cenas/opções.tscn") #muda a cena atual para outra cena carregada por arquivo

func _on_sair_pressed():
	AudioManager.tocar_som_botao()
	get_tree().quit() #faça com que o jogo sai.

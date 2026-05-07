extends Node2D
func _on_começar_pressed():
	$"SomDoBotão".play()  #toca o barulho do som
	await $"SomDoBotão".finished #espera até o barulho do som acabar.
	get_tree().change_scene_to_file("res://jogotestek/breakout.tscn") #muda a cena atual para outra cena carregada por arquivo
	#!!!O JOGO É UM PLACEHOLDER. NÃO VAI SER O JOGO FINAL 

func _on_opções_pressed():
	$"SomDoBotão".play() 
	await $"SomDoBotão".finished 
	get_tree().change_scene_to_file("res://opções.tscn") #muda a cena atual para outra cena carregada por arquivo

func _on_sair_pressed():
	$"SomDoBotão".play()
	await $"SomDoBotão".finished
	get_tree().quit() #faça com que o jogo sai.

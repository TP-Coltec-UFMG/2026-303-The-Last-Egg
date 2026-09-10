extends Node2D
func _on_começar_pressed():
	$"SomDoBotão".play();
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://cenas/ninho.tscn") #muda a cena atual para outra cena carregada por arquivo

func _on_opções_pressed():
	$"SomDoBotão".play();
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://cenas/opções.tscn") #muda a cena atual para outra cena carregada por arquivo

func _on_sair_pressed():
	$"SomDoBotão".play();
	await get_tree().create_timer(0.5).timeout
	get_tree().quit() #faça com que o jogo sai.

func _on_label_mouse_entered() -> void:
	$"Button_manager/Começar/Label".modulate = Color.YELLOW

func _on_label_mouse_exited() -> void:
	$"Button_manager/Começar/Label".modulate = Color.WHITE


func _on_label_opções_mouse_entered() -> void:
	$"Button_manager/Opções/label_opções".modulate = Color.YELLOW
	
func _on_label_opções_mouse_exited() -> void:
	$"Button_manager/Opções/label_opções".modulate = Color.WHITE
	

func _on_label_sair_mouse_entered() -> void:
	$Button_manager/Sair/label_sair.modulate = Color.DARK_RED

func _on_label_sair_mouse_exited() -> void:
	$Button_manager/Sair/label_sair.modulate = Color.WHITE

extends Control

var esperando_tecla: = false
var acao_rebind: = ""


func _on_voltar_tela_inicial_pressed():
	get_tree().change_scene_to_file("res://cenas/opções.tscn")

class_name GameManager
extends Node2D

@export var texto: Label
@export var reiniciar: Button

var total_blocos: int = 0
var jogo_finalizado: bool = false

func _ready() -> void:
	texto.visible = false
	reiniciar.visible = false
	reiniciar.pressed.connect(_on_button_pressed)

func registrar_blocos(qtd: int) -> void:
	total_blocos = qtd

func remover_bloco() -> void:
	if jogo_finalizado:
		return
	
	total_blocos -= 1
	
	if total_blocos <= 0:
		vence_jogo()

func perde_jogo() -> void:
	if jogo_finalizado:
		return
	
	jogo_finalizado = true
	texto.text = "Você perdeu!!"
	mostra_tela_final()

func vence_jogo() -> void:
	if jogo_finalizado:
		return
	
	jogo_finalizado = true
	texto.text = "Você venceu!!"
	mostra_tela_final()

func mostra_tela_final() -> void:
	texto.visible = true
	reiniciar.visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

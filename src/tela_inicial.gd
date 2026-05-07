extends Node2D

@onready var animacao = $Animação_Tela_Inicial
@onready var espaço = $Espaço_Começar
@onready var musicaIntro = $Musicaintro
@onready var EfeitoNinho = $EfeitoNinho
@onready var EfeitoOvo = $EfeitoOvo
@onready var Whoosh = $Whoosh

var efeito_ninho_tocado = false
var efeito_ovo_tocado = false
var efeito_whoosh_tocado = false

func _ready():
	espaço.visible = false
	animacao.play("intro")
	animacao.frame = 0
	animacao.sprite_frames.set_animation_loop("intro", false)
	musicaIntro.play()
	
	await animacao.animation_finished
	espaço.visible = true
	
func _process(delta):
	if Input.is_action_just_pressed("Pular"):
		pular_intro()
		
	if animacao.frame == 1 and not efeito_ninho_tocado:
		EfeitoNinho.play()
		efeito_ninho_tocado = true
		
	if animacao.frame == 10:
		EfeitoNinho.stop()

	if animacao.frame == 15 and not efeito_ovo_tocado:
		EfeitoOvo.play()
		efeito_ovo_tocado = false
	
	if animacao.frame == 23 and not efeito_ovo_tocado:
		EfeitoOvo.play()
		efeito_ovo_tocado = true
		
	if animacao.frame == 25 and not efeito_whoosh_tocado:
		Whoosh.play()
		efeito_whoosh_tocado = true

func pular_intro():
	get_tree().change_scene_to_file("res://menu_principal.tscn")

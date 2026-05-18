extends Node2D

#onready para ser trabalhado mais facil
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
	espaço.visible = false #espaço é o texto que pede para o usuario apertar espaço. Está em falso para mostrar apenas no final da animação
	animacao.play("intro")
	animacao.frame = 0 #contar os frames da animação para colocar sons durante a animação
	animacao.sprite_frames.set_animation_loop("intro", false) #false para desativar o loop infinito
	musicaIntro.play()
	
	await animacao.animation_finished #espera a animação acabar
	espaço.visible = true #se acabar aparece o texto do espaço
	
func _process(delta):
	if Input.is_action_just_pressed("Pular"): #se eu pressionar pular, vai pular a intro
		pular_intro()
		
	#código mt freestyle, basicamente eu coloco os sons nos frames	
	if animacao.frame == 1 and not efeito_ninho_tocado:
		EfeitoNinho.play()
		efeito_ninho_tocado = true
	
	#e dps para de reproduzir o som
	if animacao.frame == 10:
		EfeitoNinho.stop()
	
	if animacao.frame == 15 and not efeito_ovo_tocado:
		EfeitoOvo.play()
		efeito_ovo_tocado = false #nesse caso eu coloco false,pois o ovo quicou duas vezes
	
	if animacao.frame == 23 and not efeito_ovo_tocado:
		EfeitoOvo.play()
		efeito_ovo_tocado = true
		
	if animacao.frame == 25 and not efeito_whoosh_tocado:
		Whoosh.play()
		efeito_whoosh_tocado = true

func pular_intro():
	get_tree().change_scene_to_file("res://cenas/menu_principal.tscn") #vai para outra cena.

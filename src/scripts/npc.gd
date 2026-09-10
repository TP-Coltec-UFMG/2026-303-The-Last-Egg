extends CharacterBody2D

enum Estado { PATRULHANDO, DIALOGANDO }

@export var ponto_a: Marker2D 
@export var ponto_b: Marker2D 
@export var velocidade: float = 60.0 
@export var falas: Array[String] = [ 
"Os filhotes estão com fome, pode ir lá embaixo pegar algo?", 
"Tome cuidado por favor, lá embaixo possui muitos predadores.", 
"Fique de olho em qualquer coisa." 
] 

@onready var sprite = $AnimatedSprite2D 
@onready var area_deteccao = $Area2D 
@onready var canvas_dialogo = $CanvasLayer 
@onready var label_dialogo = $CanvasLayer/PanelDialogo/LabelDialogo 
@onready var grito_emanuel = $Grito_Emanuel

var estado: Estado = Estado.PATRULHANDO 
var alvo_atual: Marker2D 
var fala_atual: int = 0 
var ja_conversou: bool = false 

func _ready(): 
	$AnimatedSprite2D.play("parado")
	sprite.frame_changed.connect(_on_sprite_frame_changed)
	alvo_atual = ponto_b 
	canvas_dialogo.visible = false 
	area_deteccao.body_entered.connect(_on_area_deteccao_body_entered) 

func _on_sprite_frame_changed() -> void:
	if estado == Estado.DIALOGANDO and sprite.frame == 3:
		grito_emanuel.play()
	
func _physics_process(_delta: float) -> void: 
	match estado: 
		#Estado.PATRULHANDO: 
			#patrulhar() 
		Estado.DIALOGANDO:
			velocity = Vector2.ZERO 
			move_and_slide() 
	
#func patrulhar(): 
	#var direcao = (alvo_atual.global_position - global_position).normalized() 
	#velocity = direcao * velocidade 
	#move_and_slide() 
	#sprite.flip_h = direcao.x < 0 
	#if global_position.distance_to(alvo_atual.global_position) < 5: 
		#alvo_atual = ponto_a if alvo_atual == ponto_b else ponto_b 

func _on_area_deteccao_body_entered(body: Node2D): 
	if body.name == "Jogador" and not ja_conversou: 
		iniciar_dialogo() 
	
func iniciar_dialogo(): 
	estado = Estado.DIALOGANDO 
	fala_atual = 0 
	canvas_dialogo.visible = true 
	mostrar_fala() 
	
func mostrar_fala(): 
	label_dialogo.text = falas[fala_atual] 

func _input(event): 
	if estado == Estado.DIALOGANDO and event.is_action_pressed("Interagir"): 
		fala_atual += 1 
	if fala_atual >= falas.size(): 
		encerrar_dialogo() 
	else:
		mostrar_fala() 
		
func encerrar_dialogo(): 
	canvas_dialogo.visible = false 
	ja_conversou = true 
	estado = Estado.PATRULHANDO 
	$CollisionShape2D.set_deferred("disabled", true)

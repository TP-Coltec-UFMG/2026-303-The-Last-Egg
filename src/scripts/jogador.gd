extends CharacterBody2D

@onready var area_ataque : Area2D = $AreaAtaque
@onready var ovos_vida: Array[Sprite2D] = [$HUD/Ovo1, $HUD/Ovo2, $HUD/Ovo3]
@onready var mensagem_morte: Label = $HUD/MensagemMorte

@export var vida: int = 3

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Tempo do Ataque (em Segundos)
var tempo_ataque : float = 1
# Se está atacando ou não
var atacando : bool = false
var invulneravel: bool = false
var morreu: bool = false

func _ready() -> void:
	GameManager.registrar_jogador(self)
	atualizar_hud()

func _physics_process(delta: float) -> void:
	if morreu:
		if Input.is_action_just_pressed("Interagir"):
			reiniciar_no_ninho()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Pega direção horizontal (-1 para esquerda, 1 para direita, 0 parado)
	var direction := Input.get_axis("Esquerda", "Direita")
	
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = (direction < 0)
		if atacando:
			$AnimatedSprite2D.play("atacar_correndo")
		if not atacando:
			$AnimatedSprite2D.play("andar")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not atacando:
			$AnimatedSprite2D.play("parado")

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if morreu:
		if event.is_action_pressed("Interagir"):
			reiniciar_no_ninho()
		return

	# Se apertou para atacar e não está atacando
	if event.is_action_pressed("Atacar") and not atacando:
		# Liga o ataque, espera o tempo do ataque e desliga o ataque
		atacar()
		
func atacar() -> void:
	$AnimatedSprite2D.play("atacar")
	atacando = true
	
	for area in area_ataque.get_overlapping_areas():
		var inimigo = area.get_parent()
		
		if inimigo != self and inimigo.has_method("dar_dano"):
			inimigo.dar_dano(1)
	
	await $AnimatedSprite2D.animation_finished
	atacando = false

func dar_dano(dano: int) -> void:
	if invulneravel:
		return

	vida -= dano
	atualizar_hud()
	invulneravel = true
	$AnimatedSprite2D.modulate = Color(1.0, 0.35, 0.35)

	if vida <= 0:
		morreu = true
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		mensagem_morte.visible = true
		return

	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(self):
		invulneravel = false
		$AnimatedSprite2D.modulate = Color.WHITE

func atualizar_hud() -> void:
	for indice in ovos_vida.size():
		ovos_vida[indice].visible = indice < vida

func reiniciar_no_ninho() -> void:
	vida = 3
	invulneravel = false
	morreu = false
	$AnimatedSprite2D.modulate = Color.WHITE
	mensagem_morte.visible = false
	atualizar_hud()
	GameManager.mudar_cena("res://cenas/ninho.tscn")
		

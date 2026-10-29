extends CharacterBody2D

@onready var area_ataque : Area2D = $AreaAtaque
@onready var ovos_vida: Array[Sprite2D] = [$HUD/Ovo1, $HUD/Ovo2, $HUD/Ovo3]
@onready var mensagem_morte: Label = $HUD/MensagemMorte
@onready var som_ataque: AudioStreamPlayer2D = $SomAtaque

@export var vida: int = 3

const SPEED = 300.0
const JUMP_VELOCITY = -450.0

# Tempo do Ataque (em Segundos)
var tempo_ataque : float = 1
# Se está atacando ou não
var atacando : bool = false
var invulneravel: bool = false
var morreu: bool = false
var geracao_invulnerabilidade: int = 0

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
	verificar_queda_na_fase()
	
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
	som_ataque.play()
	atacando = true
	mostrar_alcance_ataque(area_ataque, Color(0.55, 0.9, 1.0, 0.9))
	
	for area in area_ataque.get_overlapping_areas():
		var inimigo = area.get_parent()
		
		if inimigo != self and inimigo.has_method("dar_dano"):
			inimigo.dar_dano(1)
	
	await $AnimatedSprite2D.animation_finished
	atacando = false

func mostrar_alcance_ataque(area: Area2D, cor: Color) -> void:
	var forma := area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if forma == null:
		return

	var circulo := forma.shape as CircleShape2D
	if circulo == null:
		return

	var efeito := Line2D.new()
	efeito.width = 2.0
	efeito.default_color = cor
	efeito.z_index = 10
	efeito.position = forma.position

	var raio := circulo.radius * forma.scale.x
	var olhando_esquerda: bool = $AnimatedSprite2D.flip_h
	var angulo_inicial := PI / 2.0 if olhando_esquerda else -PI / 2.0
	for ponto in range(17):
		var angulo := angulo_inicial + PI * float(ponto) / 16.0
		efeito.add_point(Vector2(cos(angulo), sin(angulo)) * raio)

	area.add_child(efeito)
	var tween := create_tween()
	tween.tween_property(efeito, "modulate:a", 0.0, 0.2)
	tween.tween_callback(efeito.queue_free)

func verificar_queda_na_fase() -> void:
	var cena_atual := get_tree().current_scene
	if cena_atual == null or not cena_atual.has_meta("limite_queda"):
		return

	var limite_queda: float = cena_atual.get_meta("limite_queda")
	if global_position.y <= limite_queda:
		return

	var spawn := cena_atual.get_node_or_null("Spawn") as Marker2D
	if spawn == null:
		push_error("A fase com limite de queda precisa ter um Marker2D chamado Spawn.")
		return

	dar_dano(1)
	global_position = spawn.global_position
	velocity = Vector2.ZERO

func dar_dano(dano: int) -> void:
	if invulneravel:
		return

	vida -= dano
	atualizar_hud()
	$AnimatedSprite2D.modulate = Color(1.0, 0.35, 0.35)

	if vida <= 0:
		invulneravel = true
		morreu = true
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		var codigo_tecla_interagir: int = ConfigFileHandler.controles_padrao.get("Interagir", KEY_E)
		var tecla_interagir := OS.get_keycode_string(codigo_tecla_interagir)
		mensagem_morte.text = "Você morreu\nPressione (%s) para renascer" % tecla_interagir
		mensagem_morte.visible = true
		return

	ativar_invulnerabilidade(0.25)

func proteger_transicao() -> void:
	ativar_invulnerabilidade(1.0)

func ativar_invulnerabilidade(duracao: float) -> void:
	geracao_invulnerabilidade += 1
	var geracao_atual := geracao_invulnerabilidade
	invulneravel = true

	await get_tree().create_timer(duracao).timeout
	if is_instance_valid(self) and geracao_atual == geracao_invulnerabilidade:
		invulneravel = false
		$AnimatedSprite2D.modulate = Color.WHITE

func atualizar_hud() -> void:
	for indice in ovos_vida.size():
		ovos_vida[indice].visible = indice < vida

func reiniciar_no_ninho() -> void:
	vida = 3
	GameManager.comida_coletada = false
	invulneravel = false
	morreu = false
	$AnimatedSprite2D.modulate = Color.WHITE
	mensagem_morte.visible = false
	atualizar_hud()
	GameManager.mudar_cena("res://cenas/ninho.tscn")
		

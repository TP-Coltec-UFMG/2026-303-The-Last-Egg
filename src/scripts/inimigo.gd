extends CharacterBody2D

@export var vida: int = 3
@export var velocidade: float = 90.0
@export var dano: int = 1
@export var intervalo_ataque: float = 1.0
@export var tempo_preparacao_ataque: float = 0.45
@export var limite_patrulha_esquerdo: float = 35.0
@export var limite_patrulha_direito: float = 465.0

var invulneravel: bool = false
var jogador: Node2D
var tempo_para_atacar: float = 0.0
var tempo_restante_preparacao: float = 0.0
var direcao_patrulha: float = 1.0
var cacando: bool = false
var preparando_ataque: bool = false
var indicador_ataque: Line2D

func _ready() -> void:
	jogador = GameManager.jogador

func _physics_process(delta: float) -> void:
	if not is_instance_valid(jogador):
		return

	if preparando_ataque:
		velocity.x = 0.0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		tempo_restante_preparacao -= delta
		if tempo_restante_preparacao <= 0.0:
			finalizar_ataque()
		return

	var jogador_corpo := jogador as CharacterBody2D
	var jogador_no_alcance := (
		jogador.global_position.x >= limite_patrulha_esquerdo
		and jogador.global_position.x <= limite_patrulha_direito
	)
	if jogador_no_alcance or (cacando and jogador_corpo != null and not jogador_corpo.is_on_floor()):
		cacando = true
	elif jogador_corpo == null or jogador_corpo.is_on_floor():
		cacando = false

	if cacando:
		var alvo_x := clampf(jogador.global_position.x, limite_patrulha_esquerdo, limite_patrulha_direito)
		var distancia_ate_alvo := absf(alvo_x - global_position.x)
		velocity.x = sign(alvo_x - global_position.x) * minf(velocidade, distancia_ate_alvo / delta)
	else:
		if global_position.x <= limite_patrulha_esquerdo:
			direcao_patrulha = 1.0
		elif global_position.x >= limite_patrulha_direito:
			direcao_patrulha = -1.0
		var limite_atual := limite_patrulha_direito if direcao_patrulha > 0 else limite_patrulha_esquerdo
		var distancia_ate_limite := absf(limite_atual - global_position.x)
		velocity.x = direcao_patrulha * minf(velocidade, distancia_ate_limite / delta)

	if not is_on_floor():
		velocity += get_gravity() * delta

	$AnimatedSprite2D.play("andar")
	if not is_zero_approx(velocity.x):
		$AnimatedSprite2D.flip_h = velocity.x > 0
	move_and_slide()

	if not cacando:
		return

	tempo_para_atacar = maxf(tempo_para_atacar - delta, 0.0)
	if tempo_para_atacar == 0.0:
		for corpo in $Hitbox.get_overlapping_bodies():
			if corpo == jogador and corpo.has_method("dar_dano"):
				iniciar_ataque()
				break

func iniciar_ataque() -> void:
	preparando_ataque = true
	tempo_restante_preparacao = tempo_preparacao_ataque
	tempo_para_atacar = intervalo_ataque
	$AnimatedSprite2D.flip_h = jogador.global_position.x > global_position.x
	indicador_ataque = mostrar_alcance_ataque($Hitbox, Color(1.0, 0.55, 0.3, 0.9))

	var aviso_tween := create_tween().set_loops(2)
	aviso_tween.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 0.45, 0.15), 0.12)
	aviso_tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.12)

	if indicador_ataque != null:
		var indicador_tween := create_tween().set_loops(2)
		indicador_tween.tween_property(indicador_ataque, "modulate:a", 0.15, 0.12)
		indicador_tween.tween_property(indicador_ataque, "modulate:a", 1.0, 0.12)

func finalizar_ataque() -> void:
	preparando_ataque = false
	for corpo in $Hitbox.get_overlapping_bodies():
		if corpo == jogador and corpo.has_method("dar_dano"):
			corpo.dar_dano(dano)
			break

	if is_instance_valid(indicador_ataque):
		indicador_ataque.queue_free()
	indicador_ataque = null

func mostrar_alcance_ataque(area: Area2D, cor: Color) -> Line2D:
	var forma := area.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if forma == null:
		return null

	var circulo := forma.shape as CircleShape2D
	if circulo == null:
		return null

	var efeito := Line2D.new()
	efeito.width = 2.0
	efeito.default_color = cor
	efeito.z_index = 10
	efeito.position = forma.position

	var raio := circulo.radius * forma.scale.x
	var olhando_esquerda: bool = not $AnimatedSprite2D.flip_h
	var angulo_inicial := PI / 2.0 if olhando_esquerda else -PI / 2.0
	for ponto in range(17):
		var angulo := angulo_inicial + PI * float(ponto) / 16.0
		efeito.add_point(Vector2(cos(angulo), sin(angulo)) * raio)

	area.add_child(efeito)
	return efeito

func dar_dano(dano: int) -> void:
	if invulneravel:
		return

	vida -= dano
	invulneravel = true
	$AnimatedSprite2D.modulate = Color(1.0, 0.35, 0.35)

	if vida <= 0:
		GameManager.tocar_som_morte_inimigo(global_position)
		$CollisionShape2D.disabled = true
		set_physics_process(false)
		$AnimatedSprite2D.play("morte")
		await $AnimatedSprite2D.animation_finished
		queue_free()
		return

	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(self):
		invulneravel = false
		$AnimatedSprite2D.modulate = Color.WHITE

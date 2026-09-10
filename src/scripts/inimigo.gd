extends CharacterBody2D

@export var vida: int = 3
@export var velocidade: float = 90.0
@export var dano: int = 1
@export var intervalo_ataque: float = 1.0

var invulneravel: bool = false
var jogador: Node2D
var tempo_para_atacar: float = 0.0

func _ready() -> void:
	jogador = GameManager.jogador

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(jogador):
		return

	tempo_para_atacar = maxf(tempo_para_atacar - _delta, 0.0)
	if tempo_para_atacar == 0.0:
		for corpo in $Hitbox.get_overlapping_bodies():
			if corpo == jogador and corpo.has_method("dar_dano"):
				corpo.dar_dano(dano)
				tempo_para_atacar = intervalo_ataque
				break

	var direcao: float = sign(jogador.global_position.x - global_position.x)

	velocity.x = direcao * velocidade
	$AnimatedSprite2D.play("andar")
	move_and_slide()

	$AnimatedSprite2D.flip_h = !(direcao < 0)

func dar_dano(dano: int) -> void:
	if invulneravel:
		return

	vida -= dano
	invulneravel = true
	$AnimatedSprite2D.modulate = Color(1.0, 0.35, 0.35)

	if vida <= 0:
		queue_free()
		return

	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(self):
		invulneravel = false
		$AnimatedSprite2D.modulate = Color.WHITE

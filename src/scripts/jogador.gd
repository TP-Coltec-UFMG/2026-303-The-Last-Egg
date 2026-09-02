extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Pega direção horizontal (-1 para esquerda, 1 para direita, 0 parado)
	var direction := Input.get_axis("Esquerda", "Direita")
	
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = (direction < 0)
		$AnimatedSprite2D.play("andar")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	move_and_slide()

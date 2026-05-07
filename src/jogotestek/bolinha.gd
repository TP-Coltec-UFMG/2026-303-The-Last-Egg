class_name Bola extends Area2D

@export var adicionar_controle: float = 5
@export var velocidade: Vector2 = Vector2(0,200)
@export var gm: GameManager

func _process(delta: float) -> void:
	self.position += velocidade * delta
	self.rotation += 5 * delta
	
	if self.position.y > get_viewport_rect().size.y and velocidade.y > 0:
		velocidade = velocidade.bounce(Vector2.UP)
		gm.perde_jogo()
	if self.position.y < 0 and velocidade.y < 0:
		velocidade = velocidade.bounce(Vector2.DOWN)
	if self.position.x > get_viewport_rect().size.x and velocidade.x > 0:
		velocidade = velocidade.bounce(Vector2.LEFT)
	if self.position.x < 0 and velocidade.x < 0:
		velocidade = velocidade.bounce(Vector2.RIGHT)
		
func _on_area_entered(area: Area2D) -> void:
	velocidade = velocidade.bounce(Vector2.UP)
	
	if area is Barra:
		var distancia = area.position - self.position
		velocidade.x -= distancia.x * adicionar_controle
		velocidade.clampf(0,200)
	
	if area is Bloco:
		area.destruir()


func _on_barra_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

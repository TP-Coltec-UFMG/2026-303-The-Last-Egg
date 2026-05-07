class_name Barra extends Area2D
@export var velocidade : float = 500

func _process(delta:float) -> void:
	if Input.is_key_pressed(KEY_RIGHT):
		self.position.x += velocidade * delta
	if Input.is_key_pressed(KEY_LEFT):
		self.position.x -= velocidade * delta
	if position.x > 967:
		self.position.x = 967
	if self.position.x < 100:
		self.position.x = 100;
		
	

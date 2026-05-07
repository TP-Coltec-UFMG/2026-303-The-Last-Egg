class_name GeradorBlocos extends Node2D

@export var cena_bloco: PackedScene
@export var gm: GameManager

var total_tijolos: int = 0

func _ready() -> void:
	var largura_tela = get_viewport_rect().size.x
	var espacamento = 100
	
	var colunas = int(largura_tela / espacamento)
	
	# Cria os blocos
	for i in range(colunas):
		for j in range(3):
			var bloco = cena_bloco.instantiate()
			add_child(bloco)
			bloco.position.x = i * espacamento
			bloco.position.y = 10 + j * espacamento
			total_tijolos += 1
			# Conecta o sinal de destruição
			bloco.destruido.connect(_on_bloco_destruido)
	
	# Registra o total de blocos no GameManager
	gm.registrar_blocos(total_tijolos)

# Chamado quando um bloco é destruído
func _on_bloco_destruido() -> void:
	gm.remover_bloco()

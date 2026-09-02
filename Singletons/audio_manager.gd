extends Node

# Pré-carrega os sons de UI para facilitar o acesso
const SOM_BOTAO = preload("res://SFX/som_do_botão.mp3")

# Função genérica para tocar qualquer áudio de UI
func tocar_som(stream: AudioStream, volume_db: float = 0.0) -> void:
	if stream == null:
		return
		
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	
	# Define o modo de áudio para UI (não afetado pelo pause do jogo)
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Adiciona ao Singleton
	add_child(player)
	player.play()
	
	# Quando o som terminar de tocar, remove o nó da memória automaticamente
	player.finished.connect(player.queue_free)

# Função de atalho específica para o clique de botão
func tocar_som_botao() -> void:
	tocar_som(SOM_BOTAO)

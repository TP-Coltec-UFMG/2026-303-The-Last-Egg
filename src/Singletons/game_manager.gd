extends Node

var jogador: Node2D = null

func registrar_jogador(node_jogador: Node2D) -> void:
	jogador = node_jogador

func mudar_cena(caminho_nova_cena: String, nome_spawn_ponto: String = "Spawn") -> void:
	if jogador == null:
		get_tree().change_scene_to_file(caminho_nova_cena)
		return

	# 1. Remove o jogador da cena atual para NÃO ser destruído
	if jogador.get_parent():
		jogador.get_parent().remove_child(jogador)

	# 2. Carrega a nova cena
	var nova_cena_packed = load(caminho_nova_cena)
	var nova_cena = nova_cena_packed.instantiate()

	# 3. Adiciona o jogador na nova cena e posiciona no Spawn
	var spawn_ponto = nova_cena.get_node_or_null(nome_spawn_ponto)
	if spawn_ponto:
		jogador.global_position = spawn_ponto.global_position

	nova_cena.add_child(jogador)

	# 4. Substitui a cena principal na Tree
	var cena_atual = get_tree().current_scene
	get_tree().root.add_child(nova_cena)
	get_tree().current_scene = nova_cena
	cena_atual.queue_free()

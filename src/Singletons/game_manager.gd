extends Node

var jogador: Node2D = null
var trocando_cena := false
var portais_bloqueados := false

func registrar_jogador(node_jogador: Node2D) -> void:
	jogador = node_jogador

func mudar_cena(caminho_nova_cena: String, nome_spawn_ponto: String = "Spawn") -> void:

	if trocando_cena:
		return

	trocando_cena = true
	portais_bloqueados = true

	if jogador == null:
		get_tree().change_scene_to_file(caminho_nova_cena)
		trocando_cena = false
		return

	var cena_atual = get_tree().current_scene

	if jogador.get_parent():
		jogador.get_parent().remove_child(jogador)

	var nova_cena = load(caminho_nova_cena).instantiate()

	get_tree().root.add_child(nova_cena)
	get_tree().current_scene = nova_cena

	nova_cena.add_child(jogador)

	var spawn_ponto = nova_cena.get_node_or_null(nome_spawn_ponto)

	if spawn_ponto:
		jogador.global_position = spawn_ponto.global_position
		print("Jogador colocado em: ", jogador.global_position)

	cena_atual.queue_free()

	await get_tree().physics_frame

	trocando_cena = false
	portais_bloqueados = false

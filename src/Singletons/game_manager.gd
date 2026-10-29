extends Node

const CENA_OPCOES_PAUSA: PackedScene = preload("res://cenas/opções.tscn")
const CENA_CONTROLES_PAUSA: PackedScene = preload("res://cenas/configuracao_controles.tscn")
const SOM_MORTE_INIMIGO: AudioStream = preload("res://SFX/som_morte_inimigo.mp3")
const MUSICA_AREAS: AudioStreamMP3 = preload("res://música/musica_areas.mp3")
const MUSICA_NINHO_BOSS: AudioStreamMP3 = preload("res://música/musica_ninho_boss.mp3")
const MUSICA_VITORIA: AudioStreamMP3 = preload("res://música/musica_vitoria.mp3")

var jogador: Node2D = null
var trocando_cena := false
var portais_bloqueados := false
var comida_coletada := false
var menu_pausa: CanvasLayer = null
var reprodutor_musica: AudioStreamPlayer
var faixa_musica_areas: AudioStreamMP3
var faixa_musica_ninho_boss: AudioStreamMP3
var faixa_musica_vitoria: AudioStreamMP3
var musica_atual := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reprodutor_musica = AudioStreamPlayer.new()
	reprodutor_musica.name = "MusicaAreas"
	faixa_musica_areas = MUSICA_AREAS.duplicate() as AudioStreamMP3
	faixa_musica_areas.loop = true
	faixa_musica_ninho_boss = MUSICA_NINHO_BOSS.duplicate() as AudioStreamMP3
	faixa_musica_ninho_boss.loop = true
	faixa_musica_vitoria = MUSICA_VITORIA.duplicate() as AudioStreamMP3
	faixa_musica_vitoria.loop = false
	reprodutor_musica.stream = faixa_musica_areas
	reprodutor_musica.bus = "Musica"
	reprodutor_musica.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(reprodutor_musica)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	var tecla := event as InputEventKey
	if tecla.keycode != KEY_ESCAPE or not tecla.pressed or tecla.echo:
		return

	if is_instance_valid(menu_pausa):
		fechar_menu_pausa()
	elif is_instance_valid(jogador) and jogador.is_inside_tree():
		abrir_menu_pausa()

	get_viewport().set_input_as_handled()

func abrir_menu_pausa() -> void:
	if is_instance_valid(menu_pausa):
		return

	get_tree().paused = true
	_mostrar_tela_pausa(CENA_OPCOES_PAUSA)

func abrir_controles_pausa() -> void:
	_mostrar_tela_pausa(CENA_CONTROLES_PAUSA)

func voltar_opcoes_pausa() -> void:
	_mostrar_tela_pausa(CENA_OPCOES_PAUSA)

func voltar_menu_principal() -> void:
	get_tree().paused = false
	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()
	menu_pausa = null
	jogador = null
	comida_coletada = false
	portais_bloqueados = false
	trocando_cena = false

	var erro := get_tree().change_scene_to_file("res://cenas/menu_principal.tscn")
	if erro != OK:
		push_error("Não foi possível voltar ao menu principal: %s" % error_string(erro))
	else:
		_atualizar_musica_cena("res://cenas/menu_principal.tscn")

func fechar_menu_pausa() -> void:
	get_tree().paused = false
	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()
	menu_pausa = null

func _mostrar_tela_pausa(cena: PackedScene) -> void:
	if is_instance_valid(menu_pausa):
		menu_pausa.queue_free()

	var tela := cena.instantiate() as Control
	if tela == null:
		push_error("A tela de pausa precisa ter um nó Control como raiz.")
		return

	tela.set("modo_pausa", true)
	tela.process_mode = Node.PROCESS_MODE_ALWAYS

	var fundo := ColorRect.new()
	fundo.color = Color(0.0, 0.0, 0.0, 0.72)
	fundo.mouse_filter = Control.MOUSE_FILTER_STOP
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tela.add_child(fundo)
	tela.move_child(fundo, 0)

	var camada := CanvasLayer.new()
	camada.layer = 100
	camada.process_mode = Node.PROCESS_MODE_ALWAYS
	camada.add_child(tela)
	get_tree().root.add_child(camada)
	menu_pausa = camada

func registrar_jogador(node_jogador: Node2D) -> void:
	jogador = node_jogador

func _atualizar_musica_cena(caminho_cena: String) -> void:
	var proxima_musica := ""
	var proxima_faixa := faixa_musica_areas
	if caminho_cena == "res://cenas/ninho_boss.tscn":
		proxima_musica = "ninho_boss"
		proxima_faixa = faixa_musica_ninho_boss
	elif caminho_cena in [
		"res://cenas/area1.tscn",
		"res://cenas/area2.tscn",
		"res://cenas/area3.tscn",
		"res://cenas/ninho.tscn",
	]:
		proxima_musica = "areas"
		proxima_faixa = faixa_musica_areas

	reprodutor_musica.volume_db = linear_to_db(0.7) if proxima_musica == "ninho_boss" else 0.0

	if proxima_musica == musica_atual:
		return

	if reprodutor_musica.playing:
		reprodutor_musica.stop()
	musica_atual = proxima_musica
	if proxima_musica != "":
		reprodutor_musica.stream = proxima_faixa
		reprodutor_musica.play()

func tocar_musica_vitoria() -> void:
	if musica_atual == "vitoria":
		return

	if reprodutor_musica.playing:
		reprodutor_musica.stop()
	reprodutor_musica.stream = faixa_musica_vitoria
	reprodutor_musica.volume_db = 0.0
	musica_atual = "vitoria"
	reprodutor_musica.play()

func tocar_som_morte_inimigo(posicao: Vector2) -> void:
	var cena_atual := get_tree().current_scene
	if cena_atual == null:
		push_error("Não foi possível tocar o som de morte sem uma cena ativa.")
		return

	var reprodutor := AudioStreamPlayer2D.new()
	reprodutor.stream = SOM_MORTE_INIMIGO
	reprodutor.bus = "Efeitos"
	cena_atual.add_child(reprodutor)
	reprodutor.global_position = posicao
	reprodutor.finished.connect(reprodutor.queue_free)
	reprodutor.play()

func mudar_cena(caminho_nova_cena: String, nome_spawn_ponto: String = "Spawn") -> void:

	if trocando_cena:
		return

	trocando_cena = true
	portais_bloqueados = true

	if jogador == null:
		var erro := get_tree().change_scene_to_file(caminho_nova_cena)
		if erro != OK:
			push_error("Não foi possível mudar de cena: %s" % error_string(erro))
			trocando_cena = false
			return
		_atualizar_musica_cena(caminho_nova_cena)
		trocando_cena = false
		return

	var cena_atual = get_tree().current_scene

	if jogador.get_parent():
		jogador.get_parent().remove_child(jogador)

	var nova_cena = load(caminho_nova_cena).instantiate()
	var spawn_ponto = nova_cena.get_node_or_null(nome_spawn_ponto)

	if spawn_ponto:
		jogador.global_position = spawn_ponto.position
		jogador.velocity = Vector2.ZERO

	get_tree().root.add_child(nova_cena)
	get_tree().current_scene = nova_cena
	_atualizar_musica_cena(caminho_nova_cena)

	nova_cena.add_child(jogador)

	if spawn_ponto:
		jogador.global_position = spawn_ponto.global_position
		jogador.velocity = Vector2.ZERO
		print("Jogador colocado em: ", jogador.global_position)

	if jogador.has_method("proteger_transicao"):
		jogador.proteger_transicao()

	cena_atual.queue_free()

	await get_tree().physics_frame

	trocando_cena = false
	portais_bloqueados = false

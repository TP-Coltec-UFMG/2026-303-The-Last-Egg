extends Node

signal controles_alterados

const CAMINHO_TECLAS := "res://sprites/teclas_configuracoes/"

#* Esse arquivo é um script singleton,
# ou seja, ele funciona globalmente no jogo inteiro
# e pode ser acessado por qualquer cena. * 
#Exemplificando: Ele esta onipresente em todos os arquivos,porém não possui uma aparencia propria no programa. *feels the aura*

var config = ConfigFile.new() #inicialmente ele cria um objeto do tipo ConfigFile 
const CONFIGURACOES_CAMINHO_ARQUIVO = "user://settings.ini" 
# Para armazenar arquivos do usuário, como saves e configurações.
#obs: "user://" é uma pasta criada automaticamente pelo Godot


#inicializa o volume em 0.5. Os valores do sons são trabalhados nas barras que possuem um range de 0 a 1. 0.5 deixa a música na metade.
var volume_geral = 0.5 
var volume_musica = 0.5
var volume_efeitos = 0.5

#Os buses possuem indices internos usado pelo som.
#Toda vez que eu quero trabalhar como algum tipo de música especifica, eu pego o índice do bus. Isso funciona com modo_daltonismo tbm.
#OBS: bus = canal de aúdio.

#inicializa o modo daltonico desligado
var modo_daltonismo = 0

#inicializa o modo alto contraste desligado
var modo_altocontraste = false;

#teclas padrão do jogo
var controles_padrao = {
	"Esquerda": KEY_LEFT,
	"Direita": KEY_RIGHT,
	"Baixo": KEY_DOWN,
	"Cima": KEY_UP,
	"Pular": KEY_Z,
	"Atacar": KEY_X,
	"Interagir": KEY_E,
}

const controles_originais = {
	"Esquerda": KEY_LEFT,
	"Direita": KEY_RIGHT,
	"Baixo": KEY_DOWN,
	"Cima": KEY_UP,
	"Pular": KEY_Z,
	"Atacar": KEY_X,
	"Interagir": KEY_E,
}

var volume_geral_indice = AudioServer.get_bus_index("Master") 
var volume_musica_indice = AudioServer.get_bus_index("Musica")
var volume_efeitos_indice = AudioServer.get_bus_index("Efeitos")

func _ready(): 
	carregar_config_geral() 
	aplicar_volumes()
	aplicar_controles()

func carregar_config_geral(): #método responsavel para verificar se o arquivo existe e carrega os valores atribuidos na classe opcoes.
	if FileAccess.file_exists(CONFIGURACOES_CAMINHO_ARQUIVO): #verifica se o arquivo existe
		config.load(CONFIGURACOES_CAMINHO_ARQUIVO) #carrega o arquivo com todos os valores definidos pelo proprio usuario.
		volume_geral = config.get_value("audio", "geral", volume_geral)
		volume_musica = config.get_value("audio", "musica", volume_musica)
		volume_efeitos = config.get_value("audio", "efeitos", volume_efeitos)
		modo_daltonismo = config.get_value("acessibilidade","daltonismo", modo_daltonismo)
		modo_altocontraste = config.get_value("acessibilidade","altocontraste", modo_altocontraste)
		for controle in controles_padrao: #for das keys para controles 
			controles_padrao[controle] = config.get_value("controles",controle,controles_padrao[controle]) #colocar a secção "controles" para o arquivo controle e depois vai guardar o valor

	else: #se não existir, vai salvar como padrão do jogo
		salvar_config()
		
func salvar_config(): #padrão do jogo 
	config.set_value("audio", "geral", volume_geral) 
	config.set_value("audio", "musica", volume_musica)
	config.set_value("audio", "efeitos", volume_efeitos)
	config.set_value("acessibilidade","daltonismo", modo_daltonismo)
	config.set_value("acessibilidade","altocontraste", modo_altocontraste)
	for controle in controles_padrao: #for das keys para controles 
		config.set_value("controles",controle,controles_padrao[controle]) #vai pegar cada indice das keys e dps salva-las
	config.save(CONFIGURACOES_CAMINHO_ARQUIVO) #no fim salva todas as configuraçãos padrões.

func aplicar_volumes(): #aqui que a magica dos sons funciona 
#converte os valores lineares das barras em decibeis e dps aplica no volume no bus.
	AudioServer.set_bus_volume_db(volume_geral_indice, linear_to_db(volume_geral))
	AudioServer.set_bus_volume_db(volume_musica_indice, linear_to_db(volume_musica))
	AudioServer.set_bus_volume_db(volume_efeitos_indice, linear_to_db(volume_efeitos))
	
func aplicar_controles():
	for controle in controles_padrao: #for das keys para controles 
		var evento = InputEventKey.new() #cria um evento para cada key
		evento.keycode = controles_padrao[controle] #coloca a tecla salva naquele evento
		InputMap.action_erase_events(controle) #remove a tecla antiga 
		InputMap.action_add_event(controle, evento) #e dps adiciona 

func alterar_controle(controle, nova_tecla):
	controles_padrao[controle] = nova_tecla
	salvar_config()
	aplicar_controles()
	controles_alterados.emit()

func restaurar_controles_padrao():
	for controle in controles_originais:
		controles_padrao[controle] = controles_originais[controle]
	salvar_config()
	aplicar_controles()
	controles_alterados.emit()

func obter_icone_tecla(codigo_tecla: int) -> Texture2D:
	var nome_arquivo: String = mapa_teclas().get(codigo_tecla, "")
	if nome_arquivo.is_empty():
		return null

	return load(CAMINHO_TECLAS + nome_arquivo + ".png")

func mapa_teclas() -> Dictionary:
	return {
		KEY_0: "keyboard_0", KEY_1: "keyboard_1", KEY_2: "keyboard_2",
		KEY_3: "keyboard_3", KEY_4: "keyboard_4", KEY_5: "keyboard_5",
		KEY_6: "keyboard_6", KEY_7: "keyboard_7", KEY_8: "keyboard_8",
		KEY_9: "keyboard_9",
		KEY_A: "keyboard_a", KEY_B: "keyboard_b", KEY_C: "keyboard_c",
		KEY_D: "keyboard_d", KEY_E: "keyboard_e", KEY_F: "keyboard_f",
		KEY_G: "keyboard_g", KEY_H: "keyboard_h", KEY_I: "keyboard_i",
		KEY_J: "keyboard_j", KEY_K: "keyboard_k", KEY_L: "keyboard_l",
		KEY_M: "keyboard_m", KEY_N: "keyboard_n", KEY_O: "keyboard_o",
		KEY_P: "keyboard_p", KEY_Q: "keyboard_q", KEY_R: "keyboard_r",
		KEY_S: "keyboard_s", KEY_T: "keyboard_t", KEY_U: "keyboard_u",
		KEY_V: "keyboard_v", KEY_W: "keyboard_w", KEY_X: "keyboard_x",
		KEY_Y: "keyboard_y", KEY_Z: "keyboard_z",
		KEY_LEFT: "keyboard_arrow_left", KEY_RIGHT: "keyboard_arrow_right",
		KEY_UP: "keyboard_arrow_up", KEY_DOWN: "keyboard_arrow_down",
		KEY_SPACE: "keyboard_space", KEY_ESCAPE: "keyboard_escape",
		KEY_ENTER: "keyboard_enter", KEY_TAB: "keyboard_tab",
		KEY_BACKSPACE: "keyboard_backspace", KEY_DELETE: "keyboard_delete",
		KEY_INSERT: "keyboard_insert", KEY_HOME: "keyboard_home",
		KEY_END: "keyboard_end", KEY_PAGEUP: "keyboard_page_up",
		KEY_PAGEDOWN: "keyboard_page_down", KEY_SHIFT: "keyboard_shift",
		KEY_CTRL: "keyboard_ctrl", KEY_ALT: "keyboard_alt",
		KEY_F1: "keyboard_f1", KEY_F2: "keyboard_f2", KEY_F3: "keyboard_f3",
		KEY_F4: "keyboard_f4", KEY_F5: "keyboard_f5", KEY_F6: "keyboard_f6",
		KEY_F7: "keyboard_f7", KEY_F8: "keyboard_f8", KEY_F9: "keyboard_f9",
		KEY_F10: "keyboard_f10", KEY_F11: "keyboard_f11", KEY_F12: "keyboard_f12",
	}

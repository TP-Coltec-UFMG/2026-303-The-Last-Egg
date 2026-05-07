extends Node

#* Esse arquivo é um script singleton,
# ou seja, ele funciona globalmente no jogo inteiro
# e pode ser acessado por qualquer cena. * 
#OBS: Ele esta onipresente em todos os arquivos,porém não possui uma aparencia propria. *feels the aura*

var config = ConfigFile.new() #inicialmente ele cria um objeto do tipo ConfigFile 
const CONFIGURACOES_CAMINHO_ARQUIVO = "user://settings.ini" 
# Para armazenar arquivos do usuário, como saves e configurações.
#obs: "user://" é uma pasta criada automaticamente pelo Godot


#inicializa o volume em 0.5. Os valores do sons são trabalhados nas barras que possuem um range de 0 a 1. 0.5 deixa a música na metade.
var volume_geral = 0.5 
var volume_musica = 0.5
var volume_efeitos = 0.5

#Os buses possuem indices internos usado pelo som.
#Toda vez que eu quero trabalhar como algum tipo de música especifica, eu pego o índice do bus.
#OBS: bus = canal de aúdio.

var volume_geral_indice = AudioServer.get_bus_index("Master") 
var volume_musica_indice = AudioServer.get_bus_index("Musica")
var volume_efeitos_indice = AudioServer.get_bus_index("Efeitos")

func _ready(): 
	carregar_config_som() 
	aplicar_volumes()

func carregar_config_som(): #método responsavel para verificar se o arquivo existe e carrega os valores do som 
	if FileAccess.file_exists(CONFIGURACOES_CAMINHO_ARQUIVO): #verifica se o arquivo existe
		config.load(CONFIGURACOES_CAMINHO_ARQUIVO) #carrega o arquivo com todos os valores definidos pelo proprio usuario.
		volume_geral = config.get_value("audio", "geral", volume_geral)
		volume_musica = config.get_value("audio", "musica", volume_musica)
		volume_efeitos = config.get_value("audio", "efeitos", volume_efeitos)
	else: #se não existir, vai salvar como padrão de 0.5 em tudo
		salvar_config()
		
func salvar_config(): #vai salvar como padrão de 0.5 em tudo
	config.set_value("audio", "geral", volume_geral) 
	config.set_value("audio", "musica", volume_musica)
	config.set_value("audio", "efeitos", volume_efeitos)
	config.save(CONFIGURACOES_CAMINHO_ARQUIVO) #no fim salva todas as configuraçãos padrões.

func aplicar_volumes(): #aqui que a magica dos sons funciona 
#Esse método pega os valores das barras (expliquei na linha 19), 
#converte os valores lineares das barras em decibeis e dps aplica no volume no bus.

	AudioServer.set_bus_volume_db(volume_geral_indice, linear_to_db(volume_geral))
	
	AudioServer.set_bus_volume_db(volume_musica_indice, linear_to_db(volume_musica))
	
	AudioServer.set_bus_volume_db(volume_efeitos_indice, linear_to_db(volume_efeitos))

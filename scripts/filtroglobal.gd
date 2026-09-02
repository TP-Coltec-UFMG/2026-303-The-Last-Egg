extends Control

@onready var modo_acessibilidade = $CanvasLayer/modo_acessibilidade

func aplicar_acessibilidade():
	modo_acessibilidade.material.set_shader_parameter("filter_mode",ConfigFileHandler.modo_daltonismo)
	modo_acessibilidade.material.set_shader_parameter("high_contrast",ConfigFileHandler.modo_altocontraste)
func _ready():
	aplicar_acessibilidade()

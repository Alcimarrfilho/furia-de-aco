extends Area2D

@export var proxima_fase: String = ""
@export var moedas_necessarias: int = 4

@onready var tela_vitoria = $"../CanvasLayer/TelaVitoria"
@onready var tela_aviso = $"../CanvasLayer/TelaAviso" # Ele vai procurar esse nome no CanvasLayer

func _ready():
	get_tree().paused = false
	tela_vitoria.visible = false
	tela_aviso.visible = false

func _on_body_entered(body):
	if body.name == "cavaleiro":
		if Global.moedas >= moedas_necessarias:
			Global.moedas = 0
			tela_vitoria.visible = true
			get_tree().paused = true
		else:
			tela_aviso.visible = true
			get_tree().paused = true

# SINAL DO BOTÃO VOLTAR DA TELA DE AVISO
func _on_botao_voltar_pressed():
	get_tree().paused = false
	tela_aviso.visible = false

# SINAIS DA TELA DE VITÓRIA 
func _on_botao_proxima_fase_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(proxima_fase)

func _on_botao_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
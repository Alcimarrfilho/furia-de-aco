extends Control

@onready var menu_botoes = $MenuBotoes
@onready var painel_controles = $PainelControles 
@onready var painel_audio = $PainelAudio         

func _ready():
	menu_botoes.grab_focus()
	painel_controles.visible = false
	painel_audio.visible = false

# AÇÃO DOS BOTÕES PRINCIPAIS 

func _on_botao_iniciar_pressed():
	get_tree().change_scene_to_file("res://Fase1.tscn")

func _on_botao_controles_pressed():
	painel_controles.visible = true 

func _on_botao_volume_pressed():
	painel_audio.visible = true 

func _on_abrir_documento_pressed():
	OS.shell_open("https://drive.google.com/file/d/1XdWA0upt2mvzzWbITkVdO-kSEX-eGuM6/view?usp=sharing")

#  AÇÃO DOS BOTÕES DE FECHAR 

func _on_fechar_audio_pressed():
	painel_audio.visible = false 
func _on_fechar_controles_pressed():
	painel_controles.visible = false 

# CONTROLE DINÂMICO DE VOLUME 

func _on_slider_volume_value_changed(value):
	if value <= -40:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, value) 
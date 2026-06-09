extends Control

@onready var menu_botoes = $MenuBotoes

func _ready():
	menu_botoes.grab_focus()

# AÇÃO DOS BOTÕES

func _on_botao_iniciar_pressed():
	get_tree().change_scene_to_file("res://Fase1.tscn")

func _on_botao_controles_pressed():
	print("Abrir menu de controles")

func _on_botao_volume_pressed():
	print("Abrir menu de volume")

func _on_botao_abrir_gdd_pressed():
	OS.shell_open("https://drive.google.com/file/d/1XdWA0upt2mvzzWbITkVdO-kSEX-eGuM6/view?usp=sharing")
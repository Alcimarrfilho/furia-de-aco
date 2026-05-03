extends CanvasLayer

# Puxando os nós dos corações para o código
@onready var coracao_1 = $HBoxContainer/Coracao1
@onready var coracao_2 = $HBoxContainer/Coracao2
@onready var coracao_3 = $HBoxContainer/Coracao3

# A função _process roda o tempo todo, atualizando a tela
func _process(delta):
	# O coração só fica visível se a vida for maior ou igual ao número dele
	coracao_1.visible = Global.vidas >= 1
	coracao_2.visible = Global.vidas >= 2
	coracao_3.visible = Global.vidas >= 3
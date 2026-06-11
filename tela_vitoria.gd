extends Control

# Conecte o sinal pressed() do botão "Jogar Novamente" ou "Menu"
func _on_botao_menu_pressed() -> void:
	get_tree().paused = false # NUNCA esqueça de despausar antes de mudar de tela!
	get_tree().change_scene_to_file("res://menu_principal.tscn") 

# Se tiver um botão para ir direto para uma "Fase 4", use este:
func _on_botao_proxima_fase_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Fase3.tscn") # Coloque o caminho da próxima fase aqui
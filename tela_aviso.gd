extends Control # (Mude para ColorRect ou Panel se o seu nó raiz for um deles)

# Conecte o sinal pressed() do botão "OK" aqui
func _on_botao_ok_pressed() -> void:
	hide() # Esconde a tela de aviso
	get_tree().paused = false # Despausa o jogo pro cavaleiro voltar a andar
extends Panel

func _on_botao_tentar_novamente_pressed():
    get_tree().paused = false             # Descongela o jogo
    get_tree().reload_current_scene()     # Recarrega a fase atual do zero
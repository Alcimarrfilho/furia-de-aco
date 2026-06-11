extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "cavaleiro":
		
		# O TRUQUE: A gente tira a vida direto da variável, ignorando a função que estava falhando!
		Global.vidas -= 1
		
		# SE ZERAR: Repõe os 3 corações e ZERA AS MOEDAS para o recomeço!
		if Global.vidas <= 0:
			Global.vidas = 3
			Global.moedas = 0
		# Recarrega a fase com segurança sem dar aquele erro vermelho
		get_tree().call_deferred("reload_current_scene")

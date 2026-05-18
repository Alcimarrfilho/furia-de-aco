extends Node2D

# Referências aos nós
@onready var ponto_retorno = $PontoRetorno

func _on_sensor_buraco_body_entered(body):
	# Só executa o código se o corpo for o cavaleiro
	if body.name == "cavaleiro_cena_3":
		
		# Tira 1 de vida
		body.vidas -= 1
		print("Vidas restantes: ", body.vidas)
		
		if body.vidas > 0:
			# Se ainda tem vida, teletransporta ele de volta pro Ponto de Retorno
			body.global_position = ponto_retorno.global_position
			body.velocity.y = 0 # Zera a velocidade de queda pra ele pousar suave
		else:
			# Se a vida chegou a zero, reinicia a fase toda (Game Over)
			print("Game Over! Reiniciando a fase...")
			get_tree().reload_current_scene()
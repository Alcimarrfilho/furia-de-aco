extends Area2D

# Isso cria uma caixinha no Inspetor para você arrastar o seu Ponto de Retorno!
@export var ponto_de_retorno: Node2D

func _on_body_entered(body):
	# Verifica se quem encostou no buraco foi o cavaleiro
	if body.name == "CharacterBody2D":
		
		# Tira 1 coração
		Global.vidas -= 1
		
		# Se ele ainda tem vidas sobrando...
		if Global.vidas > 0:
			# Verifica se você conectou o ponto no Inspetor para não dar erro
			if ponto_de_retorno != null:
				# TELETRANSPORTE: Muda a posição do cavaleiro para a posição do ponto
				body.global_position = ponto_de_retorno.global_position
				
				# Zera a velocidade de queda dele, senão ele vai teleportar e continuar caindo feito uma pedra
				body.velocity = Vector2.ZERO 
			else:
				print("Aviso: Você esqueceu de ligar o Ponto de Retorno no Inspetor!")
				
		# Se as vidas chegaram a zero (Game Over)...
		else:
			# Devolve as 3 vidas e aí sim recarrega a fase inteira
			Global.vidas = 3
			get_tree().reload_current_scene()
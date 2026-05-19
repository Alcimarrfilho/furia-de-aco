extends Node2D


@onready var ponto_retorno = $pontoretorno1

# função vai cuidar do SENSOR 1
func _on_sensorburaco_1_body_entered(body):
	_processar_queda_no_buraco(body)

# função vai cuidar do SENSOR 2 (Caso você crie o segundo depois)
func _on_sensorburaco_2_body_entered(body):
	_processar_queda_no_buraco(body)


# FUNÇÃO QUE FAZ O TELETRANSPORTE 
func _processar_queda_no_buraco(body):
	print("DEBUG: Algo caiu no buraco! Nome do objeto: ", body.name)
	
	# Identifica o seu cavaleiro independente do nome dele
	if "cavaleiro" in body.name or body.name == "CharacterBody2D" or body.is_in_group("jogador"):
		
		body.vidas -= 1
		print("Vidas restantes: ", body.vidas)
		
		if body.vidas > 0:
			# O call_deferred força o Godot 4 a aceitar o teletransporte sem travar a física
			body.call_deferred("set_global_position", ponto_retorno.global_position)
			body.velocity = Vector2.ZERO # Zera a velocidade para ele não brotar caindo rápido
		else:
			print("Game Over! Reiniciando a fase...")
			body.vidas = 3
			get_tree().reload_current_scene()
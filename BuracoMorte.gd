extends Area2D

# Cria a caixinha no Inspetor para o Ponto de Retorno
@export var ponto_de_retorno: Node2D

# Pegamos a referência do HUD para atualizar os corações na tela
@onready var hud = $"../CanvasLayer/HUD"

func _on_body_entered(body):
	# Verifica se quem encostou no buraco foi o cavaleiro
	if body.name == "cavaleiro":
		
		# Tira 1 coração do sistema global
		Global.vidas -= 1
		
		if hud:
			hud.atualizar_coracoes(Global.vidas)
		
		if Global.vidas > 0:
			# Verifica se conectou o ponto no Inspetor
			if ponto_de_retorno != null:
				# Muda a posição do cavaleiro para a posição do ponto
				body.global_position = ponto_de_retorno.global_position
				
				body.velocity = Vector2.ZERO 
			else:
				print("Aviso: Você esqueceu de ligar o Ponto de Retorno no Inspetor!")
				
		# Se as vidas chegaram a zero 
		else:
			pass

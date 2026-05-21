extends Node2D

@onready var ponto1 = $pontoretorno1
@onready var ponto2 = $pontoretorno2
@onready var hud = $HUD

# CONEXÕES DOS SENSORES 

func _on_sensorburaco1_body_entered(body):
	print("DEBUG: Algo entrou no BURACO 1! Nome: ", body.name)
	_processar_queda_no_buraco(body, ponto1)

func _on_sensorburaco2_body_entered(body):
	print("DEBUG: Algo entrou no BURACO 2! Nome: ", body.name)
	_processar_queda_no_buraco(body, ponto2)


# LÓGICA CENTRAL DE QUEDA

func _processar_queda_no_buraco(body, ponto_de_destino):
	if "vidas" in body:
		body.vidas -= 1
		print("Vidas restantes do Cavaleiro: ", body.vidas)
		
		# Força o HUD a atualizar se ele existir
		if hud and hud.has_method("atualizar_coracoes"):
			hud.atualizar_coracoes(body.vidas)
		
		if body.vidas > 0:
			# Teletransporte seguro
			body.call_deferred("set_global_position", ponto_de_destino.global_position)
			body.velocity = Vector2.ZERO 
		else:
			print("GAME OVER! Reiniciando...")
			Global.moedas = 0
			get_tree().reload_current_scene()
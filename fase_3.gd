extends Node2D

@onready var ponto1 = $pontoretorno1
@onready var ponto2 = $pontoretorno2
@onready var hud = $HUD

@onready var sensor_buraco_1 = $sensorburaco1
@onready var sensor_buraco_2 = $sensorburaco2

func _ready():
	# Garante que os sensores estão conectados via código para não dar erro
	if sensor_buraco_1:
		sensor_buraco_1.body_entered.connect(_on_sensorburaco1_body_entered)
	if sensor_buraco_2:
		sensor_buraco_2.body_entered.connect(_on_sensorburaco2_body_entered)

# CONEXÕES DOS SENSORES 

func _on_sensorburaco1_body_entered(body):
	print("DEBUG: Algo entrou no BURACO 1! Nome: ", body.name)
	_processar_queda_no_buraco(body, ponto1)

func _on_sensorburaco2_body_entered(body):
	print("DEBUG: Algo entrou no BURACO 2! Nome: ", body.name)
	_processar_queda_no_buraco(body, ponto2)


# LÓGICA CENTRAL DE QUEDA 

func _processar_queda_no_buraco(body, ponto_de_destino):
	# Verifica se quem caiu é o cavaleiro (evita que inimigos ativem o sensor)
	if body.name == "cavaleiro" or body is CharacterBody2D:
		
		# AJUSTE: Tira a vida do Global
		Global.vidas -= 1
		print("Vidas restantes do Cavaleiro: ", Global.vidas)
		
		# Força o HUD a atualizar se ele existir
		if hud and hud.has_method("atualizar_coracoes"):
			hud.atualizar_coracoes(Global.vidas)
		
		if Global.vidas > 0:
			# Teletransporte para o ponto correto
			body.call_deferred("set_global_position", ponto_de_destino.global_position)
			
			# Zera a velocidade física
			if "velocity" in body:
				body.velocity = Vector2.ZERO 
		else:
			print("GAME OVER!")
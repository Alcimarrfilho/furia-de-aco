extends Area2D

const SPEED = 200.0
var direcao = 1 # Vai ser definido pelo ninja na hora do tiro

func _process(delta):
	# Faz o objeto voar para a frente
	position.x += SPEED * direcao * delta

# SINAIS DE COLISÃO 

# Conecte o sinal 'body_entered' do Area2D (Trem) nesta função na aba 'Nó'
func _on_body_entered(body):
	# Se bater no jogador, dá dano
	if body.is_in_group("player") or "cavaleiro" in body.name.to_lower():
		if body.has_method("receber_dano"):
			body.receber_dano(1, global_position.x)
		queue_free() # Destrói o projétil
	
	# Se bater no chão/parede, também destrói
	elif body is TileMap:
		queue_free()

func _ready():
	# Destrói o projétil depois de 3 segundos para não pesar o jogo
	await get_tree().create_timer(3.0).timeout
	queue_free()

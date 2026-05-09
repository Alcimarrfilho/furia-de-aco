extends CharacterBody2D

# CONFIGURAÇÕES DO INIMIGO
var velocidade = 30.0
var direcao = -1
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")

# LIMITES DA PATRULHA
var tamanho_patrulha = 150.0
var limite_esquerdo = 0.0
var limite_direito = 0.0

# --- NOVIDADES PARA A MORTE E MOEDAS ---
var morto = false
var cena_moeda = preload("res://moeda.tscn") # Carrega a cena da moeda

func _ready():
	limite_esquerdo = position.x - tamanho_patrulha
	limite_direito = position.x + tamanho_patrulha

func _physics_process(delta):
	# Se estiver morto, ele não deve se mover nem processar gravidade
	if morto:
		return

	if not is_on_floor():
		velocity.y += gravidade * delta

	if is_on_wall():
		direcao = direcao * -1

	if position.x <= limite_esquerdo:
		direcao = 1
	elif position.x >= limite_direito:
		direcao = -1

	velocity.x = direcao * velocidade

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()

# Esta função será chamada pela espada do cavaleiro
func tomar_dano():
	if morto: return # Se já estiver morto, ignora
	
	morto = true # Ativa o estado de morte
	velocity = Vector2.ZERO # Para o movimento na hora
	
	$AnimatedSprite2D.play("morte") # Toca a animação que você criou fatiando o Death.png
	
	# Desativa a colisão para o cavaleiro não bater no "cadáver"
	$CollisionShape2D.set_deferred("disabled", true)

# --- FUNÇÃO PARA SOLTAR AS MOEDAS ---
func soltar_moedas():
	# solta 3 moedas
	for i in range(3):
		var nova_moeda = cena_moeda.instantiate()
		# Coloca a moeda na posição do inimigo com um pequeno desvio para os lados
		nova_moeda.global_position = global_position + Vector2(randf_range(-25, 25), -10)
		# Adiciona a moeda na cena principal (o parent do inimigo)
		get_parent().add_child(nova_moeda)

#  CONECTE O SINAL animation_finished AQUI 
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "morte":
		soltar_moedas() # Chama a função de soltar moedas
		queue_free()   # Agora sim, apaga o inimigo do jogo
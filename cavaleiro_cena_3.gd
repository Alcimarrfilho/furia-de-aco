extends CharacterBody2D

const VELOCIDADE = 300.0
const FORCA_PULO = -600.0
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D

# Variável que controla o que ele está fazendo no momento
var estado = "normal" 

func _physics_process(delta):
	# Aplica a Gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Lógica do botão F (Ação de Atacar/Defender)
	# ao apertar o F AGORA: Dá a espadada
	if Input.is_action_just_pressed("atacar") and is_on_floor():
		estado = "atacando"
		anim.play("atacar")
		velocity.x = 0 # Fica parado para bater

	# Se está SEGURANDO o F (e já terminou o ataque): Defende
	elif Input.is_action_pressed("atacar") and estado != "atacando" and is_on_floor():
		estado = "defendendo"
		anim.play("defender")
		velocity.x = 0 # Fica parado enquanto defende

	# Se SOLTOU o F e estava defendendo ele volta ao normal
	elif Input.is_action_just_released("atacar") and estado == "defendendo":
		estado = "normal"


	# Movimento Normal 
	if estado == "normal":
		var direcao = Input.get_axis("ui_left", "ui_right")
		
		# Andar
		if direcao:
			velocity.x = direcao * VELOCIDADE
			anim.flip_h = (direcao == -1) # Vira para a esquerda ou direita
			if is_on_floor():
				anim.play("andar")
		else:
			velocity.x = move_toward(velocity.x, 0, VELOCIDADE)
			if is_on_floor():
				anim.play("idle")

		# Pular
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = FORCA_PULO

		# Animação caindo/pulando
		if not is_on_floor():
			anim.play("pular")

	# Executa a física
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "atacar":
		# Quando a animação da espada acaba, ele volta ao normal.
		estado = "normal"
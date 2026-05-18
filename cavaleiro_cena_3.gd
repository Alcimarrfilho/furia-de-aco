extends CharacterBody2D

const VELOCIDADE = 450.0 
const VELOCIDADE_DEFESA = 300.0 
const FORCA_PULO = -550.0 
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D

var estado = "normal" 
var vidas = 3 # Sistema de vidas adicionado!

func _physics_process(delta):
	# Aplica a Gravidade
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Lógica do botão F (Ação de Atacar/Defender)
	if Input.is_action_just_pressed("atacar") and is_on_floor():
		estado = "atacando"
		anim.play("atacar")
		velocity.x = 0 
		
	elif Input.is_action_pressed("atacar") and estado != "atacando" and is_on_floor():
		estado = "defendendo"
		anim.play("defender")
		
	elif Input.is_action_just_released("atacar") and estado == "defendendo":
		estado = "normal"

	# Movimentação 
	if estado == "normal" or estado == "defendendo":
		var direcao = Input.get_axis("ui_left", "ui_right")
		
		var velocidade_atual = VELOCIDADE
		if estado == "defendendo":
			velocidade_atual = VELOCIDADE_DEFESA
		
		# Andar para os lados
		if direcao:
			velocity.x = direcao * velocidade_atual
			anim.flip_h = (direcao == -1) 
			
			if is_on_floor() and estado == "normal":
				anim.play("andar")
		else:
			velocity.x = move_toward(velocity.x, 0, velocidade_atual)
			
			if is_on_floor() and estado == "normal":
				anim.play("idle")

		# Pular 
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and estado == "normal":
			velocity.y = FORCA_PULO

		# Animação de pulo/queda
		if not is_on_floor() and estado == "normal":
			anim.play("pular")

	# Executa a física
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "atacar":
		if Input.is_action_pressed("atacar"):
			estado = "defendendo"
		else:
			estado = "normal"
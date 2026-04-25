extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Puxa o desenho 
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Aplica a Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Faz o Pulo (Barra de Espaço)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Descobre os botoes direita ou esquerda
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# Vira o boneco para o lado certo
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Aplica o movimento na tela 
	move_and_slide()
	
	# Rastreador para ver posiçao:
	print("Minha posição é: ", position)

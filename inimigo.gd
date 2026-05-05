extends CharacterBody2D

var velocidade = 100.0
var direcao = -1 # Começa andando para a esquerda
var gravidade = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Aplica a gravidade para ele não flutuar
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Faz ele andar
	velocity.x = direcao * velocidade

	# Se bater em uma parede (ou degrau), ele vira para o outro lado
	if is_on_wall():
		direcao = direcao * -1
		# Vira a imagem dele para o lado certo
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

	move_and_slide()
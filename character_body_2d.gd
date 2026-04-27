extends CharacterBody2D
const SPEED = 300.0  
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attacking = false
var attack_cooldown = 0.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Ataque
	if Input.is_action_just_pressed("atacar") and is_on_floor() and not attacking:
		attacking = true
		attack_cooldown = 0.6
		sprite.play("attack")
	
	if attacking:
		if sprite.animation != "attack":
			sprite.animation = "attack"
			sprite.play()
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			attacking = false

	move_and_slide()

	# Controla as animações SÓ SE não estiver atacando
	if not attacking:
		if not is_on_floor():
			if sprite.animation != "jump":
				sprite.animation = "jump"
				sprite.play()
		elif direction != 0:
			if sprite.animation != "run":
				sprite.animation = "run"
				sprite.play()
		else:
			if sprite.animation != "idle":
				sprite.animation = "idle"
				sprite.play()

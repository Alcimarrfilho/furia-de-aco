extends CharacterBody2D

var velocidade = 150.0
var direcao = 1 
var esta_morto = false # NOVIDADE: Variável para saber se ele já tomou o golpe

const MOEDA_SCENE = preload("res://moeda.tscn")

func _physics_process(delta: float) -> void:
	# 1. Gravidade
	if not is_on_floor():
		velocity.y += 1200 * delta
		
	# NOVIDADE: Se ele estiver morto, ele não anda mais (velocidade horizontal zera)
	if esta_morto:
		velocity.x = 0
		move_and_slide()
		return # O "return" faz o código parar aqui e não executar o resto abaixo

	# 2. Movimento horizontal
	velocity.x = direcao * velocidade
	move_and_slide()

	# 3. Inteligência Artificial (IA)
	if is_on_wall() or not $RayCast2D.is_colliding():
		direcao *= -1
		$Sprite2D.flip_h = ! $Sprite2D.flip_h
		$RayCast2D.position.x *= -1

func _on_area_dano_body_entered(body: Node2D) -> void:
	# Se ele já estiver morto, não dá mais dano no jogador
	if esta_morto:
		return
		
	if body.name == "cavaleiro":
		# Em vez de mexer no Global, ele manda o Cavaleiro se virar com o dano
		if body.has_method("tomar_dano"):
			body.tomar_dano()

# ATUALIZAÇÃO: A morte dramática!
func tomar_dano():
	# Evita que ele tome dano duas vezes seguidas
	if esta_morto:
		return
		
	esta_morto = true
	
	# Desativa o Hurtbox para ele não te dar dano enquanto cai morto
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	
	# --- ADICIONADO: Lógica do Drop ---
	var nova_moeda = MOEDA_SCENE.instantiate()
	get_parent().add_child(nova_moeda)
	nova_moeda.global_position = global_position
	# ----------------------------------
	
	# Troque "morte" pelo nome exato da animação que você criou no AnimationPlayer
	$AnimationPlayer.play("morte")
	
	# O "await" faz o Godot pausar essa função até a animação terminar
	await $AnimationPlayer.animation_finished
	
	# Agora sim ele some da tela
	queue_free()
